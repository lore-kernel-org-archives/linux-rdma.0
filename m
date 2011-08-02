From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch libibverbs-1.1.5] Fix broken compat assumption on ppc arch
Date: Tue, 02 Aug 2011 15:15:11 -0400
Message-ID: <4E384CBF.6080905@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090804010703090300050700"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------090804010703090300050700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

In the compat-1.0 wrapper, the post_send wrapper assumes that the layout 
of the tail end of the ibv_send_wr struct is the same in version 1.0 and 
1.1.  Unfortunately, padding of the struct makes this untrue depending 
on the architecture.  In my case, it was ppc that was failing to compile 
because we were triggering the gcc built in memcpy check.  We were 
scribbling past the end of the structure of the new structure because 
the old structure has alignment padding that the new one doesn't.  There 
are two spots that are padded in the version 1.0 ibv_send_wr struct, 4 
bytes before sg_list, and 4 more bytes before wr.

So this patch conditionalizes whether or not we use memcpy on the basis 
of data that will be reduced to constants at compile time, so even 
though there is an if statement, it gets reduced to just the proper 
method for the given arch at compile time.  And the patch will attempt a 
simple memcpy if possible, or two memcpy's in the case that wr needed 
padding to be aligned (as is the case on ppc), and fall back to field 
based copy just in case this is compiled on some arch with really odd 
field alignment characteristics.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--------------090804010703090300050700
Content-Type: text/plain;
 name="libibverbs-1.1.5-memcpy.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="libibverbs-1.1.5-memcpy.patch"

diff -up libibverbs-1.1.5/src/compat-1_0.c.memcpy libibverbs-1.1.5/src/compat-1_0.c
--- libibverbs-1.1.5/src/compat-1_0.c.memcpy	2011-06-28 17:13:45.000000000 -0400
+++ libibverbs-1.1.5/src/compat-1_0.c	2011-08-02 12:07:20.114511405 -0400
@@ -350,8 +350,46 @@ static int post_send_wrapper_1_0(struct 
 		real_wr->wr_id = w->wr_id;
 		real_wr->next  = NULL;
 
-		memcpy(&real_wr->sg_list, &w->sg_list,
-		       sizeof *w - offsetof(struct ibv_send_wr, sg_list));
+#define TEST_SIZE_2_POINT(f1, f2) \
+((offsetof(struct ibv_send_wr, f1) - offsetof(struct ibv_send_wr, f2)) \
+== offsetof(struct ibv_send_wr_1_0, f1) - offsetof(struct ibv_send_wr_1_0, f2))
+#define TEST_SIZE_TO_END(f1) \
+((sizeof(struct ibv_send_wr) - offsetof(struct ibv_send_wr, f1)) == \
+ (sizeof(struct ibv_send_wr_1_0) - offsetof(struct ibv_send_wr_1_0, f1)))
+
+		if (TEST_SIZE_TO_END (sg_list))
+			memcpy(&real_wr->sg_list, &w->sg_list, sizeof *real_wr
+			       - offsetof(struct ibv_send_wr, sg_list));
+		else if (TEST_SIZE_2_POINT (imm_data, sg_list) &&
+			 TEST_SIZE_TO_END (wr)) {
+			/* we have alignment up to wr, but padding between
+			 * imm_data and wr, and we know wr itself is the
+			 * same size */
+			memcpy(&real_wr->sg_list, &w->sg_list,
+			       offsetof(struct ibv_send_wr, imm_data) -
+			       offsetof(struct ibv_send_wr, sg_list) +
+			       sizeof real_wr->imm_data);
+			memcpy(&real_wr->wr, &w->wr, sizeof real_wr->wr);
+		} else {
+			real_wr->sg_list = w->sg_list;
+			real_wr->num_sge = w->num_sge;
+			real_wr->opcode = w->opcode;
+			real_wr->send_flags = w->send_flags;
+			real_wr->imm_data = w->imm_data;
+			if (TEST_SIZE_TO_END (wr))
+				memcpy(&real_wr->wr, &w->wr,
+				       sizeof real_wr->wr);
+			else {
+				real_wr->wr.atomic.remote_addr = 
+					w->wr.atomic.remote_addr;
+				real_wr->wr.atomic.compare_add = 
+					w->wr.atomic.compare_add;
+				real_wr->wr.atomic.swap = 
+					w->wr.atomic.swap;
+				real_wr->wr.atomic.rkey = 
+					w->wr.atomic.rkey;
+			}
+		}
 
 		if (is_ud)
 			real_wr->wr.ud.ah = w->wr.ud.ah->real_ah;

--------------090804010703090300050700--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
