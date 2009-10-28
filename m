From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH libibverbs] Make ibv_get_device_list return codes via errno
Date: Wed, 28 Oct 2009 17:42:21 -0600
Message-ID: <20091028234221.GP14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

- Supress fprintf stderr on sundry cases like no verbs drivers
  loaded
- Fix double free in find_sysfs_devs if ibv_read_sysfs_file fails
  (unlikely)
- Update all example programs and man page

Code expecting this behavior linking to old libibverbs will
get the old fprint and errno set to garbage (probably ESPIPE).

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 examples/asyncwatch.c     |    2 +-
 examples/device_list.c    |    2 +-
 examples/devinfo.c        |    4 ++--
 examples/rc_pingpong.c    |    2 +-
 examples/srq_pingpong.c   |    2 +-
 examples/uc_pingpong.c    |    2 +-
 examples/ud_pingpong.c    |    2 +-
 man/ibv_get_device_list.3 |   16 +++++++++++++++-
 src/device.c              |   21 +++++++++++++++------
 src/init.c                |   38 ++++++++++++++++++--------------------
 10 files changed, 56 insertions(+), 35 deletions(-)

The double free thing could be split out if you want, I just caught it
while working on this.

Works like this:
$ build/examples/ibv_devinfo   
Failed to get IB devices list: Function not implemented
$ build/examples/ibv_devinfo   
No IB devices found

diff --git a/examples/asyncwatch.c b/examples/asyncwatch.c
index 16aee2c..e56b4dc 100644
--- a/examples/asyncwatch.c
+++ b/examples/asyncwatch.c
@@ -82,7 +82,7 @@ int main(int argc, char *argv[])
 
 	dev_list = ibv_get_device_list(NULL);
 	if (!dev_list) {
-		fprintf(stderr, "No IB devices found\n");
+		perror("Failed to get IB devices list");
 		return 1;
 	}
 
diff --git a/examples/device_list.c b/examples/device_list.c
index 3ce8cbd..70c3af5 100644
--- a/examples/device_list.c
+++ b/examples/device_list.c
@@ -49,7 +49,7 @@ int main(int argc, char *argv[])
 
 	dev_list = ibv_get_device_list(&num_devices);
 	if (!dev_list) {
-		fprintf(stderr, "No IB devices found\n");
+		perror("Failed to get IB devices list");
 		return 1;
 	}
 
diff --git a/examples/devinfo.c b/examples/devinfo.c
index caa5d5f..33d1a9b 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -361,7 +361,7 @@ int main(int argc, char *argv[])
 		case 'l':
 			dev_list = orig_dev_list = ibv_get_device_list(&num_of_hcas);
 			if (!dev_list) {
-				fprintf(stderr, "Failed to get IB devices list");
+				perror("Failed to get IB devices list");
 				return -1;
 			}
 
@@ -387,7 +387,7 @@ int main(int argc, char *argv[])
 
 	dev_list = orig_dev_list = ibv_get_device_list(NULL);
 	if (!dev_list) {
-		fprintf(stderr, "Failed to get IB device list\n");
+		perror("Failed to get IB devices list");
 		return -1;
 	}
 
diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
index d4115e4..fa969e0 100644
--- a/examples/rc_pingpong.c
+++ b/examples/rc_pingpong.c
@@ -593,7 +593,7 @@ int main(int argc, char *argv[])
 
 	dev_list = ibv_get_device_list(NULL);
 	if (!dev_list) {
-		fprintf(stderr, "No IB devices found\n");
+		perror("Failed to get IB devices list");
 		return 1;
 	}
 
diff --git a/examples/srq_pingpong.c b/examples/srq_pingpong.c
index e47bae6..1e36c57 100644
--- a/examples/srq_pingpong.c
+++ b/examples/srq_pingpong.c
@@ -682,7 +682,7 @@ int main(int argc, char *argv[])
 
 	dev_list = ibv_get_device_list(NULL);
 	if (!dev_list) {
-		fprintf(stderr, "No IB devices found\n");
+		perror("Failed to get IB devices list");
 		return 1;
 	}
 
