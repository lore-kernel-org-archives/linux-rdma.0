From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 4/4] rsockets: Support calling listen multiple times on
 same rsocket
Date: Thu, 18 Sep 2014 16:20:53 +0530
Message-ID: <0a6a8d14f8b06bab2682dd4e555c315d@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_21c6c7361f8b89fe3d3eb22cc59a56a4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--=_21c6c7361f8b89fe3d3eb22cc59a56a4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

Note: The modified fix from Sean is being resent for completeness of 
changes
       Also attached the patch file for convenience

 From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Thu Sep 18 14:51:58 2014 +0530

     Standard sockets allows an application to call listen() multiple
     times on the same socket without error.  This allows a 
multi-threaded
     app to call listen from all threads.

     rsockets will fail the second listen call.  Modify the behavior to
     match standard sockets.

     Problem reported by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

     Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
     ---

diff --git a/src/rsocket.c b/src/rsocket.c
index 16792cf..ae72a00 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1179,9 +1179,15 @@ int rlisten(int socket, int backlog)
         rs = idm_lookup(&idm, socket);
         if (!rs)
                 return ERR(EBADF);
-       ret = rdma_listen(rs->cm_id, backlog);
-       if (!ret)
-               rs->state = rs_listening;
+
+       if (rs->state != rs_listening) {
+               ret = rdma_listen(rs->cm_id, backlog);
+               if (!ret)
+                       rs->state = rs_listening;
+       } else {
+               ret = 0;
+       }
+
         return ret;
  }

--=_21c6c7361f8b89fe3d3eb22cc59a56a4
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=librdmacm_src_rsocket_multi_listen_20140918.patch4
Content-Disposition: attachment;
 filename=librdmacm_src_rsocket_multi_listen_20140918.patch4;
 size=1064

Y29tbWl0IDc5ZDNmNWNiZmM5MmI0OGRlMzNhZDFjZDIyNDM3YWE2Y2UyNGNjNTIKQXV0aG9yOiBT
cmVlZGhhciBLb2RhbGkgPHNya29kYWxpQGxpbnV4LnZuZXQuaWJtLmNvbT4KRGF0ZTogICBUaHUg
U2VwIDE4IDE0OjUxOjU4IDIwMTQgKzA1MzAKCiAgICBTdGFuZGFyZCBzb2NrZXRzIGFsbG93cyBh
biBhcHBsaWNhdGlvbiB0byBjYWxsIGxpc3RlbigpIG11bHRpcGxlCiAgICB0aW1lcyBvbiB0aGUg
c2FtZSBzb2NrZXQgd2l0aG91dCBlcnJvci4gIFRoaXMgYWxsb3dzIGEgbXVsdGktdGhyZWFkZWQK
ICAgIGFwcCB0byBjYWxsIGxpc3RlbiBmcm9tIGFsbCB0aHJlYWRzLgogICAgCiAgICByc29ja2V0
cyB3aWxsIGZhaWwgdGhlIHNlY29uZCBsaXN0ZW4gY2FsbC4gIE1vZGlmeSB0aGUgYmVoYXZpb3Ig
dG8KICAgIG1hdGNoIHN0YW5kYXJkIHNvY2tldHMuCiAgICAKICAgIFByb2JsZW0gcmVwb3J0ZWQg
Ynk6IFNyZWVkaGFyIEtvZGFsaSA8c3Jrb2RhbGlAbGludXgudm5ldC5pYm0uY29tPgogICAgCiAg
ICBTaWduZWQtb2ZmLWJ5OiBTZWFuIEhlZnR5IDxzZWFuLmhlZnR5QGludGVsLmNvbT4KICAgIC0t
LQoKZGlmZiAtLWdpdCBhL3NyYy9yc29ja2V0LmMgYi9zcmMvcnNvY2tldC5jCmluZGV4IDE2Nzky
Y2YuLmFlNzJhMDAgMTAwNjQ0Ci0tLSBhL3NyYy9yc29ja2V0LmMKKysrIGIvc3JjL3Jzb2NrZXQu
YwpAQCAtMTE3OSw5ICsxMTc5LDE1IEBAIGludCBybGlzdGVuKGludCBzb2NrZXQsIGludCBiYWNr
bG9nKQogCXJzID0gaWRtX2xvb2t1cCgmaWRtLCBzb2NrZXQpOwogCWlmICghcnMpCiAJCXJldHVy
biBFUlIoRUJBREYpOwotCXJldCA9IHJkbWFfbGlzdGVuKHJzLT5jbV9pZCwgYmFja2xvZyk7Ci0J
aWYgKCFyZXQpCi0JCXJzLT5zdGF0ZSA9IHJzX2xpc3RlbmluZzsKKworCWlmIChycy0+c3RhdGUg
IT0gcnNfbGlzdGVuaW5nKSB7CisJCXJldCA9IHJkbWFfbGlzdGVuKHJzLT5jbV9pZCwgYmFja2xv
Zyk7CisJCWlmICghcmV0KQorCQkJcnMtPnN0YXRlID0gcnNfbGlzdGVuaW5nOworCX0gZWxzZSB7
CisJCXJldCA9IDA7CisJfQorCiAJcmV0dXJuIHJldDsKIH0KIAo=
--=_21c6c7361f8b89fe3d3eb22cc59a56a4--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
