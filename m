From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH librdmacm 0/3] no IBV_SEND_INLINE thus memory
 registration required on QLogic/Intel HCA
Date: Wed, 28 Aug 2013 14:09:40 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC21193FDB@FMSMSX107.amr.corp.intel.com>
References: <cover.1376746185.git.ydroneaud@opteya.com>
 <1828884A29C6694DAF28B7E6B8A8237388CA890E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CA890E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>    The function ibv_create_qp() will update the qp_init_attr->cap struct
>    with the actual QP values of the QP that was created; the values will
>    be greater than or equal to the values requested.
> 

You are correct.  For qib, this is controlled by the kernel driver.

The qp_create will succeed, but will update the caps.max_inline_data with the value of zero, which is its max.

Looking at the kernel's Infiniband/hw directory this is implemented inconsistently:
- ehca, nes, and ipath (not surprising) behave like qib and return their max
- max for ehca, ipath, and qib is 0
- nes inline is either 0 or 64 depending on a module parameter
- mlx5 appears (I'm not 100% sure) to behave like qib and returns its supported value
- mthca,mlx4,cxgb[34] test and fail with -EINVAL as you suggest

None of the -EINVAL failure cases write back the caps.max_inline_data.

Has librdmacm tried this across all the 'hw'?

Perhaps it would be best to have ULP's ask for 0 and have providers return their >= 0 max, which would implement this as the man page suggests?

Mike


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
