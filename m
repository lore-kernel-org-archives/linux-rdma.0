From: Chuck Lever <chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 09/12] xprtrdma: Prepare rpcrdma_ep_post() for RDMA_NOMSG calls
Date: Fri, 10 Jul 2015 16:52:22 -0400
Message-ID: <9967E8B6-C9DE-4EE0-A50C-350B373BFD51@gmail.com>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net> <20150709204305.26247.39173.stgit@manet.1015granger.net> <55A02E73.7000902@Netapp.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A02E73.7000902-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jul 10, 2015, at 4:43 PM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgRhl2p70BpVqQ@public.gmane.org=
m> wrote:
>=20
> Hi Chuck,
>=20
> On 07/09/2015 04:43 PM, Chuck Lever wrote:
>> Only the RPC/RDMA header is sent when making an RDMA_NOMSG call.
>> That header resides in the first element of the iovec array
>> passed to rpcrdma_ep_post().
>>=20
>> Instead of special casing the iovec element with the pad, just
>> sync all the elements in the send iovec. Syncing the zero pad is
>> not strictly necessary, but the pad is rarely if ever used these
>> days, and the extra cost in that case is small.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index cdf5220..9199436 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -1316,22 +1318,15 @@ rpcrdma_ep_post(struct rpcrdma_ia *ia,
>>=20
>> 	send_wr.next =3D NULL;
>> 	send_wr.wr_id =3D RPCRDMA_IGNORE_COMPLETION;
>> -	send_wr.sg_list =3D req->rl_send_iov;
>> +	send_wr.sg_list =3D iov;
>> 	send_wr.num_sge =3D req->rl_niovs;
>> 	send_wr.opcode =3D IB_WR_SEND;
>> -	if (send_wr.num_sge =3D=3D 4)	/* no need to sync any pad (constant=
) */
>> -		ib_dma_sync_single_for_device(ia->ri_device,
>> -					      req->rl_send_iov[3].addr,
>> -					      req->rl_send_iov[3].length,
>> -					      DMA_TO_DEVICE);
>> -	ib_dma_sync_single_for_device(ia->ri_device,
>> -				      req->rl_send_iov[1].addr,
>> -				      req->rl_send_iov[1].length,
>> -				      DMA_TO_DEVICE);
>> -	ib_dma_sync_single_for_device(ia->ri_device,
>> -				      req->rl_send_iov[0].addr,
>> -				      req->rl_send_iov[0].length,
>> -				      DMA_TO_DEVICE);
>> +
>> +	for (i =3D 0; i < send_wr.num_sge; i++)
>> +		ib_dma_sync_single_for_device(device, iov[i].addr,
>> +					      iov[i].length, DMA_TO_DEVICE);
>=20
> Two questions here:
> 1) Is syncing order important?  The original code went 3 - 1 - 0, but=
 now we're going 0 - 1 - 2 - 3.

No, the syncing order isn=E2=80=99t important. What=E2=80=99s important=
 is that
the sge=E2=80=99s be synced _before_ the SEND Work Request is posted so
that the HCA can see the freshly marshaled RPC.


> 2) Is iov[2] the zero pad you mentioned in your commit message?

Yes, it is.

> If not, do you know why it wasn't already syncing?

The pad always contains zeroes. Syncing it is optional, AFAICT.

v2 of this series will have some changes in this area, and the
zero pad will be gone entirely.


> Thanks,
> Anna
>=20
>> +	dprintk("RPC:       %s: posting %d s/g entries\n",
>> +		__func__, send_wr.num_sge);
>>=20
>> 	if (DECR_CQCOUNT(ep) > 0)
>> 		send_wr.send_flags =3D 0;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
