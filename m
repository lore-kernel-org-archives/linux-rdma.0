From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Tue, 19 Apr 2016 14:21:03 -0600
Message-ID: <20160419202103.GA27682@obsidianresearch.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-3-git-send-email-hch@lst.de>
 <20160419031425.GB27515@rhel.amr.corp.intel.com>
 <20160419173032.GD20844@obsidianresearch.com>
 <57167D9F.9060808@grimberg.me>
 <20160419192430.GB27028@obsidianresearch.com>
 <01a901d19a73$82ad7f60$88087e20$@opengridcomputing.com>
 <20160419200555.GA2561@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160419200555.GA2561@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>
Cc: Steve Wise <swise@opengridcomputing.com>, 'Sagi Grimberg' <sagi@grimberg.me>, 'Ira Weiny' <ira.weiny@intel.com>, dledford@redhat.com, bart.vanassche@sandisk.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 19, 2016 at 10:05:55PM +0200, 'Christoph Hellwig' wrote:
> I can offer a trade:  once this series is accepted I'll clean
> up all the port_num arguments in the protocol checks over the whole
> tree :)

Yeah, this series has spun enough, it should land! :)

Jason
