From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 0/2] libibverbs memory barrier fixes
Date: Tue, 7 Jun 2016 11:04:58 -0500
Message-ID: <01ac01d1c0d6$56b7b770$04272650$@opengridcomputing.com>
References: <cover.1465310573.git.root@r9.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1465310573.git.root-6HSsQxwzXLRrcEM49+0neVaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'root' <root-6HSsQxwzXLRrcEM49+0neVaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

hmm, root-6HSsQxwzXLRrcEM49+0nea2raWmgRF17@public.gmane.org oops. :)



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of root
> Sent: Tuesday, June 07, 2016 9:43 AM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH v3 0/2] libibverbs memory barrier fixes
> 
> This series implements ARM64 memory barrier support, and fails compiles
> if there is no platform implementation of the memory barriers.
> 
> Changes since V3:
> 
> white noise fix
> 
> parens around asm macros (checkpatch recommendation)
> 
> remove RFC tag
> 
> Changes since V2:
> 
> Implement the mb* macros from scratch
> 
> Retested changes on ARM64
> 
> Steve Wise (2):
>   libibverbs: add ARM64 memory barrier macros
>   Fail compiles if no platform specific memory barriers exist
> 
>  include/infiniband/arch.h |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
