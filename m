From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 3/8] svcrdma: Add svc_rdma_get_context() API that is allowed to fail
Date: Fri, 4 Dec 2015 10:29:45 -0500
Message-ID: <E41A0933-FDF0-4995-B676-83B648D35F46@oracle.com>
References: <20151123221738.13040.26277.stgit@klimt.1015granger.net> <20151123222038.13040.61285.stgit@klimt.1015granger.net> <20151124065522.GC29141@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124065522.GC29141-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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
> svc_rdma_get_context.  And if we have any way to avoid the __GFP_NOFA=
IL
> I'd really appreciate if we could give that a try.

Changed my mind on this.

struct svc_rdma_op_ctxt used to be smaller than a page, so these
allocations were not likely to fail. But since the maximum NFS
READ and WRITE payload for NFS/RDMA has been increased to 1MB,
struct svc_rdma_op_ctxt has grown to more than 6KB, thus it is
no longer an order 0 memory allocation.

Some ideas:

1. Pre-allocate these per connection in svc_rdma_accept().
There will never be more than sc_sq_depth of these. But that
could be a large number to allocate during connection
establishment.

2. Once allocated, cache them. If traffic doesn=E2=80=99t manage to
allocate sc_sq_depth of these over time, allocation can still
fail during a traffic burst in very low memory scenarios.

3. Use a mempool. This reserves a few of these which may never
be used. But allocation can still fail once the reserve is
consumed (same as 2).

4. Break out the sge and pages arrays into separate allocations
so the allocation requests are order 0.

1 seems like the most robust solution, and it would be fast.
svc_rdma_get_context is a very common operation.


--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
