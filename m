From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] IB/core: Add might_sleep() annotation to ib_init_ah_from_wc()
Date: Tue, 29 Aug 2017 10:34:44 -0700
Message-ID: <20170829173444.4289-2-roland@kernel.org>
References: <20170829173444.4289-1-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829173444.4289-1-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

For RoCE, ib_init_ah_from_wc() can follow the path

    ib_init_ah_from_wc() ->
      rdma_addr_find_l2_eth_by_grh() ->
        rdma_resolve_ip()

and rdma_resolve_ip() will sleep in kzalloc() and wait_for_completion().

However, developers will not see any warnings if they use ib_init_ah_from_wc()
in an atomic context and test only on IB, because the function doesn't
sleep in that case.

Add a might_sleep() so that lockdep will catch bugs no matter what hardware is
used to test.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b456e3ca1876..84868f76f8b9 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -478,6 +478,8 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 	union ib_gid dgid;
 	union ib_gid sgid;
 
+	might_sleep();
+
 	memset(ah_attr, 0, sizeof *ah_attr);
 	ah_attr->type = rdma_ah_find_type(device, port_num);
 	if (rdma_cap_eth_ah(device, port_num)) {
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
