From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] librdmacm: Report error level in error messages
Date: Sat, 25 Aug 2012 15:03:30 +0200
Message-ID: <1345899810-1615-3-git-send-email-ydroneaud@opteya.com>
References: <1345899810-1615-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345899810-1615-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

libibverbs report error messages with either "Warning" or "Fatal" level,
librdmacm should do the same.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cma.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 7002513..4f6a5ab 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -158,15 +158,15 @@ static int check_abi_version(void)
 		 * backports, assume the most recent version of the ABI.  If
 		 * we're wrong, we'll simply fail later when calling the ABI.
 		 */
-		fprintf(stderr, PFX "couldn't read ABI version.\n");
-		fprintf(stderr, PFX "assuming: %d\n", abi_ver);
+		fprintf(stderr, PFX "Warning: couldn't read ABI version.\n");
+		fprintf(stderr, PFX "Warning: assuming: %d\n", abi_ver);
 		return 0;
 	}
 
 	abi_ver = strtol(value, NULL, 10);
 	if (abi_ver < RDMA_USER_CM_MIN_ABI_VERSION ||
 	    abi_ver > RDMA_USER_CM_MAX_ABI_VERSION) {
-		fprintf(stderr, PFX "kernel ABI version %d "
+		fprintf(stderr, PFX "Fatal: kernel ABI version %d "
 				"doesn't match library version %d.\n",
 				abi_ver, RDMA_USER_CM_MAX_ABI_VERSION);
 		return -1;
@@ -226,13 +226,13 @@ int ucma_init(void)
 
 	dev_list = ibv_get_device_list(&dev_cnt);
 	if (!dev_list) {
-		fprintf(stderr, PFX "unable to get RDMA device list\n");
+		fprintf(stderr, PFX "Fatal: unable to get RDMA device list\n");
 		ret = ERR(ENODEV);
 		goto err1;
 	}
 
 	if (!dev_cnt) {
-		fprintf(stderr, PFX "no RDMA devices found\n");
+		fprintf(stderr, PFX "Fatal: no RDMA devices found\n");
 		ret = ERR(ENODEV);
 		goto err2;
 	}
@@ -249,7 +249,7 @@ int ucma_init(void)
 		cma_dev->guid = ibv_get_device_guid(dev_list[i]);
 		cma_dev->verbs = ibv_open_device(dev_list[i]);
 		if (!cma_dev->verbs) {
-			fprintf(stderr, PFX "unable to open RDMA device\n");
+			fprintf(stderr, PFX "Fatal: unable to open RDMA device\n");
 			ret = ERR(ENODEV);
 			goto err3;
 		}
@@ -257,7 +257,7 @@ int ucma_init(void)
 		i++;
 		ret = ibv_query_device(cma_dev->verbs, &attr);
 		if (ret) {
-			fprintf(stderr, PFX "unable to query RDMA device\n");
+			fprintf(stderr, PFX "Fatal: unable to query RDMA device\n");
 			ret = ERR(ret);
 			goto err3;
 		}
@@ -329,7 +329,7 @@ struct rdma_event_channel *rdma_create_event_channel(void)
 
 	channel->fd = open("/dev/infiniband/rdma_cm", O_RDWR);
 	if (channel->fd < 0) {
-		fprintf(stderr, PFX "unable to open /dev/infiniband/rdma_cm\n");
+		fprintf(stderr, PFX "Fatal: unable to open /dev/infiniband/rdma_cm\n");
 		goto err;
 	}
 	return channel;
-- 
1.7.11.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
