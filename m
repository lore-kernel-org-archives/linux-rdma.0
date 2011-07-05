From: ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>
Subject: How to recycle recv WR
Date: Wed, 6 Jul 2011 00:54:46 +0800 (CST)
Message-ID: <1309884886.29374.YahooMailNeo@web15805.mail.cnb.yahoo.com>
Reply-To: ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tan Li <tanli-q41pLDslbA3auI2f2gSDlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Suppose a WR has been posted to the receive queue by ibv_post_recv. How could the app recycle this work request or say remove this WR from receive queue? (Except the app got cq event - IBV_WC_RECV).
My app pre-post a list of receive buffer into the receive queue, and those tasks should be removed from the rq and ibv_dereg_mr before the app exit. That would be more gentle than exit() directly.


Thanks.

Yufei


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
