From: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/12] security: Add LSM hooks for Infiniband security
Date: Thu, 30 Jun 2016 16:27:58 -0400
Message-ID: <CAGH-KgtVpX-y+r+pA0_0Hg-Yqx6YWpuc6ud-rk_pHQCtOEFGag@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com> <1466711578-64398-2-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466711578-64398-2-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add nine new hooks
>  1. Allocate security contexts for Infiniband QPs.
>  2. Free security contexts for Infiniband QPs.
>  3. Allocate security contexts for Infiniband MAD agents.
>  4. Free security contexts for Infiniband MAD agents.
>  5. Enforce QP access to Pkeys
>  6. Enforce MAD agent access to Pkeys
>  7. Enforce MAD agent access to Infiniband End Ports for sending Subnet
>     Management Packets (SMP)
>  8. A hook to register a callback to receive notifications of
>     security policy or enforcement changes.  Restricting a QPs access to
>     a pkey will be done during setup and not on a per packet basis
>     access must be enforced again.
>  9. A hook to unregister the callback.
>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/linux/lsm_hooks.h | 71 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/security.h  | 63 +++++++++++++++++++++++++++++++++++
>  include/rdma/ib_verbs.h   |  4 +++
>  security/Kconfig          |  9 +++++
>  security/security.c       | 83 +++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 230 insertions(+)

I'd recommend putting the IB hook calls into this patch as well, it
helps make the hooks a bit more concrete as you can see where, and how
they are called.

> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 7ae3976..6b47c8d 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -8,6 +8,7 @@
>   * Copyright (C) 2001 Silicon Graphics, Inc. (Trust Technology Group)
>   * Copyright (C) 2015 Intel Corporation.
>   * Copyright (C) 2015 Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
> + * Copyright (C) 2016 Mellanox Techonologies
>   *
>   *     This program is free software; you can redistribute it and/or modify
>   *     it under the terms of the GNU General Public License as published by
> @@ -876,6 +877,50 @@
>   *     associated with the TUN device's security structure.
>   *     @security pointer to the TUN devices's security structure.
>   *
> + * Security hooks for Infiniband
> + *
> + * @ib_qp_pkey_access:
> + *     Check permission to access a pkey when modifing a QP.
> + *     @subnet_prefix the subnet prefix of the port being used.
> + *     @pkey the pkey to be accessed.
> + *     @qp_sec pointer to the ib_qp_security structure.
> + * @ib_mad_agent_pkey_access:
> + *     Check permission to access a pkey when transmiting and receiving MADS.
> + *     @subnet_prefix the subnet prefix of the port being used.
> + *     @pkey the pkey to be accessed.
> + *     @mad_agent pointer to the ib_mad_agent structure.
> + * @ib_end_port_smp:
> + *     Check permissions to send and receive SMPs on a end port.
> + *     @dev_name the IB device name (i.e. mlx4_0).
> + *     @port_num the port number.
> + *     @mad_agent pointer to the ib_mad_agent structure.
> + * @ib_qp_alloc_security:
> + *     Allocate and attach a security structure to the qp_sec->q_security
> + *     field. The q_security field is initialized to NULL when the structure
> + *     is allocated.  A separate QP security structure is used instead of the
> + *     QP structure because when a QP is destroyed the memory is freed by the
> + *     hardware driver.  That operation can fail so the security info must be
> + *     maintained until the destroy completes successfully.
> + *     @qp_sec contains the ib_qp_security structure to be modified.
> + *     Return 0 if operation was successful.
> + * @ib_mad_agent_alloc_security:
> + *     Allocate and attach a security structure to the mad_agent->m_security
> + *     field. The m_security field is initialized to NULL when the structure
> + *     is allocated.
> + *     @mad_agent contains the ib_mad_agent structure to be modified.
> + *     Return 0 if operation was successful.
> + * @ib_qp_free_security:
> + *     Deallocate and clear the qp_sec->q_security field.
> + *     @qp_sec contains the ib_qp_security structure to be modified.
> + * @ib_mad_agent_free_security:
> + *     Deallocate and clear the mad_agent->m_security field.
> + *     @mad_agent contains the ib_mad_agent structure to be modified.
> + * @register_ib_flush_callback:
> + *     Provide a way for security modules to notify ib_core of policy changes.
> + *     @callback function pointer to call when policy changes.
> + * @unregister_ib_flush_callback:
> + *     Unregister the callback function.
> + *
>   * Security hooks for XFRM operations.
>   *
>   * @xfrm_policy_alloc_security:

-- 
paul moore
security @ redhat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
