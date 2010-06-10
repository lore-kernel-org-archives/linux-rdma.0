From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fix MFT record dump
Date: Thu, 10 Jun 2010 18:03:03 +0300
Message-ID: <4C10FEA7.7030400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

fix wrong MLID calculation in MFT record dump.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/saquery.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/src/saquery.c b/infiniband-diags/src/saquery.c
index 5e9a5ad..cb4fc18 100644
--- a/infiniband-diags/src/saquery.c
+++ b/infiniband-diags/src/saquery.c
@@ -788,16 +788,18 @@ static void dump_one_mft_record(void *data)
 	unsigned block = cl_ntoh16(mftr->position_block_num) &
 	    IB_MCAST_BLOCK_ID_MASK_HO;
 	int i;
+	unsigned offset;
+
 	printf("MFT Record dump:\n"
 	       "\t\tLID........................%u\n"
 	       "\t\tPosition...................%u\n"
 	       "\t\tBlock......................%u\n"
 	       "\t\tMFT:\n\t\tMLID\tPort Mask\n",
 	       cl_ntoh16(mftr->lid), position, block);
+	offset = IB_LID_MCAST_START_HO + block * 32;
 	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
-		printf("\t\t0x%x\t0x%x\n",
-		       IB_LID_MCAST_START_HO + block * 64 + i,
-		       cl_ntoh16(mftr->mft[i]));
+		printf("\t\t0x%04x\t0x%04x\n",
+		       offset + i, cl_ntoh16(mftr->mft[i]));
 	printf("\n");
 }
 
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
