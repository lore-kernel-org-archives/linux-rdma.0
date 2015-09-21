From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 15/18] svcrdma: Add svc_rdma_get_context() API that is allowed to fail
Date: Mon, 21 Sep 2015 15:34:07 -0700
Message-ID: <958B9B71-C068-4ED2-8928-E93BCC537102@oracle.com>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net> <20150917204614.19671.61606.stgit@manet.1015granger.net> <55FEA951.8000106@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55FEA951.8000106-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Sep 20, 2015, at 5:40 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
>=20
> On 9/17/2015 11:46 PM, Chuck Lever wrote:
>> To support backward direction calls, I'm going to add an
>> svc_rdma_get_context() call in the client RDMA transport.
>>=20
>> Called from ->buf_alloc(), we can't sleep waiting for memory.
>> So add an API that can get a server op_ctxt but won't sleep.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  include/linux/sunrpc/svc_rdma.h          |    2 ++
>>  net/sunrpc/xprtrdma/svc_rdma_transport.c |   28 +++++++++++++++++++=
++++-----
>>  2 files changed, 25 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/=
svc_rdma.h
>> index 6ce7495..2500dd1 100644
>> --- a/include/linux/sunrpc/svc_rdma.h
>> +++ b/include/linux/sunrpc/svc_rdma.h
>> @@ -224,6 +224,8 @@ extern void svc_rdma_send_error(struct svcxprt_r=
dma *, struct rpcrdma_msg *,
>>  extern int svc_rdma_post_recv(struct svcxprt_rdma *);
>>  extern int svc_rdma_create_listen(struct svc_serv *, int, struct so=
ckaddr *);
>>  extern struct svc_rdma_op_ctxt *svc_rdma_get_context(struct svcxprt=
_rdma *);
>> +extern struct svc_rdma_op_ctxt *svc_rdma_get_context_gfp(struct svc=
xprt_rdma *,
>> +							 gfp_t);
>>  extern void svc_rdma_put_context(struct svc_rdma_op_ctxt *, int);
>>  extern void svc_rdma_unmap_dma(struct svc_rdma_op_ctxt *ctxt);
>>  extern struct svc_rdma_req_map *svc_rdma_get_req_map(void);
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/x=
prtrdma/svc_rdma_transport.c
>> index 23aba30..c4083a3 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> @@ -153,17 +153,35 @@ static void svc_rdma_bc_free(struct svc_xprt *=
xprt)
>>  }
>>  #endif	/* CONFIG_SUNRPC_BACKCHANNEL */
>>=20
>> -struct svc_rdma_op_ctxt *svc_rdma_get_context(struct svcxprt_rdma *=
xprt)
>> +static void svc_rdma_init_context(struct svcxprt_rdma *xprt,
>> +				  struct svc_rdma_op_ctxt *ctxt)
>>  {
>> -	struct svc_rdma_op_ctxt *ctxt;
>> -
>> -	ctxt =3D kmem_cache_alloc(svc_rdma_ctxt_cachep,
>> -				GFP_KERNEL | __GFP_NOFAIL);
>>  	ctxt->xprt =3D xprt;
>>  	INIT_LIST_HEAD(&ctxt->dto_q);
>>  	ctxt->count =3D 0;
>>  	ctxt->frmr =3D NULL;
>>  	atomic_inc(&xprt->sc_ctxt_used);
>> +}
>> +
>> +struct svc_rdma_op_ctxt *svc_rdma_get_context_gfp(struct svcxprt_rd=
ma *xprt,
>> +						  gfp_t flags)
>> +{
>> +	struct svc_rdma_op_ctxt *ctxt;
>> +
>> +	ctxt =3D kmem_cache_alloc(svc_rdma_ctxt_cachep, flags);
>> +	if (!ctxt)
>> +		return NULL;
>> +	svc_rdma_init_context(xprt, ctxt);
>> +	return ctxt;
>> +}
>> +
>> +struct svc_rdma_op_ctxt *svc_rdma_get_context(struct svcxprt_rdma *=
xprt)
>> +{
>=20
> Why not:
>       return svc_rdma_get_context_gfp(xprt, GFP_KERNEL | __GFP_NOFAIL=
);

The =E2=80=9Cif (!ctxt) return NULL;=E2=80=9D is unneeded if __GFP_NOFA=
IL is
specified.

I=E2=80=99ll wait for additional comments on this one, I could go
either way.


> ?
>=20
>> +	struct svc_rdma_op_ctxt *ctxt;
>> +
>> +	ctxt =3D kmem_cache_alloc(svc_rdma_ctxt_cachep,
>> +				GFP_KERNEL | __GFP_NOFAIL);
>> +	svc_rdma_init_context(xprt, ctxt);
>>  	return ctxt;
>>  }
>>=20
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
