From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration API
Date: Tue, 28 Jul 2015 16:06:23 -0400
Message-ID: <B045BAC2-0360-4D97-A220-7DB52AF90BF7@oracle.com>
References: <55AFD3DC.8070508@dev.mellanox.co.il> <20150722175755.GH26909@obsidianresearch.com> <55B0C18B.4080901@dev.mellanox.co.il> <20150723163124.GD25174@obsidianresearch.com> <55B11D84.102@dev.mellanox.co.il> <20150723185334.GB31346@obsidianresearch.com> <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com> <20150724162657.GA21473@obsidianresearch.com> <903CDFB5-04FE-47B6-B044-E960E8A8BC4C@oracle.com> <8A2BC019-1DC0-4531-9659-3181EE9A4B43@oracle.com> <20150727172510.GD18348@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150727172510.GD18348-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 27, 2015, at 1:25 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Mon, Jul 27, 2015 at 11:57:46AM -0400, Chuck Lever wrote:
>> IMO ib_unmap_fmr is a very different animal from LOCAL_INV WR.
> 
> Sure, but how many of these properties does NFS actually care about,
> now that it is running the API properly?
> 
>> ib_unmap_fmr is synchronous, provides no ordering guarantees with
>> send queue operations, and does not depend on a connected QP to
>> be available. You could emulate asynchronicity with a work queue
>> but that still does not provide SQ ordering. There are few if any
>> failure modes for ib_unmap_fmr.
> 
> I'm having a hard time seeing how SQ ordering is important when the
> API is used properly. Once you explicitly order the DMA unmap after
> the invalidate completion you no longer need implicit SQ ordering
> 
> Is there a way to combine SQ implicit ordering and the Linux DMA API
> together correctly?
> 
>> flight, the LINV flushes. MRs can be left in a state where the
>> MR's rkey is not in sync with the HW, in which case a
>> synchronous operation may be required to recover the MR.
> 
> The error handling seems like a trivial difference, a
> ib_recover_failed_qp_mr(mr); sort of call could resync everything
> after a QP blows up..

Out of interest, why does this need to be exposed to ULPs?

I don't feel a ULP should have to deal with broken MRs
following a transport disconnect. It falls in that category
of things every ULP that supports FRWR has to do, and each
has plenty of opportunity to get it wrong.


>> The complexion of MR invalidation could be vastly different in
>> a few years: handled entirely by the target-side, and only
>> verified by the initiator. Verification doesn't need to sleep,
>> and the slow path (the target failed to invalidate) can be
>> deferred.
> 
> The initiator still needs to have the ability to issue the invalidate
> if the target doesn't do it, so all the code still exists..
> 
> Even ignoring those issues, should we be talking about putting FMR
> under the new ib_alloc_mr and ib_map_mr interfaces? Would that help
> much even if the post and unmap flows are totally different?

My opinion is FMR should be separate from the new API. Some have
expressed an interest in combining all kernel registration
mechanisms under a single API, but they seem too different from
each other to do that successfully.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
