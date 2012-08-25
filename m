From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] librdmacm: Report error messages on stderr
Date: Sat, 25 Aug 2012 15:03:28 +0200
Message-ID: <1345899810-1615-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 5280620..ddd81d1 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -226,13 +226,13 @@ int ucma_init(void)
 
 	dev_list = ibv_get_device_list(&dev_cnt);
 	if (!dev_list) {
-		printf("CMA: unable to get RDMA device list\n");
+		fprintf(stderr, "CMA: unable to get RDMA device list\n");
 		ret = ERR(ENODEV);
 		goto err1;
 	}
 
 	if (!dev_cnt) {
-		printf("CMA: no RDMA devices found\n");
+		fprintf(stderr, "CMA: no RDMA devices found\n");
 		ret = ERR(ENODEV);
 		goto err2;
 	}
@@ -249,7 +249,7 @@ int ucma_init(void)
 		cma_dev->guid = ibv_get_device_guid(dev_list[i]);
 		cma_dev->verbs = ibv_open_device(dev_list[i]);
 		if (!cma_dev->verbs) {
-			printf("CMA: unable to open RDMA device\n");
+			fprintf(stderr, "CMA: unable to open RDMA device\n");
 			ret = ERR(ENODEV);
 			goto err3;
 		}
@@ -257,7 +257,7 @@ int ucma_init(void)
 		i++;
 		ret = ibv_query_device(cma_dev->verbs, &attr);
 		if (ret) {
-			printf("CMA: unable to query RDMA device\n");
+			fprintf(stderr, "CMA: unable to query RDMA device\n");
 			ret = ERR(ret);
 			goto err3;
 		}
@@ -329,7 +329,7 @@ struct rdma_event_channel *rdma_create_event_channel(void)
 
 	channel->fd = open("/dev/infiniband/rdma_cm", O_RDWR);
 	if (channel->fd < 0) {
-		printf("CMA: unable to open /dev/infiniband/rdma_cm\n");
+		fprintf(stderr, "CMA: unable to open /dev/infiniband/rdma_cm\n");
 		goto err;
 	}
 	return channel;
-- 
1.7.11.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
