From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/5] IB/user_mad: Fix bug in ib_umad_remove_one when rdma_cap_ib_mad implementation changed
Date: Wed, 13 May 2015 20:02:57 -0400
Message-ID: <1431561779-13714-4-git-send-email-ira.weiny@intel.com>
References: <1431561779-13714-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431561779-13714-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The addition of the rdma_cap_ib_mad is technically broken in ib_umad_remove_one
because the loop "i" value is not a port value.

This bug resulted in the ib_umad failing to properly remove its resources when
the core capability functions were converted to bit fields.

NOTE: e17371d73908 did not result in broken behavior on its own.  It was only
an issue when the implementation of rdma_cap_ib_mad was changed.

Pass the port value to rdma_cap_ib_mad.

Fixes: e17371d73908 ("IB/Verbs: Use management helper rdma_cap_ib_mad()")

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1:
	Add brackets around if statement
	use new rdma_start_port to properly index the port.

 drivers/infiniband/core/user_mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 08f264711136..e58d701b7791 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1325,7 +1325,7 @@ static void ib_umad_remove_one(struct ib_device *device)
 		return;
 
 	for (i = 0; i <= rdma_end_port(device) - rdma_start_port(device); ++i) {
-		if (rdma_cap_ib_mad(device, i))
+		if (rdma_cap_ib_mad(device, i + rdma_start_port(device)))
 			ib_umad_kill_port(&umad_dev->port[i]);
 	}
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
