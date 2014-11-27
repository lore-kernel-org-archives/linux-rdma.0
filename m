From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 0/2] Adding support for RoCE V2 specification
Date: Thu, 27 Nov 2014 15:52:25 +0000
Message-ID: <583cdb13b37145de92f9321e325f89b6@AM3PR05MB0935.eurprd05.prod.outlook.com>
References: <51dd1341-8216-494f-9574-120634cad8e7@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51dd1341-8216-494f-9574-120634cad8e7-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Somnath Kotur
> Sent: Thursday, November 27, 2014 2:56 AM
> To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Somnath Kotur
> Subject: [PATCH 0/2] Adding support for RoCE V2 specification
> 
> Please apply.
> 

This cover letter is rather short. Can you please elaborate?

Specifically, I will be happy to hear what is the expected usage model with RoCE v2.

What are the goals of the changes you are asking to push?

What assumptions do you have on the network topology? How do you decide when to use RoCE v1 and RoCE v2?

What is the integration of RoCE v2 with the CMA?

What changes in the user space libraries and applications are needed to support RoCE v2 on base of this kernel patch?


> Somnath Kotur (2):
>   IB/Core: Changes to the IB Core infrastructure for RoCE V2.
>   IB/ocrdma: Changes to comply with RoCEv2 Specification changes
> 
>  drivers/infiniband/core/addr.c              |   13 +++++-
>  drivers/infiniband/core/cm.c                |   15 ++++---
>  drivers/infiniband/core/cma.c               |    4 +-
>  drivers/infiniband/core/sa_query.c          |    1 +
>  drivers/infiniband/core/verbs.c             |   47 +++++++++++++++++---
>  drivers/infiniband/hw/ocrdma/ocrdma.h       |    2 +
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   64
> +++++++++++++++++++++-----
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   26 +++++++++++
>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   16 ++++++-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   11 ++++-
>  include/rdma/ib_addr.h                      |    3 +-
>  include/rdma/ib_sa.h                        |    1 +
>  include/rdma/ib_verbs.h                     |   15 ++++++
>  13 files changed, 187 insertions(+), 31 deletions(-)
> 

Thanks,
--Shachar
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
