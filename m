From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] rsocket: Fix crash resulting from keepalive timeout
Date: Wed,  2 Jul 2014 15:46:22 -0700
Message-ID: <1404341182-12533-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following crash was reported by Hal Rosenstock,
<hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, with keepalive enabled.  The crash
occurs in the keepalive thread attempting to send a
keepalive message.

report:
Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7fffecf08700 (LWP 6013)]
rs_post_write (rs=<value optimized out>, sgl=0x0, nsge=0, wr_data=3758096385,
    flags=0, addr=0, rkey=0) at src/rsocket.c:1660
1660            return rdma_seterrno(ibv_post_send(rs->cm_id->qp, &wr, &bad));
Missing separate debuginfos, use: debuginfo-install glibc-2.12-1.107.el6.x86_64
(gdb)
(gdb) p/x rs
$1 = value has been optimized out

So I added in the following to debug:
1660    if (rs == NULL)
1661    abort();
1662    if (rs->cm_id == NULL)
1663    abort();
1664    if (rs->cm_id->qp == NULL)
1665    abort();
1666            return rdma_seterrno(ibv_post_send(rs->cm_id->qp, &wr, &bad));
1667    }

And saw in gdb:

Program received signal SIGABRT, Aborted.
[Switching to Thread 0x7fffecf08700 (LWP 8096)]
0x00000030d50328a5 in raise () from /lib64/libc.so.6
Missing separate debuginfos, use: debuginfo-install glibc-2.12-1.107.el6.x86_64
(gdb)
(gdb) bt
#0  0x00000030d50328a5 in raise () from /lib64/libc.so.6
#1  0x00000030d5034085 in abort () from /lib64/libc.so.6
#2  0x00007ffff057fe23 in rs_post_write (rs=<value optimized out>, sgl=0x1fa0,
    nsge=6, wr_data=4294967295, flags=0, addr=0, rkey=0) at src/rsocket.c:1665
#3  0x00007ffff058193d in tcp_svc_send_keepalive (arg=0x7ffff0789f20)
    at src/rsocket.c:4245
#4  tcp_svc_run (arg=0x7ffff0789f20) at src/rsocket.c:4279
#5  0x00000030d5807851 in start_thread () from /lib64/libpthread.so.0
#6  0x00000030d50e890d in clone () from /lib64/libc.so.6
(gdb) fr 2
#2  0x00007ffff057fe23 in rs_post_write (rs=<value optimized out>, sgl=0x1fa0,
    nsge=6, wr_data=4294967295, flags=0, addr=0, rkey=0) at src/rsocket.c:1665
1665    abort();

So qp is NULL somehow...
:end report

There is an issue if an rsocket is closed without going through
the rshutdown.

int rshutdown(int socket, int how)
{
	...
	if (rs->opts & RS_OPT_SVC_ACTIVE)
		rs_notify_svc(&tcp_svc, rs, RS_SVC_REM_KEEPALIVE);

We remove the rsocket from the keepalive thread in rshutdown.

int rclose(int socket)
{
	...
		if (rs->state & rs_connected)
			rshutdown(socket, SHUT_RDWR);
	...
	rs_free(rs);

rclose will call shutdown only if we're connected.  However, if the
keepalive failed, the socket will be in an error state.  So,
no call to rshutdown, which will leave the freed rsocket on
the keepalive thread's list.

The fix is to to have rclose remove an rsocket from being processed
by a service thread if it is still active.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 3048e5e..f81fb1b 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -3265,6 +3265,8 @@ int rclose(int socket)
 	if (rs->type == SOCK_STREAM) {
 		if (rs->state & rs_connected)
 			rshutdown(socket, SHUT_RDWR);
+		else if (rs->opts & RS_OPT_SVC_ACTIVE)
+			rs_notify_svc(&tcp_svc, rs, RS_SVC_REM_KEEPALIVE);
 	} else {
 		ds_shutdown(rs);
 	}
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
