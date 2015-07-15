From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 11:01:46 +0300
Message-ID: <55A6136A.8010204@dev.mellanox.co.il>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150713163015.GA23832@obsidianresearch.com>
 <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org>
 <55A534D1.6030008@dev.mellanox.co.il>
 <20150714163506.GC7399@obsidianresearch.com>
 <55A53F0B.5050009@dev.mellanox.co.il>
 <20150714170859.GB19814@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714170859.GB19814-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/14/2015 8:09 PM, Jason Gunthorpe wrote:
> On Tue, Jul 14, 2015 at 07:55:39PM +0300, Sagi Grimberg wrote:
>
>> But, if people think that it's better to have an API that does implicit
>> posting always without notification, and then silently consume error or
>> flush completions. I can try and look at it as well.
>
> Can we do FMR transparently if we bundle the post? If yes, I'd call
> that a winner..

Doing FMR transparently is not possible as the unmap flow is scheduling.
Unlike NFS, iSER unmaps from a soft-IRQ context, SRP unmaps from
hard-IRQ context. Changing the context to thread context is not
acceptable. The best we can do is using FMR_POOLs transparently.
Other than polluting the API and its semantics I suspect people will
have other problems with it (leaving the MRs open).

I suggest to start with what I proposed. And in a later stage (if we
still think its needed) we can have a higher level API that hides the
post, something like:

rdma_reg_sg(struct ib_qp *qp,
             struct ib_mr *mr,
             struct scatterlist *sg,
             int sg_nents,
             u64 offset,
             u64 length,
             int access_flags)

rdma_unreg_mr(struct ib_qp *qp,
               struct ib_mr *mr)


Or incorporate that with a pool API, something like:

rdma_create_fr_pool(struct ib_qp *qp,
                     int nmrs,
                     int mr_size,
                     int create_flags)

rdma_destroy_fr_pool(struct rdma_fr_pool *pool)

rdma_fr_reg_sg(struct rdma_fr_pool *pool,
                struct scatterlist *sg,
                int sg_nents,
                u64 offset,
                u64 length,
                int access_flags)

rdma_fr_unreg_mr(struct rdma_fr_pool *pool,
                  struct ib_mr *mr)


Note that I expect problems with both approaches, but
we can look into it...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
