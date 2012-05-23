From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsockets and standard socket based TCP benchmarks
Date: Wed, 23 May 2012 23:16:01 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A23C38@ORSMSX101.amr.corp.intel.com>
References: <4FBD6981.2070502@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FBD6981.2070502-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> netperf
> - By default netserver forks a child process for each netperf client. As
> rsockets
>    doesn't support fork() yet, this doesn't work.

Btw, fork() is unlikely to work anytime soon, if ever...

> - netserver has a -f option to disable forking a child and handle 1
> netperf client at a time
>    Using this option, data transfer completed successfully, but the
> client blocked on recv()
>    even after the connection is closed on the other side. Here is the
> stack trace.
> 
> #0  0x000000805caa77e4 in __read_nocancel () from /lib64/libc.so.6
> #1  0x00000fffa4543d48 in .read () from
> /home/sridhar/librdmacm/src/preload.so
> #2  0x000000805ccfe68c in .ibv_get_cq_event () from
> /usr/lib64/libibverbs.so.1
> #3  0x00000fffa456a534 in rs_get_cq_event (rs=0x100203105f0)
>      at src/rsocket.c:825
> #4  0x00000fffa456bb48 in rs_process_cq (rs=0x100203105f0,
>      nonblock=<value optimized out>,
>      test=@0xfffa457e7d8: 0xfffa45697b0 <rs_have_rdata>) at
> src/rsocket.c:894
> #5  0x00000fffa456d4e0 in rrecv (socket=<value optimized out>,
>      buf=0xffff97e15f8, len=1, flags=<value optimized out>)
>      at src/rsocket.c:1007
> #6  0x00000fffa4543a08 in .recv () from
> /home/sridhar/librdmacm/src/preload.so
> #7  0x00000000100497f4 in .disconnect_data_socket ()
> #8  0x000000001004c528 in .send_omni_inner ()
> #9  0x00000000100502e0 in .send_tcp_stream ()
> #10 0x00000000100028a4 in .main ()

Thanks - I'll look into this.  Do you know offhand if the server calls shutdown/close?

I do know that abrupt shutdown is an area that needs work, along with real support for KEEPALIVE.

> iperf
> - Successfully got iperf working using rsockets via preload library.
>    With default 128K message sizes, on P6 systems with Mellanox ConnectX
> cards, here are
>    some test results for comparision.
>          IPoIB  : 1.5Gb/s
>          IPoIB Connected Mode: 5.5Gb/s
>          rsockets using RDMA : 8.9Gb/s
>          ib_write_bw(native RDMA using ibverbs): 12Gb/s

Note that I've recently added additional controls to rsockets to adjust the size of the QP and inline data.  I haven't posted these patches yet (still testing), but I've been able to use them to increase bandwidth that I see on my systems from 24 Gbps to 26 Gbps.  I'll add both netperf and iperf to my list of apps to test.  From the above trace, it looks like netperf uses blocking calls.  I'm not sure about iperf, but the use of blocking calls impacts rsocket performance considerably.  I'm actively working on trying to reduce that impact.  rstream uses nonblocking calls and should be able to come close to ib_write_bw() performance.

Thanks for the feedback!

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
