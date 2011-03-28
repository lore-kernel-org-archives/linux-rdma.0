From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] librdmacm/doc: document the limitations on the user provided
 private data length
Date: Mon, 28 Mar 2011 10:49:33 +0200
Message-ID: <alpine.LRH.2.00.1103281048280.17717@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Document the limitations on the user provided private data length
over Infiniband networks. These limitations are calculated by
subtracting the rdma-cm header size (see IBA Annex A11 "RDMA CM IP
Service") from IB's private data len for the REQ (rdma_connect) and
REP (rdma_accept) messages

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

 man/rdma_accept.3  |    2 ++
 man/rdma_connect.3 |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/man/rdma_accept.3 b/man/rdma_accept.3
index ac04e2c..0a9415a 100644
--- a/man/rdma_accept.3
+++ b/man/rdma_accept.3
@@ -84,5 +84,7 @@ by the active side of the connection.  The HCA ACK delay is a property of
 the locally used HCA.
 .P
 The RNR retry count is a 3-bit value.
+.P
+The length of the private data provided by the user is limited to 160 bytes.
 .SH "SEE ALSO"
 rdma_listen(3), rdma_reject(3), rdma_get_cm_event(3)
diff --git a/man/rdma_connect.3 b/man/rdma_connect.3
index b0cc51e..8035d47 100644
--- a/man/rdma_connect.3
+++ b/man/rdma_connect.3
@@ -79,6 +79,8 @@ Administrator and is part of the resolved route (path record) information.
 The HCA ACK delay is a property of the locally used HCA.
 .P
 Retry count and RNR retry count values are 3-bit values.
+.P
+The length of the private data provided by the user is limited to 56 bytes.
 .SH "IWARP SPECIFIC"
 Connections established over iWarp RDMA devices currently require that the
 active side of the connection send the first message.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
