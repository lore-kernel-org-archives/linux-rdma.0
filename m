From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [patch] infiniband: nes_cm: remove unneeded variable
Date: Wed, 15 Sep 2010 11:16:55 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904A27942B6@azsmsx506.amr.corp.intel.com>
References: <20100915160726.GA5854@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100915160726.GA5854@bicker>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



>-----Original Message-----
>From: Dan Carpenter [mailto:error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>Sent: Wednesday, September 15, 2010 11:33 AM
>To: Latif, Faisal
>Cc: Tung, Chien Tin; Roland Dreier; Or Gerlitz; linux-
>rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: [patch] infiniband: nes_cm: remove unneeded variable
>
>Just a small cleanup.  The "passive_state" variable isn't used any more
>after: dae58728dc "RDMA/nes: Fix double CLOSE event indication crash"
>
>Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>diff --git a/drivers/infiniband/hw/nes/nes_cm.c
>b/drivers/infiniband/hw/nes/nes_cm.c
>index 61e0efd..5c8d34c 100644
>--- a/drivers/infiniband/hw/nes/nes_cm.c
>+++ b/drivers/infiniband/hw/nes/nes_cm.c
>@@ -1424,7 +1424,6 @@ static void handle_rst_pkt(struct nes_cm_node
>*cm_node, struct sk_buff *skb,

This is fine.

Thanks
Faisal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
