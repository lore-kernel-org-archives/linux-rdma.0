From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 2/4] rsockets: acknowledge completion queue events in batch
Date: Thu, 18 Sep 2014 16:08:33 +0530
Message-ID: <18bdfd1d731439cbe604263b37379cb6@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_7e5821a216462e58317af68f6f6a3c79"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.orgsean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--=_7e5821a216462e58317af68f6f6a3c79
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

Note: This patch is being resent as suggested by Sean
       Also attached the patch file for convenience

 From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Thu Sep 18 14:29:48 2014 +0530

     Perform completion event acknowledgments in batches instead
     of individually to minimze locking overheads.  Size of the
     completion queue decides the size of a batch.

     Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     ---

diff --git a/src/rsocket.c b/src/rsocket.c
index 00d9a18..39c35cf 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -381,6 +381,7 @@ struct rsocket {
         dlist_entry       iomap_list;
         dlist_entry       iomap_queue;
         int               iomap_pending;
+       int           unack_cqe;
  };

  #define DS_UDP_TAG 0x55555555
@@ -599,6 +600,7 @@ static struct rsocket *rs_alloc(struct rsocket 
*inherited_rs, int type)
                         rs->target_iomap_size = def_iomap_size;
                 }
         }
+       rs->unack_cqe = 0;
         fastlock_init(&rs->slock);
         fastlock_init(&rs->rlock);
         fastlock_init(&rs->cq_lock);
@@ -990,8 +992,11 @@ static void rs_free(struct rsocket *rs)

         if (rs->cm_id) {
                 rs_free_iomappings(rs);
-               if (rs->cm_id->qp)
+               if (rs->cm_id->qp) {
+                       if (rs->unack_cqe > 0)
+                               ibv_ack_cq_events(rs->cm_id->recv_cq, 
rs->unack_cqe);
                         rdma_destroy_qp(rs->cm_id);
+               }
                 rdma_destroy_id(rs->cm_id);
         }
