From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Thu, 28 Apr 2016 14:07:59 -0600
Message-ID: <20160428200759.GA32110@obsidianresearch.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-3-git-send-email-hch@lst.de>
 <20160419031425.GB27515@rhel.amr.corp.intel.com>
 <20160419173032.GD20844@obsidianresearch.com>
 <57167D9F.9060808@grimberg.me>
 <20160419192430.GB27028@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB047108@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB047108@ORSMSX109.amr.corp.intel.com>
Sender: target-devel-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, "Weiny, Ira" <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 28, 2016 at 07:43:59PM +0000, Hefty, Sean wrote:
> > > HCH and I complained about this per-port distinction in several private
> > > conversations. I'd really love to see it go away too.
> > 
> > I'm in support of eliminating them. One protocol per device.
> 
> I'm slow reading this thread, but there are devices today
> (e.g. qlogic) that support multiple protocols (e.g. iwarp, roce,
> rocev2).  Even the qib and opa drivers do, if you include psm as a
> separate protocol from ib.

I see several litmus tests for what kinds of ports can be combined
into a device (eg the 'protocol'):

1) Various cap tests are the same on every port. Particularly the
   iWarp special behaviours we are talking about here.
2) AHs are not port-specific, so the AH addressing format must be
   defined by the device. Thus IB and iWarp cannot be combined.
3) Verbs APM must work across ports. So eg rocee and IB cannot be
   combined since they use a different CM process.

Multi-port really only exists to support APM, if APM doesn't work then
drivers don't need to create multi-port devices.

Jason
