From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: smpdump fix option 'string'
Date: Thu, 3 May 2012 10:31:00 -0700
Message-ID: <20120503103100.51a055dd.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/smpdump.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/smpdump.c b/src/smpdump.c
index a6c4dfa..1e79c52 100644
--- a/src/smpdump.c
+++ b/src/smpdump.c
@@ -215,7 +215,7 @@ int main(int argc, char *argv[])
 	int length;
 
 	const struct ibdiag_opt opts[] = {
-		{"sring", 's', 0, NULL, ""},
+		{"string", 's', 0, NULL, ""},
 		{0}
 	};
 	char usage_args[] = "<dlid|dr_path> <attr> [mod]";
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
