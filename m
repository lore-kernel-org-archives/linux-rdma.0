From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 04/14] xprtrdma: Use ib_device pointer safely
Date: Thu, 7 May 2015 09:39:24 -0400
Message-ID: <E1ADA91B-45DA-46B6-A114-E2600613969A@oracle.com>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net> <20150504175720.3483.80356.stgit@manet.1015granger.net> <554B37CF.2070206@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <554B37CF.2070206-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 7, 2015, at 6:00 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wr=
ote:

> On 5/4/2015 8:57 PM, Chuck Lever wrote:
>> The connect worker can replace ri_id, but prevents ri_id->device
>> from changing during the lifetime of a transport instance.
>>=20
>> Cache a copy of ri_id->device in rpcrdma_ia and in rpcrdma_rep.
>> The cached copy can be used safely in code that does not serialize
>> with the connect worker.
>>=20
>> Other code can use it to save an extra address generation (one
>> pointer dereference instead of two).
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  net/sunrpc/xprtrdma/fmr_ops.c      |    8 +----
>>  net/sunrpc/xprtrdma/frwr_ops.c     |   12 +++----
>>  net/sunrpc/xprtrdma/physical_ops.c |    8 +----
>>  net/sunrpc/xprtrdma/verbs.c        |   61 +++++++++++++++++++------=
-----------
>>  net/sunrpc/xprtrdma/xprt_rdma.h    |    2 +
>>  5 files changed, 43 insertions(+), 48 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr=
_ops.c
>> index 302d4eb..0a96155 100644
>> --- a/net/sunrpc/xprtrdma/fmr_ops.c
>> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
>> @@ -85,7 +85,7 @@ fmr_op_map(struct rpcrdma_xprt *r_xprt, struct rpc=
rdma_mr_seg *seg,
>>  	   int nsegs, bool writing)
>>  {
>>  	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>> -	struct ib_device *device =3D ia->ri_id->device;
>> +	struct ib_device *device =3D ia->ri_device;
>>  	enum dma_data_direction direction =3D rpcrdma_data_dir(writing);
>>  	struct rpcrdma_mr_seg *seg1 =3D seg;
>>  	struct rpcrdma_mw *mw =3D seg1->rl_mw;
>> @@ -137,17 +137,13 @@ fmr_op_unmap(struct rpcrdma_xprt *r_xprt, stru=
ct rpcrdma_mr_seg *seg)
>>  {
>>  	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>>  	struct rpcrdma_mr_seg *seg1 =3D seg;
>> -	struct ib_device *device;
>>  	int rc, nsegs =3D seg->mr_nsegs;
>>  	LIST_HEAD(l);
>>=20
>>  	list_add(&seg1->rl_mw->r.fmr->list, &l);
>>  	rc =3D ib_unmap_fmr(&l);
>> -	read_lock(&ia->ri_qplock);
>> -	device =3D ia->ri_id->device;
>>  	while (seg1->mr_nsegs--)
>> -		rpcrdma_unmap_one(device, seg++);
>> -	read_unlock(&ia->ri_qplock);
>> +		rpcrdma_unmap_one(ia->ri_device, seg++);
>=20
> Umm, I'm wandering if this is guaranteed to be the same device as
> ri_id->device?
>=20
> Imagine you are working on a bond device where each slave belongs to
> a different adapter. When the active port toggles, you will see a
> ADDR_CHANGED event (that the current code does not handle...), what
> you'd want to do is just reconnect and rdma_cm will resolve the new
> address for you (via the backup slave). I suspect that in case this
> flow is concurrent with the reconnects you may end up with a stale
> device handle.

I=92m not sure what you mean by =93stale=94 : freed memory?

I=92m looking at this code in rpcrdma_ep_connect() :

 916                 if (ia->ri_id->device !=3D id->device) {
 917                         printk("RPC:       %s: can't reconnect on =
"
 918                                 "different device!\n", __func__);
 919                         rdma_destroy_id(id);
 920                         rc =3D -ENETUNREACH;
 921                         goto out;
 922                 }

After reconnecting, if the ri_id has changed, the connect fails. Today,
xprtrdma does not support the device changing out from under it.

Note also that our receive completion upcall uses ri_id->device for
DMA map syncing. Would that also be a problem during a bond failover?

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
