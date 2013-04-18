From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH] libibumad: change sm_key to be be64_t
Date: Thu, 18 Apr 2013 10:22:29 -0700
Message-ID: <20130418102229.b912d581c7e88339b1c0c61e@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Was there a reason to define sm_key as an array of uint8_t's vs a be64_t?

Wouldn't the following be better?

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/umad_sa.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/umad_sa.h b/include/infiniband/umad_sa.h
index eb7812d..32edf33 100644
--- a/include/infiniband/umad_sa.h
+++ b/include/infiniband/umad_sa.h
@@ -108,7 +108,7 @@ enum {
 struct umad_sa_packet {
 	struct umad_hdr		mad_hdr;
 	struct umad_rmpp_hdr	rmpp_hdr;
-	uint8_t			sm_key[8]; /* network-byte order */
+	be64_t			sm_key;
 	be16_t			attr_offset;
 	be16_t			reserved;
 	be64_t			comp_mask;
-- 
1.7.0.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
