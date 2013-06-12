From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 4/6] ibsysstat.c: fix resource leak
Date: Wed, 12 Jun 2013 09:55:43 -0400
Message-ID: <51B87DDF.1090205@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Memory leak.

Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibsysstat.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/src/ibsysstat.c b/src/ibsysstat.c
index eb876d4..c1438c1 100644
--- a/src/ibsysstat.c
+++ b/src/ibsysstat.c
@@ -271,8 +271,10 @@ int build_cpuinfo(void)
 	while (fgets(line, sizeof(line) - 1, f)) {
 		if (!strncmp(line, "processor\t", 10)) {
 			ncpu++;
-			if (ncpu > MAX_CPUS)
+			if (ncpu > MAX_CPUS) {
+				fclose(f);
 				return MAX_CPUS;
+			}
 			continue;
 		}
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
