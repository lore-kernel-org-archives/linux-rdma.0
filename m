From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] IB: Fix incorrect structure packing for booleans
Date: Thu, 22 Dec 2016 18:07:52 -0700
Message-ID: <20161223010752.GA20676@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The RDMA core uses ib_pack() to convert from unpacked CPU structs
to on-the-wire bitpacked structs.

This process requires that 1 bit fields are declared as u8 in the
unpacked struct, otherwise the packing process does not read the
value properly and the packed result is wired to 0. Several
places wrongly used int.

Crucially this means the kernel has never, set reversible
correctly in the path record request. It has always asked for
irreversible paths even if the ULP requests otherwise.

When the kernel is used with a SM that supports this feature, it
completely breaks communication management if reversible paths are
not properly requested.

The only reason this ever worked is because opensm ignores the
reversible bit.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 include/rdma/ib_sa.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

For 4.10 please!

diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 5ee7aab95eb849..fd0e53219f93e5 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -153,12 +153,12 @@ struct ib_sa_path_rec {
 	union ib_gid sgid;
 	__be16       dlid;
 	__be16       slid;
-	int          raw_traffic;
+	u8           raw_traffic;
 	/* reserved */
 	__be32       flow_label;
 	u8           hop_limit;
 	u8           traffic_class;
-	int          reversible;
+	u8           reversible;
 	u8           numb_path;
 	__be16       pkey;
 	__be16       qos_class;
@@ -220,7 +220,7 @@ struct ib_sa_mcmember_rec {
 	u8           hop_limit;
 	u8           scope;
 	u8           join_state;
-	int          proxy_join;
+	u8           proxy_join;
 };
 
 /* Service Record Component Mask Sec 15.2.5.14 Ver 1.1	*/
-- 
2.7.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
