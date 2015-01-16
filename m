From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/20] NFS/RDMA client for 3.20
Date: Fri, 16 Jan 2015 16:04:01 -0500
Message-ID: <59D943E3-C7F8-48C4-BDB6-8309E74D4EDB@oracle.com>
References: <20150113161440.14086.24801.stgit@manet.1015granger.net> <54B97C73.9000602@Netapp.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B97C73.9000602-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jan 16, 2015, at 4:02 PM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>=
 wrote:

> Hi Chuck,
>=20
> You already answered my one question for this patch series, and I don=
't have any other comments.  Are these ready for me to take now?  Are y=
ou planning a v3?

Yes, one or two minor changes. I=92ll post late next week (after MLK da=
y).

>=20
> Thanks,
> Anna
>=20
> On 01/13/2015 11:24 AM, Chuck Lever wrote:
>> The following series of patches for the Linux NFS client breaks up
>> the per-transport buffer pool data structures to help them scale
>> better with the size of SEND/RECV buffers (the inline threshold),
>> the maximum NFS r/wsize, and the number of RDMA credits (concurrent
>> RPC requests).
>>=20
>> The primary change is that the header send buffers have been split
>> from struct rpcrdma_req. Specific benefits are outlined in the patch
>> descriptions.
>>=20
>> More pre-requisites are required. Changes to raise the maximum
>> r/wsize and other limits are left for a future merge window.
>>=20
>> See the topic branch "nfs-rdma-for-3.20" at:
>>=20
>>  git://git.linux-nfs.org/projects/cel/cel-2.6.git
>>=20
>> Changes since v1:
>> - Rebased on v3.19-rc4
>> - One short description fixed
>> - linux-rdma included this time (sorry for the noise)
>>=20
>> ---
>>=20
>> Chuck Lever (20):
>>      xprtrdma: human-readable completion status
>>      xprtrdma: Modernize htonl and ntohl
>>      xprtrdma: Display XIDs in host byte order
>>      xprtrdma: Clean up hdrlen
>>      xprtrdma: Rename "xprt" and "rdma_connect" fields in struct rpc=
rdma_xprt
>>      xprtrdma: Remove rpcrdma_ep::rep_ia
>>      xprtrdma: Remove rl_mr field, and the mr_chunk union
>>      xprtrdma: Move credit update to RPC reply handler
>>      xprtrdma: Remove rpcrdma_ep::rep_func and ::rep_xprt
>>      xprtrdma: Free the pd if ib_query_qp() fails
>>      xprtrdma: Take struct ib_device_attr off the stack
>>      xprtrdma: Take struct ib_qp_attr and ib_qp_init_attr off the st=
ack
>>      xprtrdma: Simplify synopsis of rpcrdma_buffer_create()
>>      xprtrdma: Refactor rpcrdma_buffer_create() and rpcrdma_buffer_d=
estroy()
>>      xprtrdma: Add struct rpcrdma_regbuf and helpers
>>      xprtrdma: Allocate RPC send buffer separately from struct rpcrd=
ma_req
>>      xprtrdma: Allocate RPC/RDMA send buffer separately from struct =
rpcrdma_req
>>      xprtrdma: Allocate RPC/RDMA receive buffer separately from stru=
ct rpcrdma_rep
>>      xprtrdma: Allocate zero pad separately from rpcrdma_buffer
>>      xprtrdma: Clean up after adding regbuf management
>>=20
>>=20
>> include/linux/sunrpc/rpc_rdma.h |   14 +
>> include/linux/sunrpc/svc_rdma.h |    2=20
>> net/sunrpc/xprtrdma/rpc_rdma.c  |  108 ++++++----
>> net/sunrpc/xprtrdma/transport.c |  179 +++++++----------
>> net/sunrpc/xprtrdma/verbs.c     |  411 ++++++++++++++++++++++++-----=
----------
>> net/sunrpc/xprtrdma/xprt_rdma.h |  111 +++++++----
>> 6 files changed, 478 insertions(+), 347 deletions(-)
>>=20
>> --
>> Chuck Lever
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
