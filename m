From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Tue, 19 Apr 2016 20:38:30 +0200
Message-ID: <20160419183830.GB1211@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de> <1460410360-13104-3-git-send-email-hch@lst.de> <20160419031425.GB27515@rhel.amr.corp.intel.com> <20160419173032.GD20844@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160419173032.GD20844@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>, dledford@redhat.com, bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 19, 2016 at 11:30:32AM -0600, Jason Gunthorpe wrote:
> Right, this was done because rdma_protocol_iwarp takes a port number.
> 
> I think we discussed this once, the core code doesn't actually support
> different protocols on different ports, so the port_num argument to
> rdma_protocol_iwarp is redundant.
> 
> This all starts to look really goofy when multi-port APM is used and
> the QP's port number changes dynamically at runtime. (I have some
> experimental patches that do that), I'd rather see all the port_num
> stuff in this series go away. :(

Reall, I would _love_ to kill all that port_num crap.  But until
we get agreement from Doug and all the core maintainers that we
can kill it from the core, and that multi-protocol devices are
indeed as silly as they seem I can't..
