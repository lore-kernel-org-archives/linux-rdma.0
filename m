From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: IB/rdmavt: Add create queue pair functionality
Date: Wed, 23 Mar 2016 15:33:15 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25A8A48A@fmsmsx120.amr.corp.intel.com>
References: <20160322200132.GA27901@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160322200132.GA27901@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The patch 515667f8f8b4: "IB/rdmavt: Add create queue pair functionality"
> from Jan 22, 2016, leads to the following static checker warning:
> 
> 	drivers/infiniband/sw/rdmavt/qp.c:835 rvt_create_qp()
> 	warn: odd binop '0x4 & 0xe0'
> 
> drivers/infiniband/sw/rdmavt/qp.c
>    834          case IB_QPT_RC:
>    835                  qp->allowed_ops = IB_OPCODE_RC_SEND_ONLY &
> RVT_OPCODE_QP_MASK;
> 
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                                           0x4                    & 0xE0
> is zero.  I couldn't figure out where IB_OPCODE_RC_SEND_ONLY is defined
> but presumably Smatch is correct that it's 4.
> 

IB_OPCODE_RC_SEND_ONLY is prepared by:

#define IB_OPCODE(transport, op) \
        IB_OPCODE_ ## transport ## _ ## op = \
                IB_OPCODE_ ## transport + IB_OPCODE_ ## op

in include/rdma/ib_pack.h.

The intent of allowed_ops is to allow for quick validation of an opcode for a QP by a masked compare.

Perhaps a better coding would use these defines from the same file?:
        IB_OPCODE_RC                                = 0x00,
        IB_OPCODE_UC                                = 0x20,
        IB_OPCODE_UD                                = 0x60,

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
