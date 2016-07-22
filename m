From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v2 8/9] selinux: Add IB Port SMP access vector
Date: Fri, 22 Jul 2016 15:26:52 -0400
Message-ID: <CAHC9VhTG9jcfdQdK5nFyf43fLrR8c9qOwmkkwTc7kE32UB3E1Q@mail.gmail.com>
References: <1468537011-20407-1-git-send-email-danielj@mellanox.com> <1468537011-20407-9-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468537011-20407-9-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 14, 2016 at 6:56 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add a type for Infiniband ports and an access vector for subnet
> management packets. Implement the ib_port_smp hook to check that the
> caller has permission to send and receive SMPs on the end port specified
> by the device name and port. Add interface to query the SID for a IB
> port, which walks the IB_PORT ocontexts to find an entry for the
> given name and port.
>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

...

> diff --git a/security/lsm_audit.c b/security/lsm_audit.c
> index 2546d82..95632a9 100644
> --- a/security/lsm_audit.c
> +++ b/security/lsm_audit.c
> @@ -410,6 +410,11 @@ static void dump_common_audit_data(struct audit_buffer *ab,
>                                  a->u.pkey->pkey, &sbn_pfx);
>                 break;
>         }
> +       case LSM_AUDIT_DATA_IB_PORT:
> +               audit_log_format(ab, " device=");
> +               audit_log_untrustedstring(ab, a->u.ib_port->dev_name);

The device name comes from the driver, right?  We only need to use the
"untrustedstring" logging variant when we are dealing with strings
from userspace that have no guarantees on what they might contain.
Check the audit_string_contains_control() function to see what we
consider "bad" characters.

> +               audit_log_format(ab, " port=%u", a->u.ib_port->port);

Based on our other conversations, I'm guessing that should be " endport=%u"?

> +               break;
>         } /* switch (a->type) */
>  }
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index d9c4bfa..40ad0e8 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6017,6 +6017,28 @@ static int selinux_ib_pkey_access(u64 subnet_prefix, u16 pkey_val, void *ib_sec)
>                             INFINIBAND_PKEY__ACCESS, &ad);
>  }
>
> +static int selinux_ib_port_manage_subnet(const char *dev_name, u8 port, void *ib_sec)
> +{

See my previous comments about argument ordering, in other words, put
ib_sec first to help preserve my sanity in the future.

> +       struct common_audit_data ad;
> +       int err;
> +       u32 sid = 0;
> +       struct ib_security_struct *sec = ib_sec;
> +       struct lsm_ib_port_audit ib_port;
> +
> +       err = security_ib_port_sid(dev_name, port, &sid);
> +
> +       if (err)
> +               return err;
> +
> +       ad.type = LSM_AUDIT_DATA_IB_PORT;
> +       strncpy(ib_port.dev_name, dev_name, sizeof(ib_port.dev_name));
> +       ib_port.port = port;
> +       ad.u.ib_port = &ib_port;
> +       return avc_has_perm(sec->sid, sid,
> +                           SECCLASS_INFINIBAND_PORT,
> +                           INFINIBAND_PORT__MANAGE_SUBNET, &ad);
> +}
> +

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
