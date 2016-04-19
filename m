From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Tue, 19 Apr 2016 11:30:32 -0600
Message-ID: <20160419173032.GD20844@obsidianresearch.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-3-git-send-email-hch@lst.de>
 <20160419031425.GB27515@rhel.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160419031425.GB27515@rhel.amr.corp.intel.com>
Sender: target-devel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, dledford@redhat.com, bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 18, 2016 at 11:14:27PM -0400, Ira Weiny wrote:
> On Mon, Apr 11, 2016 at 02:32:30PM -0700, Christoph Hellwig wrote:
> > The new RW API will need this.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> > Tested-by: Steve Wise <swise@opengridcomputing.com>
> 
> I'm not opposed to this change but traditionally QPs are bound to a
> device not to a single port.

Right, this was done because rdma_protocol_iwarp takes a port number.

I think we discussed this once, the core code doesn't actually support
different protocols on different ports, so the port_num argument to
rdma_protocol_iwarp is redundant.

This all starts to look really goofy when multi-port APM is used and
the QP's port number changes dynamically at runtime. (I have some
experimental patches that do that), I'd rather see all the port_num
stuff in this series go away. :(

Jason
