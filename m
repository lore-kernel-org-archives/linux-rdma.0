From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2] libibumad: update umad_recv man page.
Date: Tue, 3 Jul 2012 09:55:22 -0700
Message-ID: <20120703095522.1e89cd25.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Document the umad_recv length parameter better.

Changes since V1:
	add comments from Hal

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 man/umad_recv.3 |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/man/umad_recv.3 b/man/umad_recv.3
index e1b2985..310d3d2 100644
--- a/man/umad_recv.3
+++ b/man/umad_recv.3
@@ -27,10 +27,26 @@ A negative
 makes the function block until a packet is received. A
 .I timeout_ms\fR
 parameter of zero indicates a non blocking read.
+
+.B Note
+.I length
+is a pointer to the length of the
+.B data
+portion of the umad buffer.  This means that
+.I umad
+should point to a buffer at least umad_size() +
+.I *length
+bytes long.
+
+.B Note also
+that
+.I *length\fR
+must be >= 256 bytes.
+
 .SH "RETURN VALUE"
 .B umad_recv()
 returns non negative receiving agentid on success, and a negative value on error as follows:
- -EINVAL      invalid port handle or agentid
+ -EINVAL      invalid port handle or agentid or *length is less than the minimum
  -EIO         receive operation failed
  -EWOULDBLOCK non blocking read can't be fulfilled
 .SH "SEE ALSO"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
