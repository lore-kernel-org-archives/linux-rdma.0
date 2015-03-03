From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH libibumad] umad.h: Remove umad_reg_flags from enum declaration
Date: Tue, 03 Mar 2015 15:23:05 -0500
Message-ID: <54F61829.3070903@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This causes it to be a global variable which causes linking
issues when used by multiple files linked together. It results
in multiple definition of `umad_reg_flags'.

Found-by: Rafi Weiner <rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/infiniband/umad.h b/include/infiniband/umad.h
index 6c3e7dc..1db4505 100644
--- a/include/infiniband/umad.h
+++ b/include/infiniband/umad.h
@@ -201,7 +201,7 @@ int umad_unregister(int portid, int agentid);
 
 enum {
 	UMAD_USER_RMPP = (1 << 0)
-} umad_reg_flags;
+};
 
 struct umad_reg_attr {
 	uint8_t    mgmt_class;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
