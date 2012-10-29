From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: some warnings seen while building librdmacm 1.0.16
Date: Mon, 29 Oct 2012 14:09:24 +0200
Message-ID: <508E71F4.8080205@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

FYI -- the below warnings seen while building librdmacm 1.0.16 with gcc 
4.4.6 through rpmbuild

Or.

> make[1]: Entering directory `/root/rpmbuild/BUILD/librdmacm-1.0.16'
>   CC     src_librdmacm_la-cma.lo
>   CC     src_librdmacm_la-addrinfo.lo
>   CC     src_librdmacm_la-acm.lo
>   CC     src_librdmacm_la-rsocket.lo
>   CC     src_librdmacm_la-indexer.lo
>   CC     src_librspreload_la-preload.lo
>   CC     src_librspreload_la-indexer.lo
>   CC     cmatose.o
>   CC     common.o
>   CC     rping.o
>   CC     udaddy.o
>   CC     mckey.o
>   CC     rdma_client.o
>   CC     rdma_server.o
>   CC     rdma_xclient.o
>   CC     rdma_xserver.o
>   CC     rstream.o
> src/rsocket.c: In function 'rs_configure':
> src/rsocket.c:223: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:228: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:236: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:241: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:246: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:254: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> examples/mckey.c: In function 'run':
> examples/mckey.c:473: warning: dereferencing pointer 'sib' does break 
> strict-aliasing rules
> examples/mckey.c:471: note: initialized from here
>   CC     rcopy.o
>   CCLD   src/librdmacm.la
>   CCLD   src/librspreload.la
>   CCLD   examples/ucmatose
>   CCLD   examples/rping
>   CCLD   examples/udaddy
>   CCLD   examples/mckey
>   CCLD   examples/rdma_client
>   CCLD   examples/rdma_server
>   CCLD   examples/rdma_xclient
>   CCLD   examples/rstream
>   CCLD   examples/rdma_xserver
>   CCLD   examples/rcopy
> make[1]: Leaving directory `/root/rpmbuild/BUILD/librdmacm-1.0.16'
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
