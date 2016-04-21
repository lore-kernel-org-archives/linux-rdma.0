From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Wed, 20 Apr 2016 23:11:47 -0400
Message-ID: <20160421031147.GA30731@phlsvsds.ph.intel.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de> <1460410360-13104-3-git-send-email-hch@lst.de> <20160419031425.GB27515@rhel.amr.corp.intel.com> <20160419173032.GD20844@obsidianresearch.com> <57167D9F.9060808@grimberg.me> <20160419192430.GB27028@obsidianresearch.com> <01a901d19a73$82ad7f60$88087e20$@opengridcomputing.com> <20160419200555.GA2561@lst.de> <01e001d19a79$c6349470$529dbd50$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01e001d19a79$c6349470$529dbd50$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Christoph Hellwig' <hch@lst.de>, 'Jason Gunthorpe' <jgunthorpe@obsidianresearch.com>, 'Sagi Grimberg' <sagi@grimberg.me>, dledford@redhat.com, bart.vanassche@sandisk.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 19, 2016 at 03:26:37PM -0500, Steve Wise wrote:
> 
> 
> > -----Original Message-----
> > From: 'Christoph Hellwig' [mailto:hch@lst.de]
> > Sent: Tuesday, April 19, 2016 3:06 PM
> > To: Steve Wise
> > Cc: 'Jason Gunthorpe'; 'Sagi Grimberg'; 'Ira Weiny'; 'Christoph Hellwig';
> > dledford@redhat.com; bart.vanassche@sandisk.com; linux-rdma@vger.kernel.org;
> > target-devel@vger.kernel.org
> > Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
> > 
> > I can offer a trade:  once this series is accepted I'll clean
> > up all the port_num arguments in the protocol checks over the whole
> > tree :)
> 
> I will help as needed.
> 

Agreed.
