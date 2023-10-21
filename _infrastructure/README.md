## Installation

- [Install `terraform`](https://developer.hashicorp.com/terraform/downloads)
- [Install `task`](https://taskfile.dev/installation/)

## Usage

Infrastructure must be deployed or destroyed using tasks. 

To run a task, execute the following from the directory, where the `Taskfile.yml` is located:

`task <task_name> -- <environment> <stack_name>`

- `<task_name>`: the name of the task you want to run
- `<environment>`: the name of the environment you want to deploy to (e.g. staging, production)
- `<stack_name>`: the name of the stack you want to apply the Terraform command to (e.g. network, registry, service)

### Basic Task List

- `tf_init`: Initializes a Terraform stack. Do not use on the organization stack. Usage: `task tf_init -- <environment> <stack_name>`
- `tf_apply`: Applies a Terraform stack. Usage: `task tf_apply -- <environment> <stack_name>`
- `tf_destroy`: Destroys a Terraform stack. BE CAREFUL! Usage: `task tf_destroy -- <environment> <stack_name>`
- `tf_console`: Opens a Terraform console for a stack. Usage: `task tf_console -- <environment> <stack_name>`

There are more commands than what is listed above. Refer to the Taskfile for usage instructions.

### Stack Dependencies

There is an order of dependencies for stacks. It goes:

1. domain - this will require the manual step of adding cnames to namecheap
2. vpn
3. network
4. registry
5. secrets
6. persistence
7. service
8. ci

If you need to destroy a stack, you must destroy the stacks which depend on it first or else you will run into problems and need to repair your state/infrastructure before you proceed.

### Architecture
* The code architecture makes it so stacks resources are deployed on a per-stack basis. Dependent stacks will share resources using terraform outputs.

* There will be a registry that can only be accessed by Github runners and from inside the private subnet (VPC or ECS).

* There will be a postgres database in RDS that is only accessible from inside the VPC (or through the VPN)

* There will be two ECS Fargate services. They ECS service will sit behind a load balancer.

### VPN
Once you've set up the vpn stack you need to run a command to create clients. The `task vpn_create_client -- <my_user>` command will create and output the .ovpn file for your user. Use that .ovpn file to connect to the VPC via OpenVPN. If you need to go into the vpn instance for some reason you can use `task vpn_ssh`. These commands will only work if your .ssh key has been added for access. The SSH key from your computer at `~/.ssh/id_rsa.pub` will automatically be added if you created the vpn stack.
