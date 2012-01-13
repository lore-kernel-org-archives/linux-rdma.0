From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: RDMA/nes: Add support for MPAv2 Enhanced RDMA Negotiation
Date: Fri, 13 Jan 2012 13:05:24 +0300
Message-ID: <20120113100524.GA26353@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Tatyana Nikolova,

The patch 615eb715ae10: "RDMA/nes: Add support for MPAv2 Enhanced 
RDMA Negotiation" from Sep 25, 2011, leads to a number of endian
warnings.

For example, struct ietf_rtr_msg is declared as holding big endian
values, but it's used to hold cpu endian values.

+struct ietf_rtr_msg {
+       __be16 ctrl_ird;
+       __be16 ctrl_ord;
+};

Sparse can find many of these problems automatically.  Lwn had an
article on how that works.  http://lwn.net/Articles/205624/

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
