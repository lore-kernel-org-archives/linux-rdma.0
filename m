From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-3.2 v1 2/5] ib/ipoib: Modified rate computation
Date: Mon, 3 Oct 2011 18:55:19 +0300
Message-ID: <201110031755.19978.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Modified the way that speed rate is computed because of the
new IBA extended speeds that are no longer multiple of 2.5 Gbps.

Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_fs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -198,6 +198,7 @@ static int ipoib_path_seq_show(struct se
 	char gid_buf[sizeof "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff"];
 	struct ipoib_path path;
 	int rate;
+	int rate_rounded;
 
 	if (!iter)
 		return 0;
@@ -212,7 +213,7 @@ static int ipoib_path_seq_show(struct se
 		   gid_buf, path.pathrec.dlid ? "yes" : "no");
 
 	if (path.pathrec.dlid) {
-		rate = ib_rate_to_mult(path.pathrec.rate) * 25;
+		rate = ib_rate_to_int(path.pathrec.rate, &rate_rounded);
 
 		seq_printf(file,
 			   "  DLID:     0x%04x\n"
@@ -220,8 +221,8 @@ static int ipoib_path_seq_show(struct se
 			   "  rate: %*d%s Gb/sec\n",
 			   be16_to_cpu(path.pathrec.dlid),
 			   path.pathrec.sl,
-			   10 - ((rate % 10) ? 2 : 0),
-			   rate / 10, rate % 10 ? ".5" : "");
+			   10 - (rate_rounded ? 2 : 0),
+			   rate, rate_rounded ? ".5" : "");
 	}
 
 	seq_putc(file, '\n');
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
