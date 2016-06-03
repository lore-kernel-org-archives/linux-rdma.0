From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 6/6] IB/hfi1: Suppress sparse warnings
Date: Fri, 3 Jun 2016 12:11:16 -0700
Message-ID: <a7bf3fc5-e703-192e-c7a6-bfef63c9a3d0@sandisk.com>
References: <86c06ca1-753c-6b45-3f65-f9a19f7693cf@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86c06ca1-753c-6b45-3f65-f9a19f7693cf-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that sparse reports the following warnings for the hfi1 driver:

trace.c:217:13: warning: no previous prototype for =E2=80=98print_u64_a=
rray=E2=80=99 [-Wmissing-prototypes]
user_sdma.c:1361:17: warning: dubious: !x & y

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/trace.c     | 13 -------------
 drivers/infiniband/hw/hfi1/user_sdma.c |  4 ++--
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw=
/hfi1/trace.c
index 79b2952..4cfb137 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -214,19 +214,6 @@ const char *print_u32_array(
 	return ret;
 }
=20
-const char *print_u64_array(
-	struct trace_seq *p,
-	u64 *arr, int len)
-{
-	int i;
-	const char *ret =3D trace_seq_buffer_ptr(p);
-
-	for (i =3D 0; i < len; i++)
-		trace_seq_printf(p, "%s0x%016llx", i =3D=3D 0 ? "" : " ", arr[i]);
-	trace_seq_putc(p, 0);
-	return ret;
-}
-
 __hfi1_trace_fn(PKT);
 __hfi1_trace_fn(PROC);
 __hfi1_trace_fn(SDMA);
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniban=
d/hw/hfi1/user_sdma.c
index 2eca5b7..47ffd27 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1355,11 +1355,11 @@ static int set_txreq_header(struct user_sdma_re=
quest *req,
 		 */
 		SDMA_DBG(req, "TID offset %ubytes %uunits om%u",
 			 req->tidoffset, req->tidoffset / req->omfactor,
-			 !!(req->omfactor - KDETH_OM_SMALL));
+			 req->omfactor !=3D KDETH_OM_SMALL);
 		KDETH_SET(hdr->kdeth.ver_tid_offset, OFFSET,
 			  req->tidoffset / req->omfactor);
 		KDETH_SET(hdr->kdeth.ver_tid_offset, OM,
-			  !!(req->omfactor - KDETH_OM_SMALL));
+			  req->omfactor !=3D KDETH_OM_SMALL);
 	}
 done:
 	trace_hfi1_sdma_user_header(pq->dd, pq->ctxt, pq->subctxt,
--=20
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
