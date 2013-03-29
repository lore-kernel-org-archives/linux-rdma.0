From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libibumad: document the setting of errno for umad_send and
 umad_recv
Date: Fri, 29 Mar 2013 11:21:19 -0700
Message-ID: <20130329112119.1bb9ee1f7e687fc40c7a841d@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 man/umad_recv.3 |    3 ++-
 man/umad_send.3 |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/man/umad_recv.3 b/man/umad_recv.3
index e233411..56e4ca7 100644
--- a/man/umad_recv.3
+++ b/man/umad_recv.3
@@ -55,7 +55,8 @@ be returned.
 
 .SH "RETURN VALUE"
 .B umad_recv()
-returns non negative receiving agentid on success, and a negative value on error as follows:
+on success return the agentid; on error, errno is set and a negative value is
+returned as follows:
  -EINVAL      invalid port handle or agentid or *length is less than the minimum supported
  -EIO         receive operation failed
  -EWOULDBLOCK non blocking read can't be fulfilled
diff --git a/man/umad_send.3 b/man/umad_send.3
index feb33af..b85bc56 100644
--- a/man/umad_send.3
+++ b/man/umad_send.3
@@ -39,7 +39,8 @@ makes kernel wait forever for the reply.
 indicates the number of times the MAD will be retried before giving up.
 .SH "RETURN VALUE"
 .B umad_send()
-returns 0 on success, and a negative value on error as follows:
+returns 0 on success; on error, errno is set and a negative value is returned
+as follows:
  -EINVAL invalid port handle or agentid
  -EIO    send operation failed
 .SH "AUTHOR"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
