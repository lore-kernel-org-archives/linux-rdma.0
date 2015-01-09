From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 09/10] Move read list XDR round-up logic
Date: Fri, 9 Jan 2015 15:20:54 -0500
Message-ID: <AAC5FA51-9D2A-4B67-835F-29DC7012471F@oracle.com>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net> <20150109192310.4901.62851.stgit@klimt.1015granger.net> <20150109201434.GA30452@fieldses.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150109201434.GA30452-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jan 9, 2015, at 3:14 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrot=
e:

> On Fri, Jan 09, 2015 at 02:23:11PM -0500, Chuck Lever wrote:
>> Simpler approach, and this needs to be done before the tail is
>> copied to the end of the read list (pre-requisite for a subsequent
>> patch).
>>=20
>> Fixes: e560e3b510d2 ("svcrdma: Add zero padding if the client... ")
>=20
> Wait, does this actually fix a bug in that previous commit is or it
> just cleanup?

No change in behavior.

> If the latter, the "Fixes:.." line is confusing, just mention it in t=
he
> text ("Simpler approach compared to the original attempt in
> e560e3b510d2...=94).

OK.

>=20
> --b.
>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>=20
>> net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   37 ++++++++-------------=
----------
>> 1 files changed, 9 insertions(+), 28 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xp=
rtrdma/svc_rdma_recvfrom.c
>> index 36cf51a..a345cad 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> @@ -43,7 +43,6 @@
>> #include <linux/sunrpc/debug.h>
>> #include <linux/sunrpc/rpc_rdma.h>
>> #include <linux/spinlock.h>
>> -#include <linux/highmem.h>
>> #include <asm/unaligned.h>
>> #include <rdma/ib_verbs.h>
>> #include <rdma/rdma_cm.h>
>> @@ -434,6 +433,15 @@ static int rdma_read_chunks(struct svcxprt_rdma=
 *xprt,
>> 		}
>> 	}
>>=20
>> +	/* Read list may need XDR round-up (see RFC 5666, s. 3.7) */
>> +	if (page_offset & 3) {
>> +		u32 pad =3D 4 - (page_offset & 3);
>> +
>> +		head->arg.page_len +=3D pad;
>> +		head->arg.len +=3D pad;
>> +		head->arg.buflen +=3D pad;
>> +	}
>> +
>> 	ret =3D 1;
>> 	head->position =3D position;
>>=20
>> @@ -446,32 +454,6 @@ static int rdma_read_chunks(struct svcxprt_rdma=
 *xprt,
>> 	return ret;
>> }
>>=20
>> -/*
>> - * To avoid a separate RDMA READ just for a handful of zero bytes,
>> - * RFC 5666 section 3.7 allows the client to omit the XDR zero pad
>> - * in chunk lists.
>> - */
>> -static void
>> -rdma_fix_xdr_pad(struct xdr_buf *buf)
>> -{
>> -	unsigned int page_len =3D buf->page_len;
>> -	unsigned int size =3D (XDR_QUADLEN(page_len) << 2) - page_len;
>> -	unsigned int offset, pg_no;
>> -	char *p;
>> -
>> -	if (size =3D=3D 0)
>> -		return;
>> -
>> -	pg_no =3D page_len >> PAGE_SHIFT;
>> -	offset =3D page_len & ~PAGE_MASK;
>> -	p =3D page_address(buf->pages[pg_no]);
>> -	memset(p + offset, 0, size);
>> -
>> -	buf->page_len +=3D size;
>> -	buf->buflen +=3D size;
>> -	buf->len +=3D size;
>> -}
>> -
>> static int rdma_read_complete(struct svc_rqst *rqstp,
>> 			      struct svc_rdma_op_ctxt *head)
>> {
>> @@ -499,7 +481,6 @@ static int rdma_read_complete(struct svc_rqst *r=
qstp,
>> 	}
>>=20
>> 	/* Point rq_arg.pages past header */
>> -	rdma_fix_xdr_pad(&head->arg);
>> 	rqstp->rq_arg.pages =3D &rqstp->rq_pages[head->hdr_count];
>> 	rqstp->rq_arg.page_len =3D head->arg.page_len;
>> 	rqstp->rq_arg.page_base =3D head->arg.page_base;
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
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
