From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 8/8] svcrdma: Remove svc_rdma_fastreg_mr::access_flags field
Date: Mon, 23 Nov 2015 19:53:04 -0500
Message-ID: <92B143FC-0F2C-48E4-9042-189883D76403@oracle.com>
References: <20151123221738.13040.26277.stgit@klimt.1015granger.net> <20151123222118.13040.24258.stgit@klimt.1015granger.net> <5653B4CA.5050806@talpey.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5653B4CA.5050806-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 23, 2015, at 7:52 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> On 11/23/2015 5:21 PM, Chuck Lever wrote:
>> Clean up: The access_flags field is not used outside of
>> rdma_read_chunk_frmr() and is always set to the same value.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  include/linux/sunrpc/svc_rdma.h         |    1 -
>>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    3 +--
>>  2 files changed, 1 insertion(+), 3 deletions(-)
>>=20
>> diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/=
svc_rdma.h
>> index 243edf4..eee2a0d 100644
>> --- a/include/linux/sunrpc/svc_rdma.h
>> +++ b/include/linux/sunrpc/svc_rdma.h
>> @@ -107,7 +107,6 @@ struct svc_rdma_fastreg_mr {
>>  	struct ib_mr *mr;
>>  	struct scatterlist *sg;
>>  	int sg_nents;
>> -	unsigned long access_flags;
>>  	enum dma_data_direction direction;
>>  	struct list_head frmr_list;
>>  };
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xp=
rtrdma/svc_rdma_recvfrom.c
>> index 9480043..8ab1ab5 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> @@ -240,7 +240,6 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xp=
rt,
>>  	read =3D min_t(int, (nents << PAGE_SHIFT) - *page_offset, rs_lengt=
h);
>>=20
>>  	frmr->direction =3D DMA_FROM_DEVICE;
>> -	frmr->access_flags =3D (IB_ACCESS_LOCAL_WRITE|IB_ACCESS_REMOTE_WRI=
TE);
>>  	frmr->sg_nents =3D nents;
>>=20
>>  	for (pno =3D 0; pno < nents; pno++) {
>> @@ -308,7 +307,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xp=
rt,
>>  	reg_wr.wr.num_sge =3D 0;
>>  	reg_wr.mr =3D frmr->mr;
>>  	reg_wr.key =3D frmr->mr->lkey;
>> -	reg_wr.access =3D frmr->access_flags;
>> +	reg_wr.access =3D (IB_ACCESS_LOCAL_WRITE|IB_ACCESS_REMOTE_WRITE);
>=20
> Wait, the REMOTE_WRITE is there to support iWARP, but it isn't
> needed for IB or RoCE. Shouldn't this be updated to peek at those
> new attributes to decide, instead of remaining unconditional?

That=E2=80=99s coming in another patch from Christoph.


>=20
>=20
>>  	reg_wr.wr.next =3D &read_wr.wr;
>>=20
>>  	/* Prepare RDMA_READ */
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>>=20

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
