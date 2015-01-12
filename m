From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 05/10] svcrdma: Find rmsgp more reliably
Date: Sun, 11 Jan 2015 19:30:01 -0500
Message-ID: <3C09A798-2BA9-46A1-AA60-122C2274974C@oracle.com>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net> <20150109192237.4901.92644.stgit@klimt.1015granger.net> <54B2B4E0.5060901@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B2B4E0.5060901-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi-

Thanks for the review.

On Jan 11, 2015, at 12:37 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> =
wrote:

> On 1/9/2015 9:22 PM, Chuck Lever wrote:
>> xdr_start() can return the wrong rmsgp address if an assumption
>> about how the xdr_buf was constructed changes.  When it gets it
>> wrong, the client receives a reply that has gibberish in the
>> RPC/RDMA header, preventing it from matching a waiting RPC request.
>>=20
>> Instead, make (and document) just one assumption: that the RDMA
>> header for the client's RPC call is at the start of the first page
>> in rq_pages.
>=20
> Would it make more sense to add another pointer assigned at req
> initialization (maybe in the RDMA request context) instead of hard
> coding this assumption? I may be completely wrong here though...

I considered this. I couldn=92t find an appropriate place to add
such a pointer.

I think that=92s why xdr_start() was there in the first place: there
is no convenient place to save a pointer to the request=92s RDMA
header.

Bruce might have other thoughts about this.

>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>=20
>>  net/sunrpc/xprtrdma/svc_rdma_sendto.c |   18 ++++--------------
>>  1 files changed, 4 insertions(+), 14 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprt=
rdma/svc_rdma_sendto.c
>> index 7d79897..7de33d1 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
>> @@ -483,18 +483,6 @@ void svc_rdma_prep_reply_hdr(struct svc_rqst *r=
qstp)
>>  {
>>  }
>>=20
>> -/*
>> - * Return the start of an xdr buffer.
>> - */
>> -static void *xdr_start(struct xdr_buf *xdr)
>> -{
>> -	return xdr->head[0].iov_base -
>> -		(xdr->len -
>> -		 xdr->page_len -
>> -		 xdr->tail[0].iov_len -
>> -		 xdr->head[0].iov_len);
>> -}
>> -
>>  int svc_rdma_sendto(struct svc_rqst *rqstp)
>>  {
>>  	struct svc_xprt *xprt =3D rqstp->rq_xprt;
>> @@ -512,8 +500,10 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
>>=20
>>  	dprintk("svcrdma: sending response for rqstp=3D%p\n", rqstp);
>>=20
>> -	/* Get the RDMA request header. */
>> -	rdma_argp =3D xdr_start(&rqstp->rq_arg);
>> +	/* Get the RDMA request header. The receive logic always
>> +	 * places this at the start of page 0.
>> +	 */
>> +	rdma_argp =3D page_address(rqstp->rq_pages[0]);
>>=20
>>  	/* Build an req vec for the XDR */
>>  	ctxt =3D svc_rdma_get_context(rdma);
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
