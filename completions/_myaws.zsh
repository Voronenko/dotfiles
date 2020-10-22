#compdef myaws

_myaws-commands() {
  local -a commands

  commands=(
    'autoscaling: Manage autoscaling resources'
    'ec2: Manage EC2 resources'
    'ec2ri: Manage EC2 Reserved Instance resources'
    'ecr: Manage ECR resources'
    'elb: Manage ELB resources'
    'help: Help about any command'
    'iam: Manage IAM resources'
    'rds: Manage RDS resources'
    'ssm: Manage SSM resources'
    'sts: Manage STS resources'
    'version: Print version'
  )

  _arguments -s : $nul_args && ret=0
  _describe -t commands 'myaws command' commands && ret=0
}

_myaws_autoscaling() {
  local -a commands
  commands=(
    'attach: Attach instances/loadbalancers to autoscaling group'
    'detach: Detach instances/loadbalancers from autoscaling group'
    'ls: List autoscaling groups'
    'update: Update autoscaling group'
  )
  _describe -t commands 'autoscaling' commands && ret=0
}

_myaws_ec2() {
  local -a commands
  commands=(
    'ls: List EC2 instances'
    'ssh: SSH to EC2 instances'
    'start: Start EC2 instances'
    'stop: Stop EC2 instances'
  )
  _describe -t commands 'ec2' commands && ret=0
}

_myaws_ec2ri() {
  local -a commands
  commands=(
    'ls:  List EC2 Reserved Instances'
  )
  _describe -t commands 'ec2ri' commands && ret=0
}


_myaws_ecr() {
  local -a commands
  commands=(
    'get-login: Get docker login command for ECR'
  )
  _describe -t commands 'ecr' commands && ret=0
}


_myaws_elb() {
  local -a commands
  commands=(
    'ls: List ELB instances'
    'ps: Show ELB instances'
  )
  _describe -t commands 'elb' commands && ret=0
}

_myaws_iam() {
  local -a commands
  commands=(
    'user: Manage IAM user resources'
  )
  _describe -t commands 'iam' commands && ret=0
}

_myaws_rds() {
  local -a commands
  commands=(
    'ls: List RDS instances'
  )
  _describe -t commands 'rds' commands && ret=0
}


_myaws_ssm() {
  local -a commands
  commands=(
    'parameter: Manage SSM parameter resources'
  )
  _describe -t commands 'ssm' commands && ret=0
}


_myaws_sts() {
  local -a commands
  commands=(
    'id: Get caller identity'
  )
  _describe -t commands 'sts' commands && ret=0
}


_myaws() {
  local -a nul_args
  nul_args=(
    # '(-h --help)'{-h,--help}'[show help message and exit]'
    # '(--debug)'{--debug}'[Enable debug mode]'
    # '(--config)'{--config}'[config file]'
    # '(--humanize)'{--humanize}'[Use Human friendly format for time (default true)]'
    # '(--profile)'{--profile}'[AWS profile (default none and used AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY environment variables.)]'
    # '(--region)'{--region}'[AWS region (default none and used AWS_DEFAULT_REGION environment variable.]'
    # '(--timezone)'{--timezone}'[Time zone, such as UTC, Asia/Tokyo (default "Local")]'
  )

  local curcontext=$curcontext ret=1

  if ((CURRENT == 2)); then
    _myaws-commands
  else
    shift words
    (( CURRENT -- ))
    curcontext="${curcontext%:*:*}:myaws-$words[1]:"
    case $words[1] in
    autoscaling)
      _myaws_autoscaling && ret=0
      ;;
    ec2)
      _myaws_ec2 && ret=0
      ;;
    ec2ri)
      _myaws_ec2ri && ret=0
      ;;
    ecr)
      _myaws_ecr && ret=0
      ;;
    elb)
      _myaws_elb && ret=0
      ;;
    iam)
      _myaws_iam && ret=0
      ;;
    rds)
      _myaws_rds && ret=0
      ;;
    ssm)
      _myaws_ssm && ret=0
      ;;
    sts)
      _myaws_sts && ret=0
      ;;


    esac  fi
}

_myaws "$@"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
