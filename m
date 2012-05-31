From: "Huang, Parry W." <huang32-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] ibsim/ibsim.c: Fixed bug regarding undefined commands
Date: Thu, 31 May 2012 15:04:11 -0700
Message-ID: <25EBDF7A-17DB-41FC-9CC8-7F960B6CA304@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In sim_cmd_file and sim_run_console, fixed bug regarding a new line being kept at the end of the input when an unknown command is processed from console or from file.

Signed-off-by: Perry Huang <huang32-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/ibsim.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/ibsim/ibsim.c b/ibsim/ibsim.c
index e720f0d..d894913 100644
--- a/ibsim/ibsim.c
+++ b/ibsim/ibsim.c
@@ -546,6 +546,8 @@ int sim_cmd_file(FILE * f, char *s)
 	}
 
 	while (fgets(line, sizeof(line) - 1, cmd_file) != NULL) {
+		if((p = strchr(line, '\n')) != NULL)
+			*p = '\0';
 		do_cmd(line, f);
 	}
 
@@ -588,11 +590,14 @@ static int sim_run_console(int fd)
 {
 	char line[128];
 	int ret = 0;
+	char *p = NULL;
 
 	ret = readline(fd, line, sizeof(line) - 1);
 	if (ret <= 0)
 		return ret;
 
+	if((p = strchr(line, '\n')) != NULL)
+		*p = '\0';
 	do_cmd(line, simout);
 	fprintf(simout, "sim%s> ", netstarted ? "" : " (inactive)");
 	fflush(simout);
-- 
1.7.1--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
