From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Tue, 19 Apr 2016 13:24:30 -0600
Message-ID: <20160419192430.GB27028@obsidianresearch.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-3-git-send-email-hch@lst.de>
 <20160419031425.GB27515@rhel.amr.corp.intel.com>
 <20160419173032.GD20844@obsidianresearch.com>
 <57167D9F.9060808@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57167D9F.9060808@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>, dledford@redhat.com, bart.vanassche@sandisk.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 19, 2016 at 09:49:03PM +0300, Sagi Grimberg wrote:
> 
> >>>The new RW API will need this.
> >>>
> >>>Signed-off-by: Christoph Hellwig <hch@lst.de>
> >>>Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> >>>Tested-by: Steve Wise <swise@opengridcomputing.com>
> >>
> >>I'm not opposed to this change but traditionally QPs are bound to a
> >>device not to a single port.
> >
> >Right, this was done because rdma_protocol_iwarp takes a port number.
> >
> >I think we discussed this once, the core code doesn't actually support
> >different protocols on different ports, so the port_num argument to
> >rdma_protocol_iwarp is redundant.
> >
> >This all starts to look really goofy when multi-port APM is used and
> >the QP's port number changes dynamically at runtime. (I have some
> >experimental patches that do that), I'd rather see all the port_num
> >stuff in this series go away. :(
> 
> HCH and I complained about this per-port distinction in several private
> conversations. I'd really love to see it go away too.

I'm in support of eliminating them. One protocol per device.

IB APM hard requires those semantics, and that reflects the reality of
all the drivers today.

Nothing more is required than sending a patch, IHMO..

Jason
