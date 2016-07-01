From: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 05/12] selinux: Implement Infiniband PKey "Access" access vector
Date: Fri, 1 Jul 2016 12:29:14 -0400
Message-ID: <CAGH-KgtNiMrLVz_fMG22WcpAL3EQq9ike=EYHfxbBa4Sg2-R8A@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com> <1466711578-64398-6-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466711578-64398-6-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add a type and access vector for PKeys. Implement the qp_pkey_access
> and mad_agent_pkey_access hooks to check that the caller has
> permission to access the PKey on the given subnet prefix.  Add an
> interface to get the PKey SID. Walk the PKey ocontexts to find an entry
> for the given subnet prefix and pkey.
>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/linux/lsm_audit.h                        |  7 ++++
>  security/selinux/hooks.c                         | 41 ++++++++++++++++++++++++
>  security/selinux/include/classmap.h              |  2 ++
>  security/selinux/include/initial_sid_to_string.h |  1 +
>  security/selinux/include/security.h              |  2 ++
>  security/selinux/ss/services.c                   | 41 ++++++++++++++++++++++++
>  6 files changed, 94 insertions(+)
>
> diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
> index ffb9c9d..8ff7eae 100644
> --- a/include/linux/lsm_audit.h
> +++ b/include/linux/lsm_audit.h
> @@ -45,6 +45,11 @@ struct lsm_ioctlop_audit {
>         u16 cmd;
>  };
>
> +struct lsm_pkey_audit {
> +       u64     subnet_prefix;
> +       u16     pkey;
> +};
> +
>  /* Auxiliary data to use in generating the audit record. */
>  struct common_audit_data {
>         char type;
> @@ -59,6 +64,7 @@ struct common_audit_data {
>  #define LSM_AUDIT_DATA_INODE   9
>  #define LSM_AUDIT_DATA_DENTRY  10
>  #define LSM_AUDIT_DATA_IOCTL_OP        11
> +#define LSM_AUDIT_DATA_PKEY    12
>         union   {
>                 struct path path;
>                 struct dentry *dentry;
> @@ -75,6 +81,7 @@ struct common_audit_data {
>  #endif
>                 char *kmod_name;
>                 struct lsm_ioctlop_audit *op;
> +               struct lsm_pkey_audit *pkey;
>         } u;
>         /* this union contains LSM specific data */
>         union {

Please correct me if I'm wrong, but I don't recall seeing any code in
the patchset which actually logs the extra IB information in the audit
record, did I miss it?

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 4f13ea4..5a40b10 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6018,6 +6018,44 @@ static void selinux_unregister_ib_flush_callback(void)
>         mutex_unlock(&ib_flush_mutex);
>  }
>
> +static int selinux_pkey_access(u64 subnet_prefix, u16 pkey_val, void *security)
> +{
> +       struct common_audit_data ad;
> +       int err;
> +       u32 sid = 0;
> +       struct ib_security_struct *sec = security;
> +       struct lsm_pkey_audit pkey;
> +
> +       err = security_pkey_sid(subnet_prefix, pkey_val, &sid);
> +
> +       if (err)
> +               goto out;

Pet peeve of mine, just do the return here directly, there is no need
to jump to out.

> +       ad.type = LSM_AUDIT_DATA_PKEY;
> +       pkey.subnet_prefix = subnet_prefix;
> +       pkey.pkey = pkey_val;
> +       ad.u.pkey = &pkey;
> +       err = avc_has_perm(sec->sid, sid,
> +                          SECCLASS_INFINIBAND_PKEY,
> +                          INFINIBAND_PKEY__ACCESS, &ad);

Similar, just return avc_has_perm() directly.

> +out:
> +       return err;
> +}
> +
> +static int selinux_ib_qp_pkey_access(u64 subnet_prefix, u16 pkey_val,
> +                                    struct ib_qp_security *qp_sec)
> +{
> +       return selinux_pkey_access(subnet_prefix, pkey_val,
> +                                  qp_sec->q_security);
> +}
> +
> +static int selinux_ib_mad_agent_pkey_access(u64 subnet_prefix, u16 pkey_val,
> +                                           struct ib_mad_agent *mad_agent)
> +{
> +       return selinux_pkey_access(subnet_prefix, pkey_val,
> +                                       mad_agent->m_security);
> +}
> +
>  static int selinux_ib_qp_alloc_security(struct ib_qp_security *qp_sec)
>  {
>         struct ib_security_struct *sec;
> @@ -6248,6 +6286,9 @@ static struct security_hook_list selinux_hooks[] = {
>                       selinux_register_ib_flush_callback),
>         LSM_HOOK_INIT(unregister_ib_flush_callback,
>                       selinux_unregister_ib_flush_callback),
> +       LSM_HOOK_INIT(ib_qp_pkey_access, selinux_ib_qp_pkey_access),
> +       LSM_HOOK_INIT(ib_mad_agent_pkey_access,
> +                     selinux_ib_mad_agent_pkey_access),
>         LSM_HOOK_INIT(ib_qp_alloc_security,
>                       selinux_ib_qp_alloc_security),
>         LSM_HOOK_INIT(ib_qp_free_security,
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 1f1f4b2..d42dd4d 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -165,5 +165,7 @@ struct security_class_mapping secclass_map[] = {
>           { COMMON_CAP_PERMS, NULL } },
>         { "cap2_userns",
>           { COMMON_CAP2_PERMS, NULL } },
> +       { "infiniband_pkey",
> +         { "access", NULL } },
>         { NULL }
>    };
> diff --git a/security/selinux/include/initial_sid_to_string.h b/security/selinux/include/initial_sid_to_string.h
> index a59b64e..8f2eefc 100644
> --- a/security/selinux/include/initial_sid_to_string.h
> +++ b/security/selinux/include/initial_sid_to_string.h
> @@ -29,5 +29,6 @@ static const char *initial_sid_to_string[] =
>      "policy",
>      "scmp_packet",
>      "devnull",
> +    "pkey",
>  };
>
> diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
> index a7e6ed2..8f1a66e 100644
> --- a/security/selinux/include/security.h
> +++ b/security/selinux/include/security.h
> @@ -180,6 +180,8 @@ int security_get_user_sids(u32 callsid, char *username,
>
>  int security_port_sid(u8 protocol, u16 port, u32 *out_sid);
>
> +int security_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid);
> +
>  int security_netif_sid(char *name, u32 *if_sid);
>
>  int security_node_sid(u16 domain, void *addr, u32 addrlen,
> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index 89df646..49701a5 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -2229,6 +2229,47 @@ out:
>  }
>
>  /**
> + * security_pkey_sid - Obtain the SID for a pkey.
> + * @subnet_prefix: Subnet Prefix
> + * @pkey_num: pkey number
> + * @out_sid: security identifier
> + */
> +int security_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid)
> +{
> +       struct ocontext *c;
> +       int rc = 0;
> +
> +       read_lock(&policy_rwlock);
> +
> +       c = policydb.ocontexts[OCON_PKEY];
> +       while (c) {
> +               if (c->u.pkey.low_pkey <= pkey_num &&
> +                   c->u.pkey.high_pkey >= pkey_num &&
> +                   c->u.pkey.subnet_prefix == subnet_prefix)
> +                       break;
> +
> +               c = c->next;
> +       }
> +
> +       if (c) {
> +               if (!c->sid[0]) {
> +                       rc = sidtab_context_to_sid(&sidtab,
> +                                                  &c->context[0],
> +                                                  &c->sid[0]);
> +                       if (rc)
> +                               goto out;
> +               }
> +               *out_sid = c->sid[0];
> +       } else {
> +               *out_sid = SECINITSID_PKEY;
> +       }
> +
> +out:
> +       read_unlock(&policy_rwlock);
> +       return rc;
> +}

I wondered about this earlier in the patchset when we were discussing
the policy format, and I'm still wondering; perhaps you can help me
understand IB a bit better ...

>From what I gather, the partition key is the IB security boundary, not
the subnet, is that true?  If so, why are we including the subnet with
the partition key value/label?  I understand the low/high pkey range
as a way of simplifying the policy, but I don't quite understand the
point of tying the subnet to the partition key label.  Would you ever
want to have multiple labels for a single partition key, or should it
be a single label for the partition key regardless of the subnet?

-- 
paul moore
security @ redhat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