diff --git a/examples/uc_pingpong.c b/examples/uc_pingpong.c
index 404b059..6f31247 100644
--- a/examples/uc_pingpong.c
+++ b/examples/uc_pingpong.c
@@ -581,7 +581,7 @@ int main(int argc, char *argv[])
 
 	dev_list = ibv_get_device_list(NULL);
 	if (!dev_list) {
-		fprintf(stderr, "No IB devices found\n");
+		perror("Failed to get IB devices list");
 		return 1;
 	}
 
diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
index 8f3d50b..6f10212 100644
--- a/examples/ud_pingpong.c
+++ b/examples/ud_pingpong.c
@@ -580,7 +580,7 @@ int main(int argc, char *argv[])
 
 	dev_list = ibv_get_device_list(NULL);
 	if (!dev_list) {
-		fprintf(stderr, "No IB devices found\n");
+		perror("Failed to get IB devices list");
 		return 1;
 	}
 
diff --git a/man/ibv_get_device_list.3 b/man/ibv_get_device_list.3
index 003fffb..16cc1a0 100644
--- a/man/ibv_get_device_list.3
+++ b/man/ibv_get_device_list.3
@@ -25,10 +25,24 @@ returned by
 .B ibv_get_device_list()\fR.
 .SH "RETURN VALUE"
 .B ibv_get_device_list()
-returns the array of available RDMA devices, or NULL if the request fails.
+returns the array of available RDMA devices, or sets
+.I errno
+and returns NULL if the request fails. If no devices are found then
+.I num_devices
+is set to 0, and non-NULL is returned.
 .PP
 .B ibv_free_device_list()
 returns no value.
+.SH "ERRORS"
+.TP
+.B EPERM
+Permission denied.
+.TP
+.B ENOSYS
+No kernel support for RDMA.
+.TP
+.B ENOMEM
+Insufficient memory to complete the operation.
 .SH "NOTES"
 Client code should open all the devices it intends to use with
 .B ibv_open_device()\fR before calling
diff --git a/src/device.c b/src/device.c
index 3abc1eb..6759c26 100644
--- a/src/device.c
+++ b/src/device.c
@@ -43,6 +43,7 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <alloca.h>
+#include <errno.h>
 
 #include <infiniband/arch.h>
 
@@ -54,27 +55,35 @@ static struct ibv_device **device_list;
 
 struct ibv_device **__ibv_get_device_list(int *num)
 {
-	struct ibv_device **l;
+	struct ibv_device **l = 0;
 	int i;
 
+	if (num)
+		*num = 0;
+
 	pthread_mutex_lock(&device_list_lock);
 
 	if (!num_devices)
 		num_devices = ibverbs_init(&device_list);
 
+	if (num_devices < 0) {
+		errno = -1*num_devices;
+		goto out;
+	}
+
 	l = calloc(num_devices + 1, sizeof (struct ibv_device *));
-	if (!l)
+	if (!l) {
+		errno = ENOMEM;
 		goto out;
+	}
 
 	for (i = 0; i < num_devices; ++i)
 		l[i] = device_list[i];
+	if (num)
+		*num = num_devices;
 
 out:
 	pthread_mutex_unlock(&device_list_lock);
-
-	if (num)
-		*num = l ? num_devices : 0;
-
 	return l;
 }
 default_symver(__ibv_get_device_list, ibv_get_device_list);
diff --git a/src/init.c b/src/init.c
index 90d4292..bd8071f 100644
--- a/src/init.c
+++ b/src/init.c
@@ -46,6 +46,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <dirent.h>
+#include <errno.h>
 
 #include "ibverbs.h"
 
@@ -76,23 +77,21 @@ static struct ibv_sysfs_dev *sysfs_dev_list;
 static struct ibv_driver_name *driver_name_list;
 static struct ibv_driver *head_driver, *tail_driver;
 
