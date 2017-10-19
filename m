From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v2 01/13] iWARP wire packet format definition
Date: Thu, 19 Oct 2017 11:34:41 -0500
Message-ID: <025401d348f8$29e26af0$7da740d0$@opengridcomputing.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com> <20171006122853.16310-2-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006122853.16310-2-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/iwarp.h | 381
> ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 381 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/iwarp.h
> 

At some point it would be nice to put common iWARP protocol stuff in header
files shared by all the iwarp drivers:

[root@stevo1 linux-2.6]# grep "MPA ID Req Frame" drivers/infiniband/*/*/*.[ch]
drivers/infiniband/hw/cxgb3/iwch_cm.h:#define MPA_KEY_REQ "MPA ID Req Frame"
drivers/infiniband/hw/cxgb4/iw_cxgb4.h:#define MPA_KEY_REQ "MPA ID Req Frame"
drivers/infiniband/hw/i40iw/i40iw_cm.h:#define IEFT_MPA_KEY_REQ  "MPA ID Req
Frame"
drivers/infiniband/hw/nes/nes_cm.h:#define IEFT_MPA_KEY_REQ  "MPA ID Req Frame"
[root@stevo1 linux-2.6]#

:)

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
