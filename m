From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-3.2 v1 2/5] ib/ipoib: Modified rate computation
Date: Tue, 4 Oct 2011 15:28:23 +0300
Message-ID: <201110041428.23515.marcela@dev.mellanox.co.il>
References: <201110031755.19978.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201110031755.19978.marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changes from v1
- Use ib_rate_to_mbps instead of ib_rate_to_int
- Modified the call to seq_printf

Modified the way that speed rate is computed because of the
new IBA extended speeds that are no longer multiple of 2.5 Gbps.

Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_fs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -212,16 +212,15 @@ static int ipoib_path_seq_show(struct se
 		   gid_buf, path.pathrec.dlid ? "yes" : "no");
 
 	if (path.pathrec.dlid) {
-		rate = ib_rate_to_mult(path.pathrec.rate) * 25;
+		rate = ib_rate_to_mbps(path.pathrec.rate);
 
 		seq_printf(file,
 			   "  DLID:     0x%04x\n"
 			   "  SL: %12d\n"
-			   "  rate: %*d%s Gb/sec\n",
+			   "  rate: %8d.%d Gb/sec\n",
 			   be16_to_cpu(path.pathrec.dlid),
 			   path.pathrec.sl,
-			   10 - ((rate % 10) ? 2 : 0),
-			   rate / 10, rate % 10 ? ".5" : "");
+			   rate / 1000, rate % 1000);
 	}
 
 	seq_putc(file, '\n');
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
