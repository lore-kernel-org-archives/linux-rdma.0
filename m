From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 10/11] read_config(): reject symlinks
Date: Thu,  8 Aug 2013 21:40:53 +0200
Message-ID: <7ba47cb94f6641ec9d2c4cd2db0f252c7a31af21.1375952089.git.ydroneaud@opteya.com>
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

Use fstatat()[1][2] to get type of files in the configuration
directory. Use option AT_SYMLINK_NOFOLLOW to get information on
symlink and not the file linked.

If the file is not a plain file, read_config() will not
process it with read_config_file().

This is a behavior change from previous library version:
current library accept to open symlinks, which might link
to files outside of the configuration directory.

Weakness addressed:

- CWE-59: Improper Link Resolution Before File Access ('Link Following')
<http://cwe.mitre.org/data/definitions/59.html>

- CWE-61: UNIX Symbolic Link (Symlink) Following
<http://cwe.mitre.org/data/definitions/61.html>

Secure coding:

- POS01-C. Check for the existence of links when dealing with files
<https://www.securecoding.cert.org/confluence/display/seccode/POS01-C.+Check+for+the+existence+of+links+when+dealing+with+files>

Compatibility:

- According to Gnulib, fstatat() is not supported on some older systems.
<http://www.gnu.org/software/gnulib/manual/html_node/fstatat.html>

Links:

- [1] fstatat
<http://pubs.opengroup.org/onlinepubs/9699919799/functions/fstatat.html>

- [2] fstatat(2)
<http://man7.org/linux/man-pages/man2/fstatat.2.html>

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/init.c b/src/init.c
index 75171e3..0b46b78 100644
--- a/src/init.c
+++ b/src/init.c
@@ -394,6 +394,18 @@ static void read_config(void)
 		if (dent->d_name[0] == '\0' || dent->d_name[strlen(dent->d_name) - 1] == '~')
 			continue;
 
+		if (fstatat(conf_dirfd, dent->d_name, &buf, AT_SYMLINK_NOFOLLOW)) {
+			fprintf(stderr, PFX "Warning: couldn't stat config file '%s/%s'.\n",
+				IBV_CONFIG_DIR, dent->d_name);
+			continue;
+		}
+
+		if (!S_ISREG(buf.st_mode)) {
+			fprintf(stderr, PFX "Warning: invalid config file '%s/%s'.\n",
+				IBV_CONFIG_DIR, dent->d_name);
+			continue;
+		}
+
 		read_config_file(conf_dirfd, dent->d_name);
 	}
 
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
