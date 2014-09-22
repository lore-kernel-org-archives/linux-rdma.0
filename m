From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] svcrdma: Advertise the correct max payload
Date: Mon, 22 Sep 2014 11:47:15 -0700
Message-ID: <5D045AB5-71D5-4ACB-9394-FE27A9F37DA7@oracle.com>
References: <20140922183653.19376.14276.stgit@build.ogc.int> <20140922183922.GB26763@fieldses.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140922183922.GB26763-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Sep 22, 2014, at 11:39 AM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wr=
ote:

> On Mon, Sep 22, 2014 at 01:36:53PM -0500, Steve Wise wrote:
>> Svcrdma currently advertises 1MB, which is too large.  The correct v=
alue
>> is the max scatter-gather allowed in an NFSRDMA IO chunk * the host =
page
>> size. This bug is usually benign because the Linux X64 NFSRDMA clien=
t
>> correctly limits the payload size to the correct value (64*4096 =3D =
256KB).
>> But if the Linux client is PPC64 with a 64KB page size, then the cli=
ent
>> will indeed use a payload size that will overflow the server.
>>=20
>> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> ---
>>=20
>> net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
>> net/sunrpc/xprtrdma/xprt_rdma.h          |    2 ++
>> 2 files changed, 3 insertions(+), 1 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/x=
prtrdma/svc_rdma_transport.c
>> index 374feb4..4e61880 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> @@ -91,7 +91,7 @@ struct svc_xprt_class svc_rdma_class =3D {
>> 	.xcl_name =3D "rdma",
>> 	.xcl_owner =3D THIS_MODULE,
>> 	.xcl_ops =3D &svc_rdma_ops,
>> -	.xcl_max_payload =3D RPCSVC_MAXPAYLOAD_TCP,
>> +	.xcl_max_payload =3D RPCSVC_MAXPAYLOAD_RDMA,
>> 	.xcl_ident =3D XPRT_TRANSPORT_RDMA,
>> };
>>=20
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/x=
prt_rdma.h
>> index c419498..467a77c 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -392,4 +392,6 @@ extern struct kmem_cache *svc_rdma_ctxt_cachep;
>> /* Workqueue created in svc_rdma.c */
>> extern struct workqueue_struct *svc_rdma_wq;
>>=20
>> +#define RPCSVC_MAXPAYLOAD_RDMA	(RPCRDMA_MAX_DATA_SEGS << PAGE_SHIFT=
)
>=20
> Do you want to define this as the minimum of this and
> RPCSVC_MAXPAYLOAD_TCP, in case RPCRDMA_MAX_DATA_SEGS gets increased s=
ome
> day?

Hey Bruce-

I don=92t see the _TCP and _RDMA settings are related.

> --b.
>=20
>> +
>> #endif				/* _LINUX_SUNRPC_XPRT_RDMA_H */
>>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
