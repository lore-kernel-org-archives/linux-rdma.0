From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 3/7] selinux: Call infiniband_flush LSM hook on AVC reset
Date: Tue,  5 Apr 2016 00:48:20 +0300
Message-ID: <1459806504-16135-4-git-send-email-danielj@mellanox.com>
References: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459806504-16135-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In the AVC reset callback notify the infiniband module. Also renamed the
callback function, the previous name was 'net' specific.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 security/selinux/hooks.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f1ab715..156e232 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -159,13 +159,14 @@ static int selinux_peerlbl_enabled(void)
 	return (selinux_policycap_alwaysnetwork || netlbl_enabled() || selinux_xfrm_enabled());
 }
 
-static int selinux_netcache_avc_callback(u32 event)
+static int selinux_cache_avc_callback(u32 event)
 {
 	if (event == AVC_CALLBACK_RESET) {
 		sel_netif_flush();
 		sel_netnode_flush();
 		sel_netport_flush();
 		synchronize_net();
+		security_infiniband_flush();
 	}
 	return 0;
 }
@@ -6174,7 +6175,7 @@ static __init int selinux_init(void)
 
 	security_add_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks));
 
-	if (avc_add_callback(selinux_netcache_avc_callback, AVC_CALLBACK_RESET))
+	if (avc_add_callback(selinux_cache_avc_callback, AVC_CALLBACK_RESET))
 		panic("SELinux: Unable to register AVC netcache callback\n");
 
 	if (selinux_enforcing)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
