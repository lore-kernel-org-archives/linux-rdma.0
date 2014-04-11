From: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH] Add cleanup routines.
Date: Fri, 11 Apr 2014 18:50:02 +0200
Message-ID: <A521BD06-7228-4FA9-97DD-7DFA51BE7505@gmx.net>
Reply-To: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>,
	  linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dynamically loaded library handles are saved in a list and dlclosed() on
exit. The list of struct ibv_driver *, as well as the global
struct ibv_device ** list are free()d.

Signed-off-by: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
---
 src/device.c | 10 ++++++++++
 src/init.c   | 51 ++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/src/device.c b/src/device.c
index beb7b3c..d5b76bb 100644
--- a/src/device.c
+++ b/src/device.c
@@ -305,3 +305,13 @@ void __ibv_ack_async_event(struct ibv_async_event *event)
 	}
 }
 default_symver(__ibv_ack_async_event, ibv_ack_async_event);
+
+FINI static void ibverbs_deinit()
+{
+	size_t i;
+	for (i = 0; i < num_devices; i++) {
+		/* driver callback needed. May not be malloc'd memory */
+		free(device_list[i]);
+	}
+	free(device_list);
+}
diff --git a/src/init.c b/src/init.c
index d0e4b1c..2a8bca4 100644
--- a/src/init.c
+++ b/src/init.c
@@ -67,6 +67,11 @@ struct ibv_driver_name {
 	struct ibv_driver_name *next;
 };
 
+struct ibv_so_list {
+	void *dlhandle;
+	struct ibv_so_list *next;
+};
+
 struct ibv_driver {
 	const char	       *name;
 	ibv_driver_init_func	init_func;
@@ -77,6 +82,7 @@ struct ibv_driver {
 static struct ibv_sysfs_dev *sysfs_dev_list;
 static struct ibv_driver_name *driver_name_list;
 static struct ibv_driver *head_driver, *tail_driver;
+static struct ibv_so_list *so_list;
 
 static int find_sysfs_devs(void)
 {
@@ -193,7 +199,14 @@ void verbs_register_driver(const char *name, verbs_driver_init_func init_func)
 static void load_driver(const char *name)
 {
 	char *so_name;
-	void *dlhandle;
+	struct ibv_so_list *elem;
+	struct ibv_so_list **list;
+
+	elem = malloc(sizeof(*elem));
+	if(!elem)
+		return;
+
+	elem->next = NULL;
 
 #define __IBV_QUOTE(x)	#x
 #define IBV_QUOTE(x)	__IBV_QUOTE(x)
@@ -205,16 +218,25 @@ static void load_driver(const char *name)
 		     name) < 0) {
 		fprintf(stderr, PFX "Warning: couldn't load driver '%s'.\n",
 			name);
-		return;
+		goto err;
 	}
 
-	dlhandle = dlopen(so_name, RTLD_NOW);
-	if (!dlhandle) {
+	elem->dlhandle = dlopen(so_name, RTLD_NOW);
+	if (!elem->dlhandle) {
 		fprintf(stderr, PFX "Warning: couldn't load driver '%s': %s\n",
 			name, dlerror());
-		goto out;
+		goto err;
 	}
 
+	for (list = &so_list; *list; list = &(*list)->next)
+		;
+
+	*list = elem;
+
+	goto out;
+
+err:
+	free(elem);
 out:
 	free(so_name);
 }
@@ -573,3 +595,22 @@ out:
 
 	return num_devices;
 }
+
+FINI static void unload_drivers()
+{
+	struct ibv_driver *driver;
+	struct ibv_so_list * list;
+
+	for (driver = head_driver; driver;) {
+		struct ibv_driver *tmp = driver;
+		driver = driver->next;
+		free(tmp);
+	}
+
+	for (list = so_list; list;) {
+		struct ibv_so_list *tmp = list;
+		list = list->next;
+		dlclose(tmp->dlhandle);
+		free(tmp);
+	}
+}
-- 
1.8.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
