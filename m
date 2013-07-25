From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libibumad: fix status type
Date: Thu, 25 Jul 2013 15:50:35 -0700
Message-ID: <20130725155035.64fdcaf2e3e882bce0cbd0e4@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/umad_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/umad_types.h b/include/infiniband/umad_types.h
index 44bc6b0..dab92ff 100644
--- a/include/infiniband/umad_types.h
+++ b/include/infiniband/umad_types.h
@@ -127,7 +127,7 @@ struct umad_hdr {
 	uint8_t	 mgmt_class;
 	uint8_t	 class_version;
 	uint8_t	 method;
-	uint16_t status;
+	be16_t   status;
 	be16_t   class_specific;
 	be64_t   tid;
 	be16_t   attr_id;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
