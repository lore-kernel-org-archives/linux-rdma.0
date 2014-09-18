From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 3/4] rsockets: fix rsocket state when interrupted waiting
 for events
Date: Thu, 18 Sep 2014 16:15:58 +0530
Message-ID: <3429fa019ebfb4a49bf1e670da8ae4fe@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_dd9ca5d1f345a3f08e6ad54957c66fa4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--=_dd9ca5d1f345a3f08e6ad54957c66fa4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

Note: This patch is reworked based on suggestions from Sean and Jason
       Also attached the patch file for convenience

 From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Thu Sep 18 14:35:42 2014 +0530

     While waiting for a completion event, rsocket state is incorrectly
     set to error when interrupted.  Instead, the caller of get
     completion event should decide what to do with it based on
     errno.  The fix is do not change the state to rs_error when
     errno is EINTR inside get completion event.

     Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     Reviewed-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     ---

diff --git a/src/rsocket.c b/src/rsocket.c
index 39c35cf..16792cf 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1976,7 +1976,7 @@ static int rs_get_cq_event(struct rsocket *rs)
                         rs->unack_cqe = 0;
                 }
                 rs->cq_armed = 0;
-       } else if (errno != EAGAIN) {
+       } else if (!(errno == EAGAIN || errno == EINTR)) {
                 rs->state = rs_error;
         }

--=_dd9ca5d1f345a3f08e6ad54957c66fa4
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=librdmacm_src_rsocket_fix_state_20140918.patch3
Content-Disposition: attachment;
 filename=librdmacm_src_rsocket_fix_state_20140918.patch3;
 size=946

Y29tbWl0IDNjZDUxYjcyN2I1OGYyZTNhYTAzZDc3ZTljNDEwYTU0ODhhMDkxMTIKQXV0aG9yOiBT
cmVlZGhhciBLb2RhbGkgPHNya29kYWxpQGxpbnV4LnZuZXQuaWJtLmNvbT4KRGF0ZTogICBUaHUg
U2VwIDE4IDE0OjM1OjQyIDIwMTQgKzA1MzAKCiAgICBXaGlsZSB3YWl0aW5nIGZvciBhIGNvbXBs
ZXRpb24gZXZlbnQsIHJzb2NrZXQgc3RhdGUgaXMgaW5jb3JyZWN0bHkKICAgIHNldCB0byBlcnJv
ciB3aGVuIGludGVycnVwdGVkLiAgSW5zdGVhZCwgdGhlIGNhbGxlciBvZiBnZXQKICAgIGNvbXBs
ZXRpb24gZXZlbnQgc2hvdWxkIGRlY2lkZSB3aGF0IHRvIGRvIHdpdGggaXQgYmFzZWQgb24KICAg
IGVycm5vLiAgVGhlIGZpeCBpcyBkbyBub3QgY2hhbmdlIHRoZSBzdGF0ZSB0byByc19lcnJvciB3
aGVuCiAgICBlcnJubyBpcyBFSU5UUiBpbnNpZGUgZ2V0IGNvbXBsZXRpb24gZXZlbnQuCiAgICAK
ICAgIFNpZ25lZC1vZmYtYnk6IFNyZWVkaGFyIEtvZGFsaSA8c3Jrb2RhbGlAbGludXgudm5ldC5p
Ym0uY29tPgogICAgUmV2aWV3ZWQtYnk6IFByYWRlZXAgU2F0eWFuYXJheWFuYSA8cHJhZGVlcHNA
bGludXgudm5ldC5pYm0uY29tPgogICAgLS0tCgpkaWZmIC0tZ2l0IGEvc3JjL3Jzb2NrZXQuYyBi
L3NyYy9yc29ja2V0LmMKaW5kZXggMzljMzVjZi4uMTY3OTJjZiAxMDA2NDQKLS0tIGEvc3JjL3Jz
b2NrZXQuYworKysgYi9zcmMvcnNvY2tldC5jCkBAIC0xOTc2LDcgKzE5NzYsNyBAQCBzdGF0aWMg
aW50IHJzX2dldF9jcV9ldmVudChzdHJ1Y3QgcnNvY2tldCAqcnMpCiAJCQlycy0+dW5hY2tfY3Fl
ID0gMDsKIAkJfQogCQlycy0+Y3FfYXJtZWQgPSAwOwotCX0gZWxzZSBpZiAoZXJybm8gIT0gRUFH
QUlOKSB7CisJfSBlbHNlIGlmICghKGVycm5vID09IEVBR0FJTiB8fCBlcnJubyA9PSBFSU5UUikp
IHsKIAkJcnMtPnN0YXRlID0gcnNfZXJyb3I7CiAJfQogCg==
--=_dd9ca5d1f345a3f08e6ad54957c66fa4--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
