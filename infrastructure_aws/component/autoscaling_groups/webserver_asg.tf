# Creating AutoScaling Group
resource "aws_autoscaling_group" "webserver_asg" {
	count = "${var.count}"
	launch_configuration = "${var.webserver_lc_id}"
	availability_zones = ["${var.webserver_availability_zones}"]
	name = "${var.environment}-webserver_asg"
	max_size = "${var.asg_max}"
	min_size = "${var.asg_min}"
	load_balancers = ["${var.webserver_elb_name}"]
	health_check_type = "ELB"
	tag {
		key = "Name"
		value = "${var.environment}-asg"
		propagate_at_launch = true
	}	
	lifecycle {
		create_before_destroy = true
	}
}

# Scale Up Policy and Alarm
resource "aws_autoscaling_policy" "scale_up" {
	count = "${var.count}"
	name = "${var.environment}_asg_scale_up"
	scaling_adjustment = 2
	adjustment_type = "ChangeInCapacity"
	cooldown = 300
	autoscaling_group_name = "${aws_autoscaling_group.webserver_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
	count = "${var.count}"
	alarm_name = "${var.environment}_high_asg_cpu"
	comparison_operator = "GreaterThanThreshold"
	evaluation_periods = "2"
	metric_name = "CPUUtilization"
	namespace = "AWS/EC2"
	period = "120"
	statistic = "Average"
	threshold = "80"
	insufficient_data_actions = []
	dimensions {
		AutoScalingGroupName = "${aws_autoscaling_group.webserver_asg.name}"
	}
	alarm_description = "EC2 CPU Utilization"
	alarm_actions = ["${aws_autoscaling_policy.scale_up.arn}"]
}

# Scale Down Policy and Alarm
resource "aws_autoscaling_policy" "scale_down" {
	count = "${var.count}"
	name = "${var.environment}_asg_scale_down"
	scaling_adjustment = -1
	adjustment_type = "ChangeInCapacity"
	cooldown = 600
	autoscaling_group_name = "${aws_autoscaling_group.webserver_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
	count = "${var.count}"
	alarm_name = "${var.environment}_low_asg_cpu"
	comparison_operator = "LessThanThreshold"
	evaluation_periods = "5"
	metric_name = "CPUUtilization"
	namespace = "AWS/EC2"
	period = "120"
	statistic = "Average"
	threshold = "30"
	insufficient_data_actions = []
	dimensions {
		AutoScalingGroupName = "${aws_autoscaling_group.webserver_asg.name}"
	}
	alarm_description = "EC2 CPU Utilization"
	alarm_actions = ["${aws_autoscaling_policy.scale_down.arn}"]
}

output "asg_id" {	
	value = "${element(concat(aws_autoscaling_group.webserver_asg.*.id, list("")),0)}"
}