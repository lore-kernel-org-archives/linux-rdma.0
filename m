From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma_cm.h: Fix SCTP protocol ID
Date: Wed, 13 Jan 2010 11:51:48 -0800
Message-ID: <E6D1B9AD0E184C3AAFE8F6AA741C6C62@amr.corp.intel.com>
References: <20100113192454.GA17655@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100113192454.GA17655-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Hal Rosenstock' <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Should be 132 rather than 131 according to IANA IP protocol IDs
>
>Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

>---

Thanks.  I just noticed this this morning after reviewing the luster patches.
You beat me to the patch.

>diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
>index c6b2962..1c5e589 100644
>--- a/include/rdma/rdma_cm.h
>+++ b/include/rdma/rdma_cm.h
>@@ -67,7 +67,7 @@ enum rdma_port_space {
> 	RDMA_PS_IPOIB = 0x0002,
> 	RDMA_PS_TCP   = 0x0106,
> 	RDMA_PS_UDP   = 0x0111,
>-	RDMA_PS_SCTP  = 0x0183
>+	RDMA_PS_SCTP  = 0x0184
> };
>
> struct rdma_addr {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
