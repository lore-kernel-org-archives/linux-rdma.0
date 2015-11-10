From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Tue, 10 Nov 2015 12:03:31 -0500
Message-ID: <4D7C3E4B-1423-4B84-84F5-7544544255A8@oracle.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com> <1447152255-28231-3-git-send-email-sagig@mellanox.com> <20151110113839.GA32523@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151110113839.GA32523-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 10, 2015, at 6:38 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wr=
ote:
>=20
> On Tue, Nov 10, 2015 at 12:44:14PM +0200, Sagi Grimberg wrote:
>> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> @@ -238,7 +238,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xp=
rt,
>> 	read =3D min_t(int, nents << PAGE_SHIFT, rs_length);
>>=20
>> 	frmr->direction =3D DMA_FROM_DEVICE;
>> -	frmr->access_flags =3D (IB_ACCESS_LOCAL_WRITE|IB_ACCESS_REMOTE_WRI=
TE);
>> +	frmr->access_flags =3D xprt->sc_cm_id->device->rdma_read_access_fl=
ags;
>> 	frmr->sg_nents =3D nents;
>=20
> I think you can simply drop the access_flags member and use
> rdma_read_access_flags directly later in the function.

> Oh, and while we're at it.  Can someone explain why we're even
> using rdma_read_chunk_frmr for IB?  It seems to work around the
> fact tat iWarp only allow a single RDMA READ SGE, but it's used
> whenever the device has IB_DEVICE_MEM_MGT_EXTENSIONS, which seems
> wrong.

Christoph: I agree on both points.

Sagi: the overall approach looks fine to me. Will wait for you
to repost with Christoph=E2=80=99s first suggestion addressed.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
