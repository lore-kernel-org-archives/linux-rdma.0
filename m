From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH libibumad] Fix export of umad_sa_mad_status_str
Date: Wed, 20 Mar 2013 22:14:45 -0700
Message-ID: <1363842885-21830-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/libibumad.map |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/libibumad.map b/src/libibumad.map
index 0b39333..eeb9d83 100644
--- a/src/libibumad.map
+++ b/src/libibumad.map
@@ -33,7 +33,7 @@ IBUMAD_1.0 {
 		umad_class_str;
 		umad_method_str;
 		umad_common_mad_status_str;
-		umad_sa_status_str;
+		umad_sa_mad_status_str;
 		umad_attribute_str;
 	local: *;
 };
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
