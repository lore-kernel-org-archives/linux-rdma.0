From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration API
Date: Fri, 24 Jul 2015 10:36:07 -0400
Message-ID: <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com> <1437548143-24893-39-git-send-email-sagig@mellanox.com> <20150722170413.GE6443@infradead.org> <55AFD3DC.8070508@dev.mellanox.co.il> <20150722175755.GH26909@obsidianresearch.com> <55B0C18B.4080901@dev.mellanox.co.il> <20150723163124.GD25174@obsidianresearch.com> <55B11D84.102@dev.mellanox.co.il> <20150723185334.GB31346@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150723185334.GB31346-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 23, 2015, at 2:53 PM, Jason Gunthorpe <jgunthorpe@obsidianresear=
ch.com> wrote:

> On Thu, Jul 23, 2015 at 07:59:48PM +0300, Sagi Grimberg wrote:
>> I don't mean to be negative about your ideas, I just don't think tha=
t
>> doing all the work in the drivers is going to get us to a better pla=
ce.
>=20
> No worries, I'm hoping someone can put the peices together and figure
> out how to code share all the duplication we seem to have in the ULPs=
=2E
>=20
> The more I've look at them, the more it seems like they get basic
> things wrong, like SQE accouting in NFS, dma flush ordering in NFS,

I have a work-in-progress prototype that addresses both of these issues=
=2E

Unfinished, but operational:

http://git.linux-nfs.org/?p=3Dcel/cel-2.6.git;a=3Dshortlog;h=3Drefs/hea=
ds/nfs-rdma-future

Having this should give us time to analyze the performance impact
of these changes, and to dial in an approach that aligns with your
vision about the unified APIs that you and Sagi have been
discussing.

=46RWR is seeing a 10-15% throughput reduction with 8-thread dbench,
but a 5% improvement with 16-thread fio IOPS. 4K and 8K direct
read and write are negatively impacted.

I don=92t see any significant change in client CPU utilization, but
have not yet examined changes in interrupt workload, nor have I
done any spin lock or CPU bus traffic analysis.

But none of this is as bad as I feared it could be. There are
plenty of other areas that can recoup some or all of this loss
eventually.

I converted the RPC reply handler tasklet to a work queue context
to allow sleeping. A new .ro_unmap_sync method is invoked after
the RPC/RDMA header is parsed but before xprt_complete_rqst()
wakes up the waiting RPC.

=2Ero_unmap_sync is 100% synchronous. It does not return to the
reply handler until the MRs are invalid and unmapped.

=46or FMR, .ro_unmap_sync makes a list of the RPC=92s MRs and passes
that list to a single ib_unmap_fmr() call, then performs DMA
unmap and releases the MRs.

This is actually much more efficient than the current logic,
which serially does an ib_unmap_fmr() for each MR the RPC owns.
So FMR overall performs better with this change.

=46or FRWR, .ro_unmap_sync builds a chain of LOCAL_INV WRs for the
RPC=92s MRs and posts that with a single ib_post_send(). The final
WR in the chain is signaled. A kernel completion is used to wait
for the LINV chain to complete. Then DMA unmap and MR release.

This lengthens per-RPC latency for FRWR, because the LINVs are
now fully accounted for in the RPC round-trip rather than being
done asynchronously after the RPC completes. So here performance
is closer to FMR, but is still better by a substantial margin.

Because the next RPC cannot awaken until the last send completes,
send queue accounting is based on RPC/RDMA credit flow control.
I=92m sure there are some details here that still need to be
addressed, but this fixes the big problem with FRWR send queue
accounting, which was that LOCAL_INV WRs would continue to
consume SQEs while another RPC was allowed to start.

I think switching to use s/g lists will be straightforward and
could simplify the overall approach somewhat.


> rkey security in SRP/iSER..
>=20
> Sharing code means we can fix those problems for good.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
