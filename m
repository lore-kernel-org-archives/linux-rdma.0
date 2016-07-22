From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v2 7/9] selinux: Implement Infiniband PKey "Access" access vector
Date: Fri, 22 Jul 2016 14:53:19 -0400
Message-ID: <CAHC9VhR4kgtpuiM9G5VDYhZPoHZNLmgTbXpTfxT+bDsCgbZqCw@mail.gmail.com>
References: <1468537011-20407-1-git-send-email-danielj@mellanox.com> <1468537011-20407-8-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468537011-20407-8-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 14, 2016 at 6:56 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add a type and access vector for PKeys. Implement the ib_pkey_access
> hook to check that the caller has permission to access the PKey on the
> given subnet prefix. Add an interface to get the PKey SID. Walk the PKey
> ocontexts to find an entry for the given subnet prefix and pkey.
>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> ---
> v2:
> - Use void* blobs for security structs. Paul Moore
> - Add pkey specific data to the audit log. Paul Moore
> - Don't introduce a new initial sid, use unlabeled. Stephen Smalley
> ---
>  include/linux/lsm_audit.h           |    7 ++++++
>  security/lsm_audit.c                |   13 +++++++++++
>  security/selinux/hooks.c            |   23 +++++++++++++++++++
>  security/selinux/include/classmap.h |    2 +
>  security/selinux/include/security.h |    2 +
>  security/selinux/ss/services.c      |   41 +++++++++++++++++++++++++++++++++++
>  6 files changed, 88 insertions(+), 0 deletions(-)

...

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index fe3d20d..d9c4bfa 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5995,6 +5995,28 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
>  #endif
>
>  #ifdef CONFIG_SECURITY_INFINIBAND
> +static int selinux_ib_pkey_access(u64 subnet_prefix, u16 pkey_val, void *ib_sec)
> +{

I'm only mentioning this because it looks like there is going to be
another spin of the patches; perhaps move the ib_sec argument before
the subnet_prefix and pkey_val arguments.  This way it matches the
subject-object ordering we have in the avc_has_perm() call.

> +       struct common_audit_data ad;
> +       int err;
> +       u32 sid = 0;
> +       struct ib_security_struct *sec = ib_sec;
> +       struct lsm_pkey_audit pkey;
> +
> +       err = security_pkey_sid(subnet_prefix, pkey_val, &sid);
> +
> +       if (err)
> +               return err;
> +
> +       ad.type = LSM_AUDIT_DATA_PKEY;
> +       pkey.subnet_prefix = subnet_prefix;
> +       pkey.pkey = pkey_val;
> +       ad.u.pkey = &pkey;
> +       return avc_has_perm(sec->sid, sid,
> +                           SECCLASS_INFINIBAND_PKEY,
> +                           INFINIBAND_PKEY__ACCESS, &ad);
> +}

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
