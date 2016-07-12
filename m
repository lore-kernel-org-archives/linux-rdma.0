From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 8/8] i40iw: Add NULL check for puda buffer
Date: Tue, 12 Jul 2016 11:48:46 -0500
Message-ID: <1468342126-29168-9-git-send-email-shiraz.saleem@intel.com>
References: <1468342126-29168-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468342126-29168-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

i40iw_puda_get_listbuf may return NULL if the list is empty.
Add NULL check prior to accessing the pointer.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_puda.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index e9c6e82..c62d354 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -1025,6 +1025,8 @@ static void  i40iw_ieq_compl_pfpdu(struct i40iw_puda_rsrc *ieq,
 	u16 txoffset, bufoffset;
 
 	buf = i40iw_puda_get_listbuf(pbufl);
+	if (!buf)
+		return;
 	nextseqnum = buf->seqnum + fpdu_len;
 	txbuf->totallen = buf->hdrlen + fpdu_len;
 	txbuf->data = (u8 *)txbuf->mem.va + buf->hdrlen;
@@ -1048,6 +1050,8 @@ static void  i40iw_ieq_compl_pfpdu(struct i40iw_puda_rsrc *ieq,
 		fpdu_len -= buf->datalen;
 		i40iw_puda_ret_bufpool(ieq, buf);
 		buf = i40iw_puda_get_listbuf(pbufl);
+		if (!buf)
+			return;
 		bufoffset = (u16)(buf->data - (u8 *)buf->mem.va);
 	} while (1);
 
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
