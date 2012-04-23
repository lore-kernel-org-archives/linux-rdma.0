From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] [TRIVIAL] ibacm: security fix: replace sprintf with snprintf
Date: Mon, 23 Apr 2012 08:41:23 +0300
Message-ID: <201204230841.23270.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Replace sprintf with snprintf to protects from buffer overflow.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 linux/acme_linux.c |    4 ++--
 src/acm.c          |    6 +++---
 src/parse.c        |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/linux/acme_linux.c b/linux/acme_linux.c
index 9477d29..1039645 100644
--- a/linux/acme_linux.c
+++ b/linux/acme_linux.c
@@ -53,7 +53,7 @@ get_pkey(struct ifreq *ifreq, uint16_t *pkey)
 	FILE *f;
 	int ret;
 
-	sprintf(buf, "//sys//class//net//%s//pkey", ifreq->ifr_name);
+	snprintf(buf, sizeof buf, "//sys//class//net//%s//pkey", ifreq->ifr_name);
 	f = fopen(buf, "r");
 	if (!f) {
 		printf("failed to open %s\n", buf);
@@ -79,7 +79,7 @@ get_sgid(struct ifreq *ifr, union ibv_gid *sgid)
 	FILE *f;
 	int i, p, ret;
 
-	sprintf(buf, "//sys//class//net//%s//address", ifr->ifr_name);
+	snprintf(buf, sizeof buf, "//sys//class//net//%s//address", ifr->ifr_name);
 	f = fopen(buf, "r");
 	if (!f) {
 		printf("failed to open %s\n", buf);
diff --git a/src/acm.c b/src/acm.c
index 099e84e..376f294 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -268,7 +268,7 @@ acm_format_name(int level, char *name, size_t name_size,
 	case ACM_EP_INFO_PATH:
 		path = (struct ibv_path_record *) addr;
 		if (path->dlid) {
-			sprintf(name, "SLID(%u) DLID(%u)",
+			snprintf(name, name_size, "SLID(%u) DLID(%u)",
 				ntohs(path->slid), ntohs(path->dlid));
 		} else {
 			acm_format_name(level, name, name_size, ACM_ADDRESS_GID,
@@ -276,7 +276,7 @@ acm_format_name(int level, char *name, size_t name_size,
 		}
 		break;
 	case ACM_ADDRESS_LID:
-		sprintf(name, "LID(%u)", ntohs(*((uint16_t *) addr)));
+		snprintf(name, name_size, "LID(%u)", ntohs(*((uint16_t *) addr)));
 		break;
 	default:
 		strcpy(name, "Unknown");
@@ -3125,7 +3125,7 @@ static int acm_open_lock_file(void)
 		return -1;
 	}
 
-	sprintf(pid, "%d\n", getpid());
+	snprintf(pid, sizeof pid, "%d\n", getpid());
 	write(lock_fd, pid, strlen(pid));
 	return 0;
 }
diff --git a/src/parse.c b/src/parse.c
index 9a01afb..83ce843 100644
--- a/src/parse.c
+++ b/src/parse.c
@@ -52,7 +52,7 @@ static char *expand(char *basename, char *args, int *str_cnt, int *str_size)
 		}
 
 		while (from <= to) {
-			sprintf(buf, "%s%0*d", basename, width, from);
+			snprintf(buf, sizeof buf, "%s%0*d", basename, width, from);
 			str_buf = realloc(str_buf, size + strlen(buf)+1);
 			strcpy(&str_buf[size], buf);
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
