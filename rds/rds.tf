module "db" {
  source                      = "terraform-aws-modules/rds/aws"
  identifier                  = local.resource_name
  engine                      = "mysql"
  engine_version              = "8.0.40"
  instance_class              = "db.t4g.micro"
  allocated_storage           = 20
  db_name                     = "transactions"
  username                    = "root"
  password                    = "ExpenseApp1"
  manage_master_user_password = false
  vpc_security_group_ids = [local.mysql_sg_id]
  # DB subnet group
  create_db_subnet_group      = false
  db_subnet_group_name = local.database_subnet_group_name


  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false
  skip_final_snapshot = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]

  tags = merge(
    var.common_tags,
    {
      Name = local.resource_name
    }
  )
}
