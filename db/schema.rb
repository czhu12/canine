# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_20_231224) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_invitations", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "invited_by_id"
    t.string "token", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.jsonb "roles", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "email"], name: "index_account_invitations_on_account_id_and_email", unique: true
    t.index ["invited_by_id"], name: "index_account_invitations_on_invited_by_id"
    t.index ["token"], name: "index_account_invitations_on_token", unique: true
  end

  create_table "account_users", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "user_id"
    t.jsonb "roles", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "user_id"], name: "index_account_users_on_account_id_and_user_id", unique: true
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "owner_id"
    t.boolean "personal", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "extra_billing_info"
    t.string "domain"
    t.string "subdomain"
    t.string "billing_email"
    t.integer "account_users_count", default: 0
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "action_text_embeds", force: :cascade do |t|
    t.string "url"
    t.jsonb "fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "add_ons", force: :cascade do |t|
    t.bigint "cluster_id", null: false
    t.string "name", null: false
    t.string "chart_type", null: false
    t.integer "status", default: 0, null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cluster_id", "name"], name: "index_add_ons_on_cluster_id_and_name", unique: true
    t.index ["cluster_id"], name: "index_add_ons_on_cluster_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.integer "address_type"
    t.string "line1"
    t.string "line2"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "announcements", force: :cascade do |t|
    t.string "kind"
    t.string "title"
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token"
    t.string "name"
    t.jsonb "metadata"
    t.boolean "transient", default: false
    t.datetime "last_used_at", precision: nil
    t.datetime "expires_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_api_tokens_on_user_id"
  end

  create_table "builds", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "repository_url"
    t.string "git_sha"
    t.string "commit_message"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commit_sha", null: false
    t.index ["project_id"], name: "index_builds_on_project_id"
  end

  create_table "clusters", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "kubeconfig", default: {}, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_clusters_on_user_id"
  end

  create_table "connected_accounts", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "provider"
    t.string "uid"
    t.string "refresh_token"
    t.datetime "expires_at", precision: nil
    t.text "auth"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "access_token"
    t.string "access_token_secret"
    t.string "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_connected_accounts_on_owner_id_and_owner_type"
  end

  create_table "cron_schedules", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.string "schedule", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_cron_schedules_on_service_id"
  end

  create_table "deployments", force: :cascade do |t|
    t.bigint "build_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_deployments_on_build_id"
  end

  create_table "domains", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.string "domain_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_domains_on_service_id"
  end

  create_table "environment_variables", force: :cascade do |t|
    t.string "name", null: false
    t.text "value"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "name"], name: "index_environment_variables_on_project_id_and_name", unique: true
    t.index ["project_id"], name: "index_environment_variables_on_project_id"
  end

  create_table "inbound_webhooks", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "log_outputs", force: :cascade do |t|
    t.bigint "loggable_id", null: false
    t.string "loggable_type", null: false
    t.text "output"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "noticed_events", force: :cascade do |t|
    t.bigint "account_id"
    t.string "type"
    t.string "record_type"
    t.bigint "record_id"
    t.jsonb "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notifications_count"
    t.index ["account_id"], name: "index_noticed_events_on_account_id"
    t.index ["record_type", "record_id"], name: "index_noticed_events_on_record"
  end

  create_table "noticed_notifications", force: :cascade do |t|
    t.bigint "account_id"
    t.string "type"
    t.bigint "event_id", null: false
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.datetime "read_at", precision: nil
    t.datetime "seen_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_noticed_notifications_on_account_id"
    t.index ["event_id"], name: "index_noticed_notifications_on_event_id"
    t.index ["recipient_type", "recipient_id"], name: "index_noticed_notifications_on_recipient"
  end

  create_table "notification_tokens", force: :cascade do |t|
    t.bigint "user_id"
    t.string "token", null: false
    t.string "platform", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notification_tokens_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type"
    t.jsonb "params"
    t.datetime "read_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "interacted_at", precision: nil
    t.index ["account_id"], name: "index_notifications_on_account_id"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient_type_and_recipient_id"
  end

  create_table "pay_charges", force: :cascade do |t|
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.integer "amount_refunded"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.jsonb "data"
    t.integer "application_fee_amount"
    t.string "currency"
    t.jsonb "metadata"
    t.integer "subscription_id"
    t.bigint "customer_id"
    t.string "stripe_account"
    t.index ["customer_id", "processor_id"], name: "index_pay_charges_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_customers", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor"
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_account"
    t.index ["owner_type", "owner_id", "deleted_at"], name: "customer_owner_processor_index"
    t.index ["processor", "processor_id"], name: "index_pay_customers_on_processor_and_processor_id"
  end

  create_table "pay_merchants", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor"
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "processor"], name: "index_pay_merchants_on_owner_type_and_owner_id_and_processor"
  end

  create_table "pay_payment_methods", force: :cascade do |t|
    t.bigint "customer_id"
    t.string "processor_id"
    t.boolean "default"
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_account"
    t.index ["customer_id", "processor_id"], name: "index_pay_payment_methods_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_subscriptions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "trial_ends_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
    t.jsonb "data"
    t.decimal "application_fee_percent", precision: 8, scale: 2
    t.jsonb "metadata"
    t.bigint "customer_id"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.boolean "metered"
    t.string "pause_behavior"
    t.datetime "pause_starts_at"
    t.datetime "pause_resumes_at"
    t.string "payment_method_id"
    t.string "stripe_account"
    t.index ["customer_id", "processor_id"], name: "index_pay_subscriptions_on_customer_id_and_processor_id", unique: true
    t.index ["metered"], name: "index_pay_subscriptions_on_metered"
    t.index ["pause_starts_at"], name: "index_pay_subscriptions_on_pause_starts_at"
  end

  create_table "pay_webhooks", force: :cascade do |t|
    t.string "processor"
    t.string "event_type"
    t.jsonb "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "amount", default: 0, null: false
    t.string "interval", null: false
    t.jsonb "details"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "trial_period_days", default: 0
    t.boolean "hidden"
    t.string "currency"
    t.integer "interval_count", default: 1
    t.string "description"
    t.string "unit_label"
    t.boolean "charge_per_unit"
    t.string "stripe_id"
    t.string "braintree_id"
    t.string "paddle_billing_id"
    t.string "paddle_classic_id"
    t.string "lemon_squeezy_id"
    t.string "fake_processor_id"
    t.string "contact_url"
  end

  create_table "project_add_ons", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "add_on_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["add_on_id"], name: "index_project_add_ons_on_add_on_id"
    t.index ["project_id"], name: "index_project_add_ons_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.string "repository_url", null: false
    t.string "branch", default: "main", null: false
    t.bigint "cluster_id", null: false
    t.boolean "autodeploy", default: true, null: false
    t.string "dockerfile_path", default: "./Dockerfile", null: false
    t.string "docker_build_context_directory", default: ".", null: false
    t.string "docker_command"
    t.string "predeploy_command"
    t.integer "status", default: 0, null: false
    t.integer "project_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cluster_id"], name: "index_projects_on_cluster_id"
    t.index ["name"], name: "index_projects_on_name", unique: true
  end

  create_table "services", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.integer "service_type", null: false
    t.string "command", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_services_on_project_id"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.string "time_zone"
    t.datetime "accepted_terms_at", precision: nil
    t.datetime "accepted_privacy_at", precision: nil
    t.datetime "announcements_read_at", precision: nil
    t.boolean "admin"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "preferred_language"
    t.boolean "otp_required_for_login"
    t.string "otp_secret"
    t.integer "last_otp_timestep"
    t.text "otp_backup_codes"
    t.jsonb "preferences"
    t.virtual "name", type: :string, as: "(((first_name)::text || ' '::text) || (COALESCE(last_name, ''::character varying))::text)", stored: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "account_invitations", "accounts"
  add_foreign_key "account_invitations", "users", column: "invited_by_id"
  add_foreign_key "account_users", "accounts"
  add_foreign_key "account_users", "users"
  add_foreign_key "accounts", "users", column: "owner_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "add_ons", "clusters"
  add_foreign_key "api_tokens", "users"
  add_foreign_key "builds", "projects"
  add_foreign_key "clusters", "users"
  add_foreign_key "cron_schedules", "services"
  add_foreign_key "deployments", "builds"
  add_foreign_key "domains", "services"
  add_foreign_key "environment_variables", "projects"
  add_foreign_key "pay_charges", "pay_customers", column: "customer_id"
  add_foreign_key "pay_payment_methods", "pay_customers", column: "customer_id"
  add_foreign_key "pay_subscriptions", "pay_customers", column: "customer_id"
  add_foreign_key "project_add_ons", "add_ons"
  add_foreign_key "project_add_ons", "projects"
  add_foreign_key "projects", "clusters"
  add_foreign_key "services", "projects"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
end
