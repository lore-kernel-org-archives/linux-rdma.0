From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Proposal for exposing rdma_rw MR factor
Date: Wed, 16 Aug 2017 11:50:42 -0400
Message-ID: <6EAEEE15-819E-4CE2-8C67-997A244919FB@oracle.com>
References: <20170801205334.15781.18761.stgit@klimt.1015granger.net> <20170802072043.GZ13672@mtr-leonro.local> <D8576C0A-6588-49D1-A2F9-AD39FB2E5FCE@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D8576C0A-6588-49D1-A2F9-AD39FB2E5FCE-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Aug 8, 2017, at 2:28 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> 
>> On Aug 2, 2017, at 3:20 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> 
>> On Tue, Aug 01, 2017 at 05:06:51PM -0400, Chuck Lever wrote:
>>> Since I converted NFSD to use the new rdma_rw API, I've been
>>> struggling with how NFSD determines the size of its send CQ, and how
>>> it provisions its send queue limit (ie, when it waits for more send
>>> queue entries to become available).
>>> 
>>> The problem arises because rdma_rw hides the exact number of send
>>> WQEs it has provisioned. It determines this number based on the MR
>>> registration mode (FRWR for iWARP devices, local DMA rkey for
>>> others), but the mode itself is no longer exposed to ULPs.
>>> 
>>> Thus when FRWR is in use, rdma_rw adds more WQEs, but NFSD is no
>>> longer aware of this, does not provision a larger CQ, and does not
>>> raise its send queue accounting limit. That means the extra WQEs are
>>> never really used.
>>> 
>>> At LSF this year, Christoph and Sagi proposed a simple API that
>>> expose information about how many CQ entries are needed so that ULPs
>>> can provision their CQs more accurately.
>> 
>> Indeed clean API. Does it make sense to get rid of sc_max_requests and
>> use this exported value directly?
> 
> I'm going to consider this clean up for a later patch.
> 
> So, how shall I submit this new API for upstream? I propose that
> I submit all three of these via Bruce's tree, with an Acked-by
> from Doug on the "Add rdma_rw_mr_payload()" patch, if Doug
> approves.

Doug?


>>> The first patch here is a pre-requisite for the third. The second
>>> patch adds the new API. The third patch changes NFSD to use the new
>>> API to provision its CQ and send queue accounting accurately.
>>> 
>>> This approach was tested using the (fixed) force_mr core module
>>> parameter.
>> 
>> Good, I liked the word "tested" in the sentence :).
>> 
>>> 
>>> 
>>> ---
>>> 
>>> Chuck Lever (3):
>>>     svcrdma: Limit RQ depth
>>>     rdma core: Add rdma_rw_mr_payload()
>>>     svcrdma: Estimate Send Queue depth properly
>>> 
>>> 
>>> drivers/infiniband/core/rw.c             |   24 ++++++++++++++++++++
>>> include/rdma/rw.h                        |    2 ++
>>> net/sunrpc/xprtrdma/svc_rdma_transport.c |   36 +++++++++++++++++++++---------
>>> 3 files changed, 51 insertions(+), 11 deletions(-)
>>> 
>>> --
>>> Chuck Lever
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> Chuck Lever
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
