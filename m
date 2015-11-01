From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH libibcm] cmpost.c: Handle ibv_get_device_list returning no IB
 devices in init()
Date: Mon, 2 Nov 2015 01:27:42 +0200
Message-ID: <56369FEE.7060100@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Also, print message when init fails

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/examples/cmpost.c b/examples/cmpost.c
index 1b0edf8..f7833f5 100644
--- a/examples/cmpost.c
+++ b/examples/cmpost.c
@@ -447,6 +447,8 @@ static int init(void)
 	test.disconnects_left = connections;
 
 	dev_list = ibv_get_device_list(NULL);
+	if (!dev_list)
+		return -1;
 	test.device = dev_list[0];
 	if (!test.device)
 		return -1;
@@ -756,8 +758,10 @@ int main(int argc, char **argv)
 	}
 
 	is_server = (argc == 1);
-	if (init())
+	if (init()) {
+		printf("init failed\n");
 		exit(1);
+	}
 
 	if (is_server)
 		run_server();
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
