From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration API
Date: Fri, 24 Jul 2015 15:59:06 -0400
Message-ID: <A1A0BF6E-992A-4B34-8D24-EA8AA8D6983B@oracle.com>
References: <20150722170413.GE6443@infradead.org> <55AFD3DC.8070508@dev.mellanox.co.il> <20150722175755.GH26909@obsidianresearch.com> <55B0C18B.4080901@dev.mellanox.co.il> <20150723163124.GD25174@obsidianresearch.com> <55B11D84.102@dev.mellanox.co.il> <20150723185334.GB31346@obsidianresearch.com> <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com> <20150724162657.GA21473@obsidianresearch.com> <903CDFB5-04FE-47B6-B044-E960E8A8BC4C@oracle.com> <20150724191003.GA26225@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724191003.GA26225-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 24, 2015, at 3:10 PM, Jason Gunthorpe <jgunthorpe@obsidianresear=
ch.com> wrote:

> On Fri, Jul 24, 2015 at 01:46:05PM -0400, Chuck Lever wrote:
>>> I'm not surprised since invalidate is sync. I belive you need to
>>> incorporate SEND WITH INVALIDATE to substantially recover this
>>> overhead.
>>=20
>> I tried to find another kernel ULP using SEND WITH INVALIDATE, but
>> I didn=92t see one. I assume you mean the NFS server would use this
>> WR when replying, to knock down the RPC=92s client MRs remotely?
>=20
> Yes. I think the issue with it not being used in the kernel is mainly
> to do with lack of standardization. The verb cannot be used unless
> both sides negotiate it and perhaps the older RDMA protocols have not
> been revised to include that.

And RPC-over-RDMA version 1 does not have any way to signal that
the server has invalidated the MRs. Such signaling would be a
pre-requisite to allow the Linux NFS/RDMA client to interoperate
with non-Linux NFS/RDMA servers that do not have such support.


>> Only the RPC/RDMA header has to be parsed, but yes. The needed
>> parsing is handled in rpcrdma_reply_handler right before the
>> .ro_unmap_unsync call.
>=20
> Right, okay, if this could be done in the rq callback itself rather
> than bounce to a wq and immediately turn around the needed invalidate
> posts you'd get back a little more overhead by reducing the time to
> turn it around... Then bounce to the wq to complete from the SQ
> callback ?

=46or FRWR, you could post LINV from the receive completion upcall
handler, and handle the rest of the invalidation from the send
completion upcall, then poke the RPC reply handler.

But this wouldn=92t work at all for FMR, whose unmap verb is
synchronous, would it?

I=92m not sure we=92d buy more than a few microseconds here, and
the receive upcall is single-threaded.

I=92ll move the =93lost WC=94 discussion to another thread.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
