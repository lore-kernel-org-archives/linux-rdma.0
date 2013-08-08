From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 09/11] Check owner/permissions of config
 directory/files
Date: Thu,  8 Aug 2013 21:40:52 +0200
Message-ID: <dfb11798504c27c0ed173f79395906327dc9f7f0.1375952089.git.ydroneaud@opteya.com>
References: <cover.1375952089.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1375952089.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1375952089.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1375952089.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduces secure_perms() function to check owner/group
and permissions on configuration directory and files.

When running an application as root (or setuid), this function
will disallow access to configuration directory/files owned by
user different from root.

It allows current user to use its own configuration directory/files
or the ones owned by 'root'.

It rejects directory/files writable by all.

The behavior of the function 'secure_perms()' was proposed
for scrutiny on StackOverflow[1]. It was reviewed by few people,
who doesn't found any flaw in the implementation.

Note: IBV_CONFIG_DIR is allowed to be a symlink. In case of symlink,
the linked directory is opened, its file descriptor is used to
check its parameters and is used as base directory with fstatat()
and openat(). Once the parameters of the directory are known
to be safe, someone moving around the IBV_CONFIG_DIR symlink
will have no effect for the current application.

Weakness addressed:

- CWE-282: Improper Ownership Management
<http://cwe.mitre.org/data/definitions/282.html>

- CWE-283: Unverified Ownership
<http://cwe.mitre.org/data/definitions/283.html>

- CWE-426: Untrusted Search Path
<http://cwe.mitre.org/data/definitions/426.html>

- CWE-427: Uncontrolled Search Path Element
<http://cwe.mitre.org/data/definitions/427.html>

- CWE-552: Files or Directories Accessible to External Parties
<http://cwe.mitre.org/data/definitions/552.html>

Secure coding:

- FIO15-C. Ensure that file operations are performed in a secure directory
<https://www.securecoding.cert.org/confluence/display/seccode/FIO15-C.+Ensure+that+file+operations+are+performed+in+a+secure+directory>

Links:

- [1] c - How to ensure correct file permissions
<http://stackoverflow.com/questions/16719487/how-to-ensure-correct-file-permissions>

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/src/init.c b/src/init.c
index c2e7bfb..75171e3 100644
--- a/src/init.c
+++ b/src/init.c
@@ -235,6 +235,29 @@ static void load_drivers(void)
 	}
 }
 
+static int secure_perms(const struct stat *buf)
+{
+	uid_t uid;
+	gid_t gid;
+
+	uid = geteuid();
+	gid = getegid();
+
+	if ((buf->st_mode & S_IWOTH) != 0) {
+		return 0;
+	}
+
+	if ((buf->st_gid != 0) && (buf->st_gid != gid)) {
+		return 0;
+	}
+
+	if ((buf->st_uid != 0) && (buf->st_uid != uid)) {
+		return 0;
+	}
+
+	return 1;
+}
+
 static void read_config_file(int conf_dirfd, const char *name)
 {
 	int fd;
@@ -265,6 +288,12 @@ static void read_config_file(int conf_dirfd, const char *name)
 		goto out;
 	}
 
+	if (!secure_perms(&buf)) {
+		fprintf(stderr, PFX "Warning: unsecure config file '%s/%s'.\n",
+			IBV_CONFIG_DIR, name);
+		goto out;
+	}
+
 	conf = fdopen(fd, "r" STREAM_CLOEXEC);
 	if (!conf) {
 		fprintf(stderr, PFX "Warning: couldn't read config file '%s/%s'.\n",
@@ -344,6 +373,12 @@ static void read_config(void)
 		goto out;
 	}
 
+	if (!secure_perms(&buf)) {
+		fprintf(stderr, PFX "Warning: unsecure config directory '%s'.\n",
+			IBV_CONFIG_DIR);
+		goto out;
+	}
+
 	conf_dir = fdopendir(conf_dirfd);
 	if (!conf_dir) {
 		fprintf(stderr, PFX "Warning: couldn't open config directory '%s'.\n",
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
