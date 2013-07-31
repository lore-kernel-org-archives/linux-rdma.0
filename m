From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH librdmacm 3/8] autogen.sh: Use autoreconf in autogen.sh
Date: Wed, 31 Jul 2013 09:58:57 +0300
Message-ID: <51F8B5B1.3010003@mellanox.com>
References: <cover.1374011243.git.ydroneaud@opteya.com> <317ae98daf0eec49ffb297a5fc59b3738366af6d.1374011243.git.ydroneaud@opteya.com> <1828884A29C6694DAF28B7E6B8A82373805AECD6@ORSMSX109.amr.corp.intel.com> <51E640A6.9070902@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51E640A6.9070902-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17/07/2013 09:58, Or Gerlitz wrote:
> On 17/07/2013 07:22, Hefty, Sean wrote:
>> Thanks - I pulled in these patches, but see below:
>
> Hi Sean,
>
> If you do this house cleanup, could you also address the below build 
> warnings. I can see them
> when I build rpm from the 1.0.17 tar ball, but not when doing plain 
> make on the latest git, probably
> b/c the build through the spec uses some more build/warnings flags.
>
>

Hi Sean,

Did you had the chance to look on cleaning these warnings too? I don't 
think its the one Bart was fixing, correct?

Or.

>
> configure: creating ./config.status
> config.status: creating Makefile
> config.status: creating librdmacm.spec
> config.status: creating config.h
> config.status: executing depfiles commands
> config.status: executing libtool commands
> + make -j2
> make  all-am
> make[1]: Entering directory `/usr/src/redhat/BUILD/librdmacm-1.0.17'
>   CC     src_librdmacm_la-cma.lo
>   CC     src_librdmacm_la-addrinfo.lo
> src/addrinfo.c: In function 'ucma_convert_to_rai':
> src/addrinfo.c:193: warning: dereferencing type-punned pointer will 
> break strict-aliasing rules
> src/addrinfo.c:210: warning: dereferencing type-punned pointer will 
> break strict-aliasing rules
>   CC     src_librdmacm_la-acm.lo
>   CC     src_librdmacm_la-rsocket.lo
> src/rsocket.c: In function 'rs_modify_svcs':
> src/rsocket.c:403: warning: ignoring return value of 'write', declared 
> with attribute warn_unused_result
> src/rsocket.c:404: warning: ignoring return value of 'read', declared 
> with attribute warn_unused_result
> src/rsocket.c: In function 'rs_configure':
> src/rsocket.c:460: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:465: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:473: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:478: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:483: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:491: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c:498: warning: ignoring return value of 'fscanf', 
> declared with attribute warn_unused_result
> src/rsocket.c: In function 'rs_svc_process_sock':
> src/rsocket.c:3623: warning: ignoring return value of 'read', declared 
> with attribute warn_unused_result
> src/rsocket.c:3632: warning: ignoring return value of 'write', 
> declared with attribute warn_unused_result
> src/rsocket.c: In function 'rs_svc_run':
> src/rsocket.c:3805: warning: ignoring return value of 'write', 
> declared with attribute warn_unused_result
> src/rsocket.c: In function 'ds_get_dest':
> src/rsocket.c:1451: warning: 'qp' may be used uninitialized in this 
> function
> src/rsocket.c: In function 'rs_send_iomaps':
> src/rsocket.c:2305: warning: 'ret' may be used uninitialized in this 
> function
>   CC     src_librdmacm_la-indexer.lo
>   CC     src_librspreload_la-preload.lo
> src/preload.c: In function 'dup2':
> src/preload.c:1020: warning: value computed is not used
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
>   CC     rcopy.o
>   CC     riostream.o
>   CC     udpong.o
>   CCLD   src/librdmacm.la
>   CCLD   src/librspreload.la
>   CCLD   examples/ucmatose
>   CCLD   examples/rping
>   CCLD   examples/udaddy
>   CCLD   examples/mckey
>   CCLD   examples/rdma_client
>   CCLD   examples/rdma_server
>   CCLD   examples/rdma_xclient
>   CCLD   examples/rdma_xserver
>   CCLD   examples/rstream
>   CCLD   examples/rcopy
>   CCLD   examples/riostream
>   CCLD   examples/udpong
> make[1]: Leaving directory `/usr/src/redhat/BUILD/librdmacm-1.0.17'
> + exit 0
> Executing(%install): /bin/sh -e /var/tmp/rpm-tmp.10929
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
