From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 3/8] svcrdma: Add svc_rdma_get_context() API that is allowed to fail
Date: Tue, 24 Nov 2015 09:24:51 -0500
Message-ID: <7717B6B1-4A27-4D8A-8BCC-528CEC6DB54D@oracle.com>
References: <20151123221738.13040.26277.stgit@klimt.1015granger.net> <20151123222038.13040.61285.stgit@klimt.1015granger.net> <20151124065522.GC29141@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124065522.GC29141-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 24, 2015, at 1:55 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wr=
ote:
>=20
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
>> +	struct svc_rdma_op_ctxt *ctxt;
>> +
>> +	ctxt =3D kmem_cache_alloc(svc_rdma_ctxt_cachep,
>> +				GFP_KERNEL | __GFP_NOFAIL);
>> +	svc_rdma_init_context(xprt, ctxt);
>> 	return ctxt;
>=20
> Sounds like you should have just added a gfp_t argument to
> svc_rdma_get_context.

There is only one (new) call site that needs it. I can simplify
this patch as Sagi suggested before, but it seems silly to
introduce the extra clutter of adding a gfp_t argument
everywhere.


> And if we have any way to avoid the __GFP_NOFAIL
> I'd really appreciate if we could give that a try.

I=E2=80=99m not introducing the flag here.

Changing all the svc_rdma_get_context() call sites to handle
allocation failure (when it is already highly unlikely) is
a lot of needless work, IMO, and not related to supporting
bi-directional RPC.

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
