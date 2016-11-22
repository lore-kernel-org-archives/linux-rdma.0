From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v5 7/9] selinux: Implement Infiniband PKey "Access" access
 vector
Date: Wed, 23 Nov 2016 09:43:46 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1611230937480.3895@namei.org>
References: <1479843638-67136-1-git-send-email-danielj@mellanox.com> <1479843638-67136-8-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1479843638-67136-8-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dan Jurgens <danielj@mellanox.com>
Cc: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Tue, 22 Nov 2016, Dan Jurgens wrote:

>  		struct file *file;
> +		struct lsm_pkey_audit *pkey;
>  	} u;
>  	/* this union contains LSM specific data */
>  	union {
> diff --git a/security/lsm_audit.c b/security/lsm_audit.c
> index 37f04da..b18d277 100644
> --- a/security/lsm_audit.c
> +++ b/security/lsm_audit.c
> @@ -410,6 +410,19 @@ static void dump_common_audit_data(struct audit_buffer *ab,
>  		audit_log_format(ab, " kmod=");
>  		audit_log_untrustedstring(ab, a->u.kmod_name);
>  		break;
> +	case LSM_AUDIT_DATA_PKEY: {
> +		struct in6_addr sbn_pfx;
> +
> +		memset(&sbn_pfx.s6_addr, 0,
> +		       sizeof(sbn_pfx.s6_addr));
> +
> +		memcpy(&sbn_pfx.s6_addr, &a->u.pkey->subnet_prefix,
> +		       sizeof(a->u.pkey->subnet_prefix));
> +
> +		audit_log_format(ab, " pkey=0x%x subnet_prefix=%pI6c",
> +				 a->u.pkey->pkey, &sbn_pfx);
> +		break;

Please do not add include extraneous empty lines in the code.


> index d87e29d..e21f7690 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6086,6 +6086,28 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
>  #endif
>  
>  #ifdef CONFIG_SECURITY_INFINIBAND
> +static int selinux_ib_pkey_access(void *ib_sec, u64 subnet_prefix, u16 pkey_val)
> +{
> +	struct common_audit_data ad;
> +	int err;
> +	u32 sid = 0;
> +	struct ib_security_struct *sec = ib_sec;
> +	struct lsm_pkey_audit pkey;
> +
> +	err = security_pkey_sid(subnet_prefix, pkey_val, &sid);
> +
> +	if (err)
> +		return err;

Ditto.

> +		}
> +		*out_sid = c->sid[0];
> +	} else {
> +		*out_sid = SECINITSID_UNLABELED;
> +	}

Also don't add extraneous braces.  It makes the code more difficult to 
review ("is something missing or malformatted here?").


-- 
James Morris
<jmorris@namei.org>

