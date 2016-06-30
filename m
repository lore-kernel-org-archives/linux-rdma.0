From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/12] selinux: Allocate and free infiniband security
 hooks
Date: Thu, 30 Jun 2016 18:15:54 +0300
Message-ID: <20160630151553.GD22107@yuval-lap.uk.oracle.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-5-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466711578-64398-5-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2016 at 10:52:50PM +0300, Dan Jurgens wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Implement and attach hooks to allocate and free Infiniband QP and MAD
> agent security structures.
> 
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/rdma/ib_mad.h             |  1 +
>  include/rdma/ib_verbs.h           |  1 +
>  security/selinux/hooks.c          | 53 +++++++++++++++++++++++++++++++++++++++
>  security/selinux/include/objsec.h |  5 ++++
>  4 files changed, 60 insertions(+)
> 
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index c8a773f..a1ed025 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -537,6 +537,7 @@ struct ib_mad_agent {
>  	u32			flags;
>  	u8			port_num;
>  	u8			rmpp_version;
> +	void			*m_security;
>  };
>  
>  /**
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 3f6780b..e522acb 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1454,6 +1454,7 @@ struct ib_qp {
>  	void		       *qp_context;
>  	u32			qp_num;
>  	enum ib_qp_type		qp_type;
> +	struct ib_qp_security  *qp_sec;
>  };
>  
>  struct ib_mr {
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6a8841d..4f13ea4 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -17,6 +17,7 @@
>   *	Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
>   *  Copyright (C) 2007 Hitachi Software Engineering Co., Ltd.
>   *		       Yuichi Nakamura <ynakam-FkO1umbPgv4fag7Bw7Dlfw@public.gmane.org>
> + *  Copyright (C) 2016 Mellanox Technologies
>   *
>   *	This program is free software; you can redistribute it and/or modify
>   *	it under the terms of the GNU General Public License version 2,
> @@ -83,6 +84,8 @@
>  #include <linux/export.h>
>  #include <linux/msg.h>
>  #include <linux/shm.h>
> +#include <rdma/ib_verbs.h>
> +#include <rdma/ib_mad.h>
>  
>  #include "avc.h"
>  #include "objsec.h"
> @@ -6015,6 +6018,47 @@ static void selinux_unregister_ib_flush_callback(void)
>  	mutex_unlock(&ib_flush_mutex);
>  }
>  
> +static int selinux_ib_qp_alloc_security(struct ib_qp_security *qp_sec)
> +{
> +	struct ib_security_struct *sec;
> +
> +	sec = kzalloc(sizeof(*sec), GFP_ATOMIC);

Kindly reminder to make sure GFP_ATOMIC is needed.

> +	if (!sec)
> +		return -ENOMEM;
> +	sec->sid = current_sid();
> +
> +	qp_sec->q_security = sec;
> +	return 0;
> +}
> +
> +static void selinux_ib_qp_free_security(struct ib_qp_security *qp_sec)
> +{
> +	struct ib_security_struct *sec = qp_sec->q_security;
> +
> +	qp_sec->q_security = NULL;
> +	kfree(sec);
> +}
> +
> +static int selinux_ib_mad_agent_alloc_security(struct ib_mad_agent *mad_agent)
> +{
> +	struct ib_security_struct *sec;
> +
> +	sec = kzalloc(sizeof(*sec), GFP_ATOMIC);
> +	if (!sec)
> +		return -ENOMEM;
> +	sec->sid = current_sid();
> +
> +	mad_agent->m_security = sec;
> +	return 0;
> +}
> +
> +static void selinux_ib_mad_agent_free_security(struct ib_mad_agent *mad_agent)
> +{
> +	struct ib_security_struct *sec = mad_agent->m_security;
> +
> +	mad_agent->m_security = NULL;
> +	kfree(sec);
> +}
>  #endif
>  
>  static struct security_hook_list selinux_hooks[] = {
> @@ -6198,11 +6242,20 @@ static struct security_hook_list selinux_hooks[] = {
>  	LSM_HOOK_INIT(tun_dev_attach_queue, selinux_tun_dev_attach_queue),
>  	LSM_HOOK_INIT(tun_dev_attach, selinux_tun_dev_attach),
>  	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
> +
>  #ifdef CONFIG_SECURITY_INFINIBAND
>  	LSM_HOOK_INIT(register_ib_flush_callback,
>  		      selinux_register_ib_flush_callback),
>  	LSM_HOOK_INIT(unregister_ib_flush_callback,
>  		      selinux_unregister_ib_flush_callback),
> +	LSM_HOOK_INIT(ib_qp_alloc_security,
> +		      selinux_ib_qp_alloc_security),
> +	LSM_HOOK_INIT(ib_qp_free_security,
> +		      selinux_ib_qp_free_security),
> +	LSM_HOOK_INIT(ib_mad_agent_alloc_security,
> +		      selinux_ib_mad_agent_alloc_security),
> +	LSM_HOOK_INIT(ib_mad_agent_free_security,
> +		      selinux_ib_mad_agent_free_security),
>  #endif
>  
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
> diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
> index c21e135..8e7db43 100644
> --- a/security/selinux/include/objsec.h
> +++ b/security/selinux/include/objsec.h
> @@ -10,6 +10,7 @@
>   *
>   *  Copyright (C) 2001,2002 Networks Associates Technology, Inc.
>   *  Copyright (C) 2003 Red Hat, Inc., James Morris <jmorris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> + *  Copyright (C) 2016 Mellanox Technologies
>   *
>   *	This program is free software; you can redistribute it and/or modify
>   *	it under the terms of the GNU General Public License version 2,
> @@ -128,6 +129,10 @@ struct key_security_struct {
>  	u32 sid;	/* SID of key */
>  };
>  
> +struct ib_security_struct {
> +	u32 sid;        /* SID of the queue pair or MAD agent */
> +};
> +
>  extern unsigned int selinux_checkreqprot;
>  
>  #endif /* _SELINUX_OBJSEC_H_ */
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
