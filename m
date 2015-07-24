From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH WIP 38/43] iser-target: Port to new memory registration API
Date: Fri, 24 Jul 2015 11:34:36 -0500
Message-ID: <00c501d0c62e$a0df2c00$e29d8400$@opengridcomputing.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com> <1437548143-24893-39-git-send-email-sagig@mellanox.com> <20150722170413.GE6443@infradead.org> <55AFD3DC.8070508@dev.mellanox.co.il> <20150722175755.GH26909@obsidianresearch.com> <55B0C18B.4080901@dev.mellanox.co.il> <20150723163124.GD25174@obsidianresearch.com> <55B11D84.102@dev.mellanox.co.il> <20150723185334.GB31346@obsidianresearch.com> <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com> <20150724162657.GA21473@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724162657.GA21473-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.=
kernel.org] On Behalf Of Jason Gunthorpe
> Sent: Friday, July 24, 2015 11:27 AM
> To: Chuck Lever
> Cc: Sagi Grimberg; Christoph Hellwig; linux-rdma; Liran Liss; Oren Du=
er
> Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory regist=
ration API
>=20
> On Fri, Jul 24, 2015 at 10:36:07AM -0400, Chuck Lever wrote:
>=20
> > Unfinished, but operational:
> >
> > http://git.linux-nfs.org/?p=3Dcel/cel-2.6.git;a=3Dshortlog;h=3Drefs=
/heads/nfs-rdma-future
>=20
> Nice..
>=20
> Can you spend some time and reflect on how some of this could be
> lowered into the core code? The FMR and FRWR side have many
> similarities now..
>=20
> > FRWR is seeing a 10-15% throughput reduction with 8-thread dbench,
> > but a 5% improvement with 16-thread fio IOPS. 4K and 8K direct
> > read and write are negatively impacted.
>=20
> I'm not surprised since invalidate is sync. I belive you need to
> incorporate SEND WITH INVALIDATE to substantially recover this
> overhead.
>=20
> It would be neat if the RQ could continue to advance while waiting fo=
r
> the invalidate.. That looks almost doable..
>=20
> > I converted the RPC reply handler tasklet to a work queue context
> > to allow sleeping. A new .ro_unmap_sync method is invoked after
> > the RPC/RDMA header is parsed but before xprt_complete_rqst()
> > wakes up the waiting RPC.
>=20
> .. so the issue is the RPC must be substantially parsed to learn whic=
h
> MR it is associated with to schedule the invalidate?
>=20
> > This is actually much more efficient than the current logic,
> > which serially does an ib_unmap_fmr() for each MR the RPC owns.
> > So FMR overall performs better with this change.
>=20
> Interesting..
>=20
> > Because the next RPC cannot awaken until the last send completes,
> > send queue accounting is based on RPC/RDMA credit flow control.
>=20
> So for FRWR the sync invalidate effectively guarentees all SQEs
> related to this RPC are flushed. That seems reasonable, if the number
> of SQEs and CQEs are properly sized in relation to the RPC slot count
> it should be workable..
>=20
> How does FMR and PHYS synchronize?
>=20
> > I=E2=80=99m sure there are some details here that still need to be
> > addressed, but this fixes the big problem with FRWR send queue
> > accounting, which was that LOCAL_INV WRs would continue to
> > consume SQEs while another RPC was allowed to start.
>=20
> Did you test without that artificial limit you mentioned before?
>=20
> I'm also wondering about this:
>=20
> > During some other testing I found that when a completion upcall
> > returns to the provider leaving CQEs still on the completion queue,
> > there is a non-zero probability that a completion will be lost.
>=20
> What does lost mean?
>=20
> The CQ is edge triggered, so if you don't drain it you might not get
> another timely CQ callback (which is bad), but CQEs themselves should
> not be lost.
>=20

This condition (not fully draining the CQEs) is due to SQ flow control,=
 yes?  If so, then when the SQ resumes can it wake up the appropriate t=
hread (simulating another CQE insertion)?




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
