From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Thu, 28 Apr 2016 17:49:20 -0600
Message-ID: <20160428234920.GA2782@obsidianresearch.com>
References: <1460410360-13104-3-git-send-email-hch@lst.de>
 <20160419031425.GB27515@rhel.amr.corp.intel.com>
 <20160419173032.GD20844@obsidianresearch.com>
 <57167D9F.9060808@grimberg.me>
 <20160419192430.GB27028@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB047108@ORSMSX109.amr.corp.intel.com>
 <20160428200759.GA32110@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0471EC@ORSMSX109.amr.corp.intel.com>
 <20160428220945.GA1542@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04724A@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB04724A@ORSMSX109.amr.corp.intel.com>
Sender: target-devel-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, "Weiny, Ira" <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 28, 2016 at 11:23:33PM +0000, Hefty, Sean wrote:
> > This isn't dismissing them as silly, it is a pragmatic need in the
> > core code that everything associated with a PD have a minimum standard
> > of uniformity - and it is very clear that includes things like the
> > iwarp special cases and the particular format of the AHs.
> 
> I was referring to Christoph's comment "that multi-protocol devices
> are indeed as silly as they seem".  Maybe we're using different
> meanings for the term 'device'.  I'm referring to the physical
> hardware.

Oh. I think the rest of this thread uses device to refer to a 'struct
ib_device'.

> > Fundamentally we have the wrong model for such hardware. When a PD is
> > created it should set the 'protocol' and select the compatible member
> > ports that belong to the PD. Cap tests and so forth should be done
> > against the PD, not a port or a device.
> 
> I agree that the model is wrong.  But this is the first email I've
> read (and I skip reading a lot) mentioning the PD.

The last time this came up we talked about the right place to apply
the 'cap' tests and the idea of using the PD or QP was briefly
discussed.

> My concern is that the discussion mentioned removing multi-protocol
> support completely, rather than improving it.

No, the topic is to remove the port num from the cap tests.

This is clarifying the current capability of the core code, which is
that a struct ib_device must have certain uniformity across all ports.

The port_num is totally wrong headed and is not the way to support
some future multi-protocol hardware within a single struct
ib_device.

> I was referring to the sharing of resources (e.g. CQs, MRs) across
> different protocols on the same device.

Hum, can those even realistically be shared? Eg an iWarp and IB MRs
have very different semantics, both in terms of the key and how the
permission model works.

IIRC CQs had some subtle differences too, and of course extracting an
address from a WC is very different.

This is why I bring up the PD as a 'narrower' container for the
required uniformity.

Jason
