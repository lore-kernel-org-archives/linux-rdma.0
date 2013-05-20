From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH libibverbs v5 5/7] libibverbs: Add ibv_open_qp
Date: Mon, 20 May 2013 17:59:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD293DC@ORSMSX109.amr.corp.intel.com>
References: <1364332466-22786-1-git-send-email-sean.hefty@intel.com>
 <1364332466-22786-6-git-send-email-sean.hefty@intel.com>
 <519A59B1.9080402@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519A59B1.9080402-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> So is it intended that cooperating processes sharing an xrc domain will
> "choose" one process to create the xrc qp, and the rest will open it?

yes - The QPN of the shared QP must be known between the cooperating processes.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
