From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 10:32:55 -0400
Message-ID: <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com>
References: <559F8BD1.9080308@dev.mellanox.co.il> <20150713163015.GA23832@obsidianresearch.com> <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org> <55A534D1.6030008@dev.mellanox.co.il> <20150714163506.GC7399@obsidianresearch.com> <55A53F0B.5050009@dev.mellanox.co.il> <20150714170859.GB19814@obsidianresearch.com> <55A6136A.8010204@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A6136A.8010204-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 15, 2015, at 4:01 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> w=
rote:

> On 7/14/2015 8:09 PM, Jason Gunthorpe wrote:
>> On Tue, Jul 14, 2015 at 07:55:39PM +0300, Sagi Grimberg wrote:
>>=20
>>> But, if people think that it's better to have an API that does impl=
icit
>>> posting always without notification, and then silently consume erro=
r or
>>> flush completions. I can try and look at it as well.
>>=20
>> Can we do FMR transparently if we bundle the post? If yes, I'd call
>> that a winner..
>=20
> Doing FMR transparently is not possible as the unmap flow is scheduli=
ng.
> Unlike NFS, iSER unmaps from a soft-IRQ context, SRP unmaps from
> hard-IRQ context.

The context in which RPC/RDMA performs FMR unmap mustn=92t sleep.
RPC/RDMA is in roughly the same situation as the other initiators.


> Changing the context to thread context is not
> acceptable. The best we can do is using FMR_POOLs transparently.
> Other than polluting the API and its semantics I suspect people will
> have other problems with it (leaving the MRs open).

Count me in that group.

I would rather not build a non-deterministic delay into the
unmap interface. Using a pool or having map do an implicit
unmap are both solutions I=92d rather avoid.

In both situations, MRs can be left mapped indefinitely if,
say, the workload pauses.


> I suggest to start with what I proposed. And in a later stage (if we
> still think its needed) we can have a higher level API that hides the
> post, something like:

> rdma_reg_sg(struct ib_qp *qp,
>            struct ib_mr *mr,
>            struct scatterlist *sg,
>            int sg_nents,
>            u64 offset,
>            u64 length,
>            int access_flags)

I still wonder what =93length=94 means in the context of a scatterlist.


> rdma_unreg_mr(struct ib_qp *qp,
>              struct ib_mr *mr)

An implicit caveat to using this is that the ULP would have to
ensure the =93qp=94 parameter is not NULL and that the referenced
QP will not be destroyed during this call.

So these calls have to be serialized with transport connect and
device removal.

The philosophical preference would be that the API should take
care of this itself, but I=92m not smart enough to see how that
can be done.


> Or incorporate that with a pool API, something like:

=46RWR does not need a pool. I=92d rather not burden this API
with what is essentially an FMR workaround that introduces a
non-deterministic exposure of the data in each MR.


> rdma_create_fr_pool(struct ib_qp *qp,
>                    int nmrs,
>                    int mr_size,
>                    int create_flags)
>=20
> rdma_destroy_fr_pool(struct rdma_fr_pool *pool)
>=20
> rdma_fr_reg_sg(struct rdma_fr_pool *pool,
>               struct scatterlist *sg,
>               int sg_nents,
>               u64 offset,
>               u64 length,
>               int access_flags)
>=20
> rdma_fr_unreg_mr(struct rdma_fr_pool *pool,
>                 struct ib_mr *mr)
>=20
>=20
> Note that I expect problems with both approaches, but
> we can look into it...
>=20
> Sagi.

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
