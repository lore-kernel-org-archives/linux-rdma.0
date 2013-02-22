From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibumad: update umad_[send|recv] man pages to document
 how rmpp is handled
Date: Fri, 22 Feb 2013 08:48:19 -0800
Message-ID: <20130222084819.ce49c620e5b46aa829395241@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 man/umad_recv.3 |   17 ++++++++++++++---
 man/umad_send.3 |    8 ++++++++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/man/umad_recv.3 b/man/umad_recv.3
index e4d52fd..e233411 100644
--- a/man/umad_recv.3
+++ b/man/umad_recv.3
@@ -13,9 +13,18 @@ umad_recv \- receive umad
 .B umad_recv()
 waits up to
 .I timeout_ms\fR
-milliseconds for a packet to be received from the port specified by
+milliseconds for an incoming MAD message to be received from the port specified by
 .I portid\fR.
-The packet is copied to the
+
+A MAD "message" consists of a single MAD packet
+.I or
+a coalesced multipacket RMPP transmission.  In the RMPP case the header of the
+first RMPP packet is returned as the header of the buffer and the buffer data
+contains the coalesced data section of each subsequent RMPP MAD packet within
+the transmission.  Thus all the RMPP headers except the first are not copied to
+user space from the kernel.
+
+The message is copied to the
 .I umad\fR
 buffer if there is sufficient room and the received
 .I length\fR is indicated.
@@ -41,7 +50,8 @@ bytes long.
 .B Note also
 that
 .I *length\fR
-must be >= 256 bytes.
+must be >= 256 bytes.  This length allows for at least a single MAD packet to
+be returned.
 
 .SH "RETURN VALUE"
 .B umad_recv()
@@ -49,6 +59,7 @@ returns non negative receiving agentid on success, and a negative value on error
  -EINVAL      invalid port handle or agentid or *length is less than the minimum supported
  -EIO         receive operation failed
  -EWOULDBLOCK non blocking read can't be fulfilled
+ -ENOSPC      The provided buffer is not long enough for the complete message.
 .SH "SEE ALSO"
 .BR umad_poll (3)
 .SH "AUTHOR"
diff --git a/man/umad_send.3 b/man/umad_send.3
index f3158cb..feb33af 100644
--- a/man/umad_send.3
+++ b/man/umad_send.3
@@ -19,6 +19,14 @@ buffer from the port specified by
 .I portid\fR,
 and using the agent specified by
 .I agentid\fR.
+
+The buffer can contain a RMPP transmission which is larger than a single MAD
+packet when the agentid specifies a class which utilizes RMPP and the header
+flags indicate RMPP is active.  NOTE currently only RMPPFlags.Active is
+meaningful in the header in user space.  All other RMPP fields are ignored.
+The data section of the buffer will be sent in multiple RMPP MAD packets with
+headers built for the user.
+
 .I timeout_ms\fR
 controls the solicited MADs behavior as follows:
 zero value means not solicited. Positive value makes kernel indicate timeout
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