-static void find_sysfs_devs(void)
+static int find_sysfs_devs(void)
 {
 	char class_path[IBV_SYSFS_PATH_MAX];
 	DIR *class_dir;
 	struct dirent *dent;
 	struct ibv_sysfs_dev *sysfs_dev = NULL;
 	char value[8];
+	int res = 0;
 
 	snprintf(class_path, sizeof class_path, "%s/class/infiniband_verbs",
 		 ibv_get_sysfs_path());
 
 	class_dir = opendir(class_path);
-	if (!class_dir) {
-		fprintf(stderr, PFX "Fatal: couldn't open sysfs class "
-			"directory '%s'.\n", class_path);
-		return;
-	}
+	if (!class_dir)
+		return ENOSYS;
 
 	while ((dent = readdir(class_dir))) {
 		struct stat buf;
@@ -103,9 +102,8 @@ static void find_sysfs_devs(void)
 		if (!sysfs_dev)
 			sysfs_dev = malloc(sizeof *sysfs_dev);
 		if (!sysfs_dev) {
-			fprintf(stderr, PFX "Warning: couldn't allocate sysfs dev "
-				"for '%s'.\n", dent->d_name);
-			continue;
+			res = ENOMEM;
+			goto out;
 		}
 
 		snprintf(sysfs_dev->sysfs_path, sizeof sysfs_dev->sysfs_path,
@@ -128,7 +126,6 @@ static void find_sysfs_devs(void)
 					sizeof sysfs_dev->ibdev_name) < 0) {
 			fprintf(stderr, PFX "Warning: no ibdev class attr for '%s'.\n",
 				dent->d_name);
-			free(sysfs_dev);
 			continue;
 		}
 
@@ -148,10 +145,12 @@ static void find_sysfs_devs(void)
 		sysfs_dev      = NULL;
 	}
 
+ out:
 	if (sysfs_dev)
 		free(sysfs_dev);
 
 	closedir(class_dir);
+	return res;
 }
 
 void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
@@ -392,8 +391,7 @@ static int check_abi_version(const char *path)
 
 	if (ibv_read_sysfs_file(path, "class/infiniband_verbs/abi_version",
 				value, sizeof value) < 0) {
-		fprintf(stderr, PFX "Fatal: couldn't read uverbs ABI version.\n");
-		return -1;
+		return ENOSYS;
 	}
 
 	abi_ver = strtol(value, NULL, 10);
@@ -403,7 +401,7 @@ static int check_abi_version(const char *path)
 		fprintf(stderr, PFX "Fatal: kernel ABI version %d "
 			"doesn't match library version %d.\n",
 			abi_ver, IB_USER_VERBS_MAX_ABI_VERSION);
-		return -1;
+		return ENOSYS;
 	}
 
 	return 0;
@@ -454,6 +452,7 @@ HIDDEN int ibverbs_init(struct ibv_device ***list)
 	int list_size = 0;
 	int statically_linked = 0;
 	int no_driver = 0;
+	int rc;
 
 	*list = NULL;
 
@@ -463,19 +462,18 @@ HIDDEN int ibverbs_init(struct ibv_device ***list)
 				"but init failed\n");
 
 	sysfs_path = ibv_get_sysfs_path();
-	if (!sysfs_path) {
-		fprintf(stderr, PFX "Fatal: couldn't find sysfs mount.\n");
-		return 0;
-	}
+	if (!sysfs_path)
+		return -ENOSYS;
 
-	if (check_abi_version(sysfs_path))
-		return 0;
+	if ((rc = check_abi_version(sysfs_path)))
+		return -1*rc;
 
 	check_memlock_limit();
 
 	read_config();
 
-	find_sysfs_devs();
+	if ((rc = find_sysfs_devs()))
+		return -1*rc;
 
 	for (sysfs_dev = sysfs_dev_list; sysfs_dev; sysfs_dev = sysfs_dev->next) {
 		device = try_drivers(sysfs_dev);
-- 
1.5.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
