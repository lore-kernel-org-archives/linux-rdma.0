From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm] fix udpong segfault on rconnect error
Date: Wed, 22 Jun 2016 09:15:50 -0400
Message-ID: <1466601350-47463-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Before patch:
[root@rdma-qe-05 librdmacm (master *)]$ udpong -s 172.31.45.4
name      bytes   xfers   total       time     Gb/sec    usec/xfer
rconnect: No such file or directory
Segmentation fault (core dumped)

After patch:
[root@rdma-qe-05 librdmacm (master *)]$ ./examples/udpong -s 172.31.45.4
name      bytes   xfers   total       time     Gb/sec    usec/xfer
rconnect: No such file or directory

Simple fix, just a missing goto on error, so we don't try to do things
that are already expected to fail.

CC: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 examples/udpong.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/examples/udpong.c b/examples/udpong.c
index 97713a2..6affc62 100644
--- a/examples/udpong.c
+++ b/examples/udpong.c
@@ -427,6 +427,7 @@ static int client_connect(void)
 	if (ret) {
 		perror("rconnect");
 		rs_close(rs);
+		goto out;
 	}
 
 	msg.op = msg_op_login;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
