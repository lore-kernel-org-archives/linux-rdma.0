From: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/12] selinux: Add IB End Port SMP access vector
Date: Fri, 1 Jul 2016 14:48:41 -0400
Message-ID: <CAGH-Kgvsu=rknzXW6w1h6Ai24r_RRUKVgN4+yV7AYJw7XZJWUw@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com> <1466711578-64398-7-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466711578-64398-7-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add a type for Infiniband end ports and an access vector for subnet
> management packets. Implement the ib_end_port_smp hook to check that the
> caller has permission to send and receive SMPs on the end port specified
> by the device name and port.  Add interface to query the SID for a IB
> end port, which walks the IB_END_PORT ocontexts to find an entry for the
> given name and port.
>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/linux/lsm_audit.h                        | 32 +++++++++++-------
>  security/selinux/hooks.c                         | 27 +++++++++++++++
>  security/selinux/include/classmap.h              |  2 ++
>  security/selinux/include/initial_sid_to_string.h |  1 +
>  security/selinux/include/security.h              |  2 ++
>  security/selinux/ss/services.c                   | 43 ++++++++++++++++++++++++
>  6 files changed, 95 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
> index 8ff7eae..acf6de7 100644
> --- a/include/linux/lsm_audit.h
> +++ b/include/linux/lsm_audit.h
> @@ -21,6 +21,7 @@
>  #include <linux/path.h>
>  #include <linux/key.h>
>  #include <linux/skbuff.h>
> +#include <rdma/ib_verbs.h>
>
>  struct lsm_network_audit {
>         int netif;
> @@ -50,21 +51,27 @@ struct lsm_pkey_audit {
>         u16     pkey;
>  };
>
> +struct lsm_ib_end_port_audit {
> +       char    dev_name[IB_DEVICE_NAME_MAX];
> +       u8      port;
> +};
> +
>  /* Auxiliary data to use in generating the audit record. */
>  struct common_audit_data {
>         char type;
> -#define LSM_AUDIT_DATA_PATH    1
> -#define LSM_AUDIT_DATA_NET     2
> -#define LSM_AUDIT_DATA_CAP     3
> -#define LSM_AUDIT_DATA_IPC     4
> -#define LSM_AUDIT_DATA_TASK    5
> -#define LSM_AUDIT_DATA_KEY     6
> -#define LSM_AUDIT_DATA_NONE    7
> -#define LSM_AUDIT_DATA_KMOD    8
> -#define LSM_AUDIT_DATA_INODE   9
> -#define LSM_AUDIT_DATA_DENTRY  10
> -#define LSM_AUDIT_DATA_IOCTL_OP        11
> -#define LSM_AUDIT_DATA_PKEY    12
> +#define LSM_AUDIT_DATA_PATH            1
> +#define LSM_AUDIT_DATA_NET             2
> +#define LSM_AUDIT_DATA_CAP             3
> +#define LSM_AUDIT_DATA_IPC             4
> +#define LSM_AUDIT_DATA_TASK            5
> +#define LSM_AUDIT_DATA_KEY             6
> +#define LSM_AUDIT_DATA_NONE            7
> +#define LSM_AUDIT_DATA_KMOD            8
> +#define LSM_AUDIT_DATA_INODE           9
> +#define LSM_AUDIT_DATA_DENTRY          10
> +#define LSM_AUDIT_DATA_IOCTL_OP                11
> +#define LSM_AUDIT_DATA_PKEY            12
> +#define LSM_AUDIT_DATA_IB_END_PORT     13

Some more nit picking ... if you convert "END_PORT" in the other macro
to "ENDPORT" as we discussed, please do the same here.


>         union   {
>                 struct path path;
>                 struct dentry *dentry;
> @@ -82,6 +89,7 @@ struct common_audit_data {
>                 char *kmod_name;
>                 struct lsm_ioctlop_audit *op;
>                 struct lsm_pkey_audit *pkey;
> +               struct lsm_ib_end_port_audit *ib_end_port;
>         } u;
>         /* this union contains LSM specific data */
>         union {
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 5a40b10..fc44542 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6056,6 +6056,32 @@ static int selinux_ib_mad_agent_pkey_access(u64 subnet_prefix, u16 pkey_val,
>                                         mad_agent->m_security);
>  }
>
> +static int selinux_ib_end_port_smp(const char *dev_name, u8 port,
> +                                  struct ib_mad_agent *mad_agent)
> +{
> +       struct common_audit_data ad;
> +       int err;
> +       u32 sid = 0;
> +       struct ib_security_struct *sec = mad_agent->m_security;
> +       struct lsm_ib_end_port_audit ib_end_port;
> +
> +       err = security_ib_end_port_sid(dev_name, port, &sid);
> +
> +       if (err)
> +               goto out;

Just return, don't jump then return.

> +       ad.type = LSM_AUDIT_DATA_IB_END_PORT;
> +       strncpy(ib_end_port.dev_name, dev_name, sizeof(ib_end_port.dev_name));

Do we need to force a NULL byte string terminator here?

> +       ib_end_port.port = port;
> +       ad.u.ib_end_port = &ib_end_port;
> +       err = avc_has_perm(sec->sid, sid,
> +                          SECCLASS_INFINIBAND_END_PORT,
> +                          INFINIBAND_END_PORT__SMP, &ad);
> +
> +out:
> +       return err;
> +}
> +
>  static int selinux_ib_qp_alloc_security(struct ib_qp_security *qp_sec)
>  {
>         struct ib_security_struct *sec;
> @@ -6289,6 +6315,7 @@ static struct security_hook_list selinux_hooks[] = {
>         LSM_HOOK_INIT(ib_qp_pkey_access, selinux_ib_qp_pkey_access),
>         LSM_HOOK_INIT(ib_mad_agent_pkey_access,
>                       selinux_ib_mad_agent_pkey_access),
> +       LSM_HOOK_INIT(ib_end_port_smp, selinux_ib_end_port_smp),
>         LSM_HOOK_INIT(ib_qp_alloc_security,
>                       selinux_ib_qp_alloc_security),
>         LSM_HOOK_INIT(ib_qp_free_security,
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index d42dd4d..21972c8 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -167,5 +167,7 @@ struct security_class_mapping secclass_map[] = {
>           { COMMON_CAP2_PERMS, NULL } },
>         { "infiniband_pkey",
>           { "access", NULL } },
> +       { "infiniband_end_port",
> +         { "smp", NULL } },

Is "smp" really the best permission name?  It doesn't seem very
descriptive or verb-like.

Also, "infiniband_endport" and not "infiniband_end_port" please.

>         { NULL }
>    };
> diff --git a/security/selinux/include/initial_sid_to_string.h b/security/selinux/include/initial_sid_to_string.h
> index 8f2eefc..ba47169 100644
> --- a/security/selinux/include/initial_sid_to_string.h
> +++ b/security/selinux/include/initial_sid_to_string.h
> @@ -30,5 +30,6 @@ static const char *initial_sid_to_string[] =
>      "scmp_packet",
>      "devnull",
>      "pkey",
> +    "ib_end_port",

I'm pretty sure you know what I'm going to suggest here ...

>  };
>
> diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
> index 8f1a66e..f5d9d4e 100644
> --- a/security/selinux/include/security.h
> +++ b/security/selinux/include/security.h
> @@ -182,6 +182,8 @@ int security_port_sid(u8 protocol, u16 port, u32 *out_sid);
>
>  int security_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid);
>
> +int security_ib_end_port_sid(const char *dev_name, u8 port, u32 *out_sid);
> +
>  int security_netif_sid(char *name, u32 *if_sid);
>
>  int security_node_sid(u16 domain, void *addr, u32 addrlen,
> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index 49701a5..9afabee 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -53,6 +53,7 @@
>  #include <linux/flex_array.h>
>  #include <linux/vmalloc.h>
>  #include <net/netlabel.h>
> +#include <rdma/ib_verbs.h>

Why is this here?

>  #include "flask.h"
>  #include "avc.h"
> @@ -2270,6 +2271,48 @@ out:
>  }
>
>  /**
> + * security_ib_end_port_sid - Obtain the SID for a subnet management interface.
> + * @dev_name: device name
> + * @port: port number
> + * @out_sid: security identifier
> + */
> +int security_ib_end_port_sid(const char *dev_name, u8 port, u32 *out_sid)
> +{
> +       struct ocontext *c;
> +       int rc = 0;
> +
> +       read_lock(&policy_rwlock);
> +
> +       c = policydb.ocontexts[OCON_IB_END_PORT];
> +       while (c) {
> +               if (c->u.ib_end_port.port == port &&
> +                   !strncmp(c->u.ib_end_port.dev_name,
> +                           dev_name,
> +                           IB_DEVICE_NAME_MAX))
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
> +               *out_sid = SECINITSID_IB_END_PORT;
> +       }
> +
> +out:
> +       read_unlock(&policy_rwlock);
> +       return rc;
> +}
> +
> +/**
>   * security_netif_sid - Obtain the SID for a network interface.
>   * @name: interface name
>   * @if_sid: interface SID
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
paul moore
security @ redhat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
