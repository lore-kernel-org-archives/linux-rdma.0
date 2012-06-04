From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] ibacm/acme: Eliminate segfault when SLID/SGID not given
Date: Mon, 4 Jun 2012 19:19:51 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A25C2C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Problem and cause reported by Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acme.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/src/acme.c b/src/acme.c
index e6ae188..0e1d4ed 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -495,7 +495,8 @@ static int resolve_lid(struct ibv_path_record *path)
 {
 	int ret;
 
-	path->slid = htons((uint16_t) atoi(src_addr));
+	if (src_addr)
+		path->slid = htons((uint16_t) atoi(src_addr));
 	path->dlid = htons((uint16_t) atoi(dest_addr));
 	path->reversible_numpath = IBV_PATH_RECORD_REVERSIBLE | 1;
 
@@ -510,10 +511,13 @@ static int resolve_gid(struct ibv_path_record *path)
 {
 	int ret;
 
-	ret = inet_pton(AF_INET6, src_addr, &path->sgid);
-	if (ret <= 0) {
-		printf("inet_pton error on source address (%s): 0x%x\n", src_addr, ret);
-		return ret ? ret : -1;
+	if (src_addr) {
+		ret = inet_pton(AF_INET6, src_addr, &path->sgid);
+		if (ret <= 0) {
+			printf("inet_pton error on source address (%s): 0x%x\n",
+			       src_addr, ret);
+			return ret ? ret : -1;
+		}
 	}
 
 	ret = inet_pton(AF_INET6, dest_addr, &path->dgid);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