@@ -1965,7 +1970,11 @@ static int rs_get_cq_event(struct rsocket *rs)

         ret = ibv_get_cq_event(rs->cm_id->recv_cq_channel, &cq, 
&context);
         if (!ret) {
-               ibv_ack_cq_events(rs->cm_id->recv_cq, 1);
+               rs->unack_cqe += 1;
+               if (rs->unack_cqe == rs->sq_size + rs->rq_size) {
+                       ibv_ack_cq_events(rs->cm_id->recv_cq, 
rs->unack_cqe);
+                       rs->unack_cqe = 0;
+               }
                 rs->cq_armed = 0;
         } else if (errno != EAGAIN) {
                 rs->state = rs_error;


--=_7e5821a216462e58317af68f6f6a3c79
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=librdmacm_src_rsocket_batch_ack_20140918.patch2
Content-Disposition: attachment;
 filename=librdmacm_src_rsocket_batch_ack_20140918.patch2;
 size=1699

Y29tbWl0IDQ5MGEyYWE3NGU3ZGNkZWZlNjg0ZTg1MGQ2NWI2OGJkZTM1MTZlYzQKQXV0aG9yOiBT
cmVlZGhhciBLb2RhbGkgPHNya29kYWxpQGxpbnV4LnZuZXQuaWJtLmNvbT4KRGF0ZTogICBUaHUg
U2VwIDE4IDE0OjI5OjQ4IDIwMTQgKzA1MzAKCiAgICBQZXJmb3JtIGNvbXBsZXRpb24gZXZlbnQg
YWNrbm93bGVkZ21lbnRzIGluIGJhdGNoZXMgaW5zdGVhZAogICAgb2YgaW5kaXZpZHVhbGx5IHRv
IG1pbmltemUgbG9ja2luZyBvdmVyaGVhZHMuICBTaXplIG9mIHRoZQogICAgY29tcGxldGlvbiBx
dWV1ZSBkZWNpZGVzIHRoZSBzaXplIG9mIGEgYmF0Y2guCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6
IFNyZWVkaGFyIEtvZGFsaSA8c3Jrb2RhbGlAbGludXgudm5ldC5pYm0uY29tPgogICAgLS0tCgpk
aWZmIC0tZ2l0IGEvc3JjL3Jzb2NrZXQuYyBiL3NyYy9yc29ja2V0LmMKaW5kZXggMDBkOWExOC4u
MzljMzVjZiAxMDA2NDQKLS0tIGEvc3JjL3Jzb2NrZXQuYworKysgYi9zcmMvcnNvY2tldC5jCkBA
IC0zODEsNiArMzgxLDcgQEAgc3RydWN0IHJzb2NrZXQgewogCWRsaXN0X2VudHJ5CSAgaW9tYXBf
bGlzdDsKIAlkbGlzdF9lbnRyeQkgIGlvbWFwX3F1ZXVlOwogCWludAkJICBpb21hcF9wZW5kaW5n
OworCWludAkgICAgICB1bmFja19jcWU7CiB9OwogCiAjZGVmaW5lIERTX1VEUF9UQUcgMHg1NTU1
NTU1NQpAQCAtNTk5LDYgKzYwMCw3IEBAIHN0YXRpYyBzdHJ1Y3QgcnNvY2tldCAqcnNfYWxsb2Mo
c3RydWN0IHJzb2NrZXQgKmluaGVyaXRlZF9ycywgaW50IHR5cGUpCiAJCQlycy0+dGFyZ2V0X2lv
bWFwX3NpemUgPSBkZWZfaW9tYXBfc2l6ZTsKIAkJfQogCX0KKwlycy0+dW5hY2tfY3FlID0gMDsK
IAlmYXN0bG9ja19pbml0KCZycy0+c2xvY2spOwogCWZhc3Rsb2NrX2luaXQoJnJzLT5ybG9jayk7
CiAJZmFzdGxvY2tfaW5pdCgmcnMtPmNxX2xvY2spOwpAQCAtOTkwLDggKzk5MiwxMSBAQCBzdGF0
aWMgdm9pZCByc19mcmVlKHN0cnVjdCByc29ja2V0ICpycykKIAogCWlmIChycy0+Y21faWQpIHsK
IAkJcnNfZnJlZV9pb21hcHBpbmdzKHJzKTsKLQkJaWYgKHJzLT5jbV9pZC0+cXApCisJCWlmIChy
cy0+Y21faWQtPnFwKSB7CisJCQlpZiAocnMtPnVuYWNrX2NxZSA+IDApCisJCQkJaWJ2X2Fja19j
cV9ldmVudHMocnMtPmNtX2lkLT5yZWN2X2NxLCBycy0+dW5hY2tfY3FlKTsKIAkJCXJkbWFfZGVz
dHJveV9xcChycy0+Y21faWQpOworCQl9CiAJCXJkbWFfZGVzdHJveV9pZChycy0+Y21faWQpOwog
CX0KIApAQCAtMTk2NSw3ICsxOTcwLDExIEBAIHN0YXRpYyBpbnQgcnNfZ2V0X2NxX2V2ZW50KHN0
cnVjdCByc29ja2V0ICpycykKIAogCXJldCA9IGlidl9nZXRfY3FfZXZlbnQocnMtPmNtX2lkLT5y
ZWN2X2NxX2NoYW5uZWwsICZjcSwgJmNvbnRleHQpOwogCWlmICghcmV0KSB7Ci0JCWlidl9hY2tf
Y3FfZXZlbnRzKHJzLT5jbV9pZC0+cmVjdl9jcSwgMSk7CisJCXJzLT51bmFja19jcWUgKz0gMTsK
KwkJaWYgKHJzLT51bmFja19jcWUgPT0gcnMtPnNxX3NpemUgKyBycy0+cnFfc2l6ZSkgeworCQkJ
aWJ2X2Fja19jcV9ldmVudHMocnMtPmNtX2lkLT5yZWN2X2NxLCBycy0+dW5hY2tfY3FlKTsKKwkJ
CXJzLT51bmFja19jcWUgPSAwOworCQl9CiAJCXJzLT5jcV9hcm1lZCA9IDA7CiAJfSBlbHNlIGlm
IChlcnJubyAhPSBFQUdBSU4pIHsKIAkJcnMtPnN0YXRlID0gcnNfZXJyb3I7Cg==
--=_7e5821a216462e58317af68f6f6a3c79--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
