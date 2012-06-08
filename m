From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] librdamcm/rsocket: Handle SHUT_RD/WR shutdown flags
Date: Fri, 08 Jun 2012 10:13:38 -0700
Message-ID: <1339175618.31214.232.camel@oc1677441337.ibm.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A2F1ED@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A2F1ED-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2012-06-06 at 18:42 +0000, Hefty, Sean wrote:
> Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> reported an error (EOPNOTSUPP)
> after calling select().
> 
> The issue is that rshutdown(SHUT_WR) was called before select().
> As part of shutdown, rsockets switches the underlying fd from
> nonblocking to blocking to ensure that previously sent data has
> completed.  shutdown(SHUT_WR) indicates that the socket should be
> kept open for receiving data.
> 
> Delay handling the actual shutdown unless SHUT_RDWR is specified,
> or the socket is closed.

Unfortunately this introduces another issue.
This causes netperf to hang in recv() after shutdown(SHUT_WR)
on the data socket.

#0  0x000000805caa77e4 in __read_nocancel () from /lib64/libc.so.6
#1  0x00000fff78e6422c in .read ()
   from /home/sridhar/git/librdmacm/src/preload.so
#2  0x000000805ccfe68c in .ibv_get_cq_event () from /usr/lib64/libibverbs.so.1
#3  0x00000fff78e8a9d4 in rs_get_cq_event (rs=0x1000b85f220)
    at src/rsocket.c:867
#4  0x00000fff78e8c160 in rs_process_cq (rs=0x1000b85f220, 
    nonblock=<value optimized out>, 
    test=@0xfff78e9efc0: 0xfff78e899c0 <rs_conn_have_rdata>)
    at src/rsocket.c:915
#5  0x00000fff78e8d2c0 in rrecv (socket=<value optimized out>, 
    buf=0xfffd897e428, len=1, flags=<value optimized out>)
    at src/rsocket.c:1037
#6  0x00000fff78e63eec in .recv ()
   from /home/sridhar/git/librdmacm/src/preload.so
#7  0x00000000100497f4 in .disconnect_data_socket ()
#8  0x000000001004c528 in .send_omni_inner ()
#9  0x00000000100502e0 in .send_tcp_stream ()
#10 0x00000000100028a4 in .main ()


> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  src/rsocket.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/src/rsocket.c b/src/rsocket.c
> index c111797..8f20b4a 100644
> --- a/src/rsocket.c
> +++ b/src/rsocket.c
> @@ -1592,6 +1592,9 @@ int rshutdown(int socket, int how)
>  	struct rsocket *rs;
>  	int ret = 0;
> 
> +	if (how != SHUT_RDWR)
> +		return 0;
> +
>  	rs = idm_at(&idm, socket);
>  	if (rs->fd_flags & O_NONBLOCK)
>  		rs_set_nonblocking(rs, 0);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
