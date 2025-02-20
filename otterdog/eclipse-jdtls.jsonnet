local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('eclipse.jdt.ls', 'eclipse-jdtls') {
  settings+: {
    description: "",
    name: "Eclipse JDT LS",
    web_commit_signoff_required: false,
    workflows+: {
      default_workflow_permissions: "write",
    },
  },
  webhooks+: [
    orgs.newOrgWebhook('https://ci.eclipse.org/ls/github-webhook/') {
      content_type: "json",
      events+: [
        "pull_request",
        "push"
      ],
    },
  ],
  secrets+: [
    orgs.newOrgSecret('ECLIPSE_GITLAB_API_TOKEN') {
      selected_repositories+: [
        "eclipse.jdt.ls"
      ],
      value: "pass:bots/eclipse.jdt.ls/gitlab.eclipse.org/api-token",
      visibility: "selected",
    },
  ],
  _repositories+:: [
    orgs.newRepo('eclipse-jdt-core-incubator') {
      default_branch: "dom-with-javac",
      delete_branch_on_merge: false,
      dependabot_alerts_enabled: false,
      has_discussions: true,
      web_commit_signoff_required: false,
      workflows+: {
        default_workflow_permissions: "write",
      },
    },
    orgs.newRepo('eclipse.jdt.ls') {
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      dependabot_security_updates_enabled: true,
      description: "Java language server",
      has_discussions: true,
      squash_merge_commit_title: "PR_TITLE",
      topics+: [
        "eclipse",
        "java",
        "language-server-protocol"
      ],
      web_commit_signoff_required: false,
      webhooks: [
        orgs.newRepoWebhook('https://hooks.waffle.io/api/projects/57e1520d88710fd001c25c9e/sources/57e15250097d9e01017605f3/receive') {
          content_type: "json",
          events+: [
            "*"
          ],
          secret: "********",
        },
        orgs.newRepoWebhook('https://github.hipch.at/incoming?r=3205333&i=883df964-ce54-4c57-8dd3-88ccd826bde7') {
          content_type: "json",
          events+: [
            "commit_comment",
            "create",
            "delete",
            "deployment",
            "deployment_status",
            "fork",
            "gollum",
            "issue_comment",
            "issues",
            "member",
            "public",
            "pull_request",
            "pull_request_review_comment",
            "push",
            "release",
            "status",
            "team_add",
            "watch"
          ],
          secret: "********",
        },
        orgs.newRepoWebhook('https://ci.eclipse.org/ls/github-webhook/') {
          events+: [
            "push"
          ],
        },
        orgs.newRepoWebhook('https://ci.eclipse.org/ls/ghprbhook/') {
          events+: [
            "issue_comment",
            "pull_request"
          ],
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('master') {
          required_approving_review_count: null,
          requires_pull_request: false,
          requires_status_checks: false,
          requires_strict_status_checks: true,
        },
      ],
    },
  ],
} + {
  # snippet added due to 'https://github.com/EclipseFdn/otterdog-configs/blob/main/blueprints/add-dot-github-repo.yml'
  _repositories+:: [
    orgs.newRepo('.github')
  ],
}
