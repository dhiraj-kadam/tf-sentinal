 policy "enforce-s3-server-side-encryption-enabled-true" {
    source            = "./tenforce-s3-server-side-encryption-enabled-true.sentinel"
    enforcement_level = "hard-mandatory"
}