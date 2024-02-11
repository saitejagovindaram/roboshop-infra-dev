Create Load Balancer --> without Attaching any target group(using terrform possible)
Create Listnere for Load Balancer

Launch Server
Provision Server
Stop Server
Take AMI
Delete Server
Create Launch Template
Create Target Group
Create Auto Scaling Group --> attach your Auto Scaling group to an existing load balancer


### create target group.
deregistration_delay:
    Your auto-scaling group determines that an instance is no longer needed due to decreased traffic.
    The instance is marked for termination.
    Instead of immediately removing it from the target group, the system waits for the deregistration delay period to expire (e.g., 5 minutes).
    During these 5 minutes, any existing connections to that instance are allowed to complete.
    After the 5-minute delay, the instance is removed from the target group, and new connections will be routed to other healthy instances.

### create auto scaling group
    -> Launch Template is mandatory for Auto Scaling Group
    -> Instance refresh is a feature provided by AWS Auto Scaling that allows you to update instances in an Auto Scaling group with a new launch template or configuration while maintaining the availability and capacity of your application. This feature automates the process of replacing existing instances with updated ones, reducing downtime and manual intervention required for updates.