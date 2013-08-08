From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 05/11] read_config_file(): use the directory
 file descriptor to open configuration file
Date: Thu,  8 Aug 2013 21:40:48 +0200
Message-ID: <f77504a30d3185c152650cd6866def4c52fc7f8b.1375952089.git.ydroneaud@opteya.com>
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

Change read_config_file() to use the directory file descriptor
when
- checking the configuration file with fstatat()[1][2],
- opening the configuration file with openat()[3][4].

The full path string is no more needed so it's removed.

Additionally, using the directory fd and openat() ensure
the file opened is in the expected directory.

Weakness addressed:

- CWE-363: Race Condition Enabling Link Following
<http://cwe.mitre.org/data/definitions/363.html>

Compatibility note:

- According to Gnulib[5], fstatat() is not available on older systems.
<http://www.gnu.org/software/gnulib/manual/html_node/fstatat.html>

- According to Gnulib[6], openat() is not available on older systems.
<http://www.gnu.org/software/gnulib/manual/html_node/openat.html>

Links:

- [1] fstatat
<http://pubs.opengroup.org/onlinepubs/9699919799/functions/fstatat.html>

- [2] fstatat(2)
<http://man7.org/linux/man-pages/man2/fstatat.2.html>

- [3] openat
<http://pubs.opengroup.org/onlinepubs/9699919799/functions/openat.html>

- [4] openat(2)
<http://man7.org/linux/man-pages/man2/openat.2.html>

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/src/init.c b/src/init.c
index 953ed9f..c260628 100644
--- a/src/init.c
+++ b/src/init.c
@@ -235,8 +235,9 @@ static void load_drivers(void)
 	}
 }
 
-static void read_config_file(const char *path)
+static void read_config_file(int conf_dirfd, const char *name)
 {
+	int fd;
 	FILE *conf;
 	char *line = NULL;
 	char *config;
@@ -245,25 +246,32 @@ static void read_config_file(const char *path)
 	ssize_t len;
 	struct stat buf;
 
-	if (stat(path, &buf)) {
-		fprintf(stderr, PFX "Warning: couldn't stat config file '%s'.\n",
-			path);
+	if (fstatat(conf_dirfd, name, &buf, 0)) {
+		fprintf(stderr, PFX "Warning: couldn't stat config file '%s/%s'.\n",
+			IBV_CONFIG_DIR, name);
 		return;
 	}
 
 	if (!S_ISREG(buf.st_mode)) {
-		fprintf(stderr, PFX "Warning: invalid config file '%s'.\n",
-			path);
+		fprintf(stderr, PFX "Warning: invalid config file '%s/%s'.\n",
+			IBV_CONFIG_DIR, name);
 		return;
 	}
 
-	conf = fopen(path, "r" STREAM_CLOEXEC);
-	if (!conf) {
-		fprintf(stderr, PFX "Warning: couldn't read config file %s.\n",
-			path);
+	fd = openat(conf_dirfd, name, O_RDONLY | O_CLOEXEC);
+	if (fd == -1) {
+		fprintf(stderr, PFX "Warning: couldn't read config file '%s/%s'.\n",
+			IBV_CONFIG_DIR, name);
 		return;
 	}
 
+	conf = fdopen(fd, "r" STREAM_CLOEXEC);
+	if (!conf) {
+		fprintf(stderr, PFX "Warning: couldn't read config file '%s/%s'.\n",
+			IBV_CONFIG_DIR, name);
+		goto out;
+	}
+
 	while ((len = getline(&line, &buflen, conf)) != -1) {
 		config = line + strspn(line, "\t ");
 		if (config[0] == '\n' || config[0] == '#')
@@ -296,12 +304,18 @@ static void read_config_file(const char *path)
 			driver_name_list  = driver_name;
 		} else
 			fprintf(stderr, PFX "Warning: ignoring bad config directive "
-				"'%s' in file '%s'.\n", field, path);
+				"'%s' in file '%s/%s'.\n", field, IBV_CONFIG_DIR, name);
 	}
 
 	if (line)
 		free(line);
+
 	fclose(conf);
+
+	return;
+
+out:
+	close(fd);
 }
 
 static void read_config(void)
@@ -309,7 +323,6 @@ static void read_config(void)
 	int conf_dirfd;
 	DIR *conf_dir;
 	struct dirent *dent;
-	char *path;
 
 	conf_dirfd = open(IBV_CONFIG_DIR, O_RDONLY | O_CLOEXEC);
 	if (conf_dirfd == -1) {
@@ -334,18 +347,9 @@ static void read_config(void)
 		if (dent->d_name[0] == '\0' || dent->d_name[strlen(dent->d_name) - 1] == '~')
 			continue;
 
-		if (asprintf(&path, "%s/%s", IBV_CONFIG_DIR, dent->d_name) < 0) {
-			fprintf(stderr, PFX "Warning: couldn't read config file %s/%s.\n",
-				IBV_CONFIG_DIR, dent->d_name);
-			goto out;
-		}
-
-		read_config_file(path);
-
-		free(path);
+		read_config_file(conf_dirfd, dent->d_name);
 	}
 
-out:
 	closedir(conf_dir);
 }
 
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
