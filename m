From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] ib/core: remove some dead code added by the IBoE patches
Date: Mon, 29 Nov 2010 09:20:50 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1011290913560.29567@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

remove dead code added by commit ff7f5aab354 "IBoE UD packet packing support"

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

-----

Eli, I see also the following which relates to commit 4c3eb3ca13966508bcb64f39
"Add VLAN support for IBoE", and wasn't sure if/how to fix that, can you have a look?

CC [M]  drivers/infiniband/hw/mlx4/qp.o
drivers/infiniband/hw/mlx4/qp.c: In function mlx4_ib_post_send:
drivers/infiniband/hw/mlx4/qp.c:1304: warning: vlan may be used uninitialized in this function


diff --git a/drivers/infiniband/core/ud_header.c b/drivers/infiniband/core/ud_header.c
index bb7e192..9b737ff 100644
--- a/drivers/infiniband/core/ud_header.c
+++ b/drivers/infiniband/core/ud_header.c
@@ -278,36 +278,6 @@ void ib_ud_header_init(int     		    payload_bytes,
 EXPORT_SYMBOL(ib_ud_header_init);

 /**
- * ib_lrh_header_pack - Pack LRH header struct into wire format
- * @lrh:unpacked LRH header struct
- * @buf:Buffer to pack into
- *
- * ib_lrh_header_pack() packs the LRH header structure @lrh into
- * wire format in the buffer @buf.
- */
-int ib_lrh_header_pack(struct ib_unpacked_lrh *lrh, void *buf)
-{
-	ib_pack(lrh_table, ARRAY_SIZE(lrh_table), lrh, buf);
-	return 0;
-}
-EXPORT_SYMBOL(ib_lrh_header_pack);
-
-/**
- * ib_lrh_header_unpack - Unpack LRH structure from wire format
- * @lrh:unpacked LRH header struct
- * @buf:Buffer to pack into
- *
- * ib_lrh_header_unpack() unpacks the LRH header structure from
- * wire format (in buf) into @lrh.
- */
-int ib_lrh_header_unpack(void *buf, struct ib_unpacked_lrh *lrh)
-{
-	ib_unpack(lrh_table, ARRAY_SIZE(lrh_table), buf, lrh);
-	return 0;
-}
-EXPORT_SYMBOL(ib_lrh_header_unpack);
-
-/**
  * ib_ud_header_pack - Pack UD header struct into wire format
  * @header:UD header struct
  * @buf:Buffer to pack into
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
