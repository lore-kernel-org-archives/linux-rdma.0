From: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v7 2/9] IB/core: Enforce PKey security on QPs
Date: Mon, 22 May 2017 10:13:16 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1705220959450.3502@namei.org>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com> <1495198139-69993-3-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495198139-69993-3-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Chris Wright <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 19 May 2017, Dan Jurgens wrote:

> security/security.c                  | 385 ++++++++++++++++++++++

This looks wrong -- merge problem?


> +	if (pps->alt.state != IB_PORT_PKEY_NOT_VALID) {
> +		get_pkey_and_subnet_prefix(&pps->alt,
> +					   &pkey,
> +					   &subnet_prefix);
> +
> +		ret = enforce_qp_pkey_security(pkey,
> +					       subnet_prefix,
> +					       sec);
> +	}
> +
> +	if (ret)
> +		goto out;

The above if/goto is unnecessary.

> +
> +out:
> +	return ret;
> +}



-- 
James Morris
<jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
