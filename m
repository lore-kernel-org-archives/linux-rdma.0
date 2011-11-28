From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: ibacm: Check dynamic memory allocation results
Date: Mon, 28 Nov 2011 14:22:10 +0200
Message-ID: <201111281422.11012.dotanb@sw.voltaire.com>
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

After allocation of dynamic memory blocks, check that the allocation succeeded,
if it failed handle it gracefully.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Erez Shitrit <erezsh-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 src/parse.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/src/parse.c b/src/parse.c
index d1c820f..6ab6041 100644
--- a/src/parse.c
+++ b/src/parse.c
@@ -71,14 +71,15 @@ static char *expand(char *basename, char *args, int *str_cnt, int *str_size)
 
 char **parse(char *args, int *count)
 {
-	char **ptrs;
+	char **ptrs = NULL;
 	char *str_buf, *cpy, *token, *next;
 	int cnt = 0, str_size = 0;
 	int i;
 
 	/* make a copy that strtok can modify */
-	cpy = malloc(strlen(args) + 1);
-	strcpy(cpy, args);
+	cpy = strdup(args);
+	if (!cpy)
+		return NULL;
 
 	if (args[0] == '[') {
 		cpy[0] = '\0';
@@ -92,6 +93,8 @@ char **parse(char *args, int *count)
 	if (!next) {
 		str_size = strlen(token) + 1;
 		str_buf = malloc(str_size);
+		if (!str_buf)
+			goto out_cpy;
 		strcpy(str_buf, token);
 		cnt = 1;
 	} else {
@@ -99,6 +102,9 @@ char **parse(char *args, int *count)
 	}
 
 	ptrs = malloc((sizeof str_buf * (cnt + 1)) + str_size);
+	if (!ptrs)
+		goto out_str_buf;
+
 	memcpy(&ptrs[cnt + 1], str_buf, str_size);
 
 	ptrs[0] = (char*) &ptrs[cnt + 1];
@@ -106,10 +112,14 @@ char **parse(char *args, int *count)
 		ptrs[i] = index(ptrs[i - 1], 0) + 1;
 	ptrs[i] = NULL;
 
-	free(cpy);
-	free(str_buf);
-
 	if (count)
 		*count = cnt;
+
+out_str_buf:
+        free(str_buf);
+
+out_cpy:
+	free(cpy);
+
 	return ptrs;
 }
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
