From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Thu, 28 Apr 2016 16:09:45 -0600
Message-ID: <20160428220945.GA1542@obsidianresearch.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-3-git-send-email-hch@lst.de>
 <20160419031425.GB27515@rhel.amr.corp.intel.com>
 <20160419173032.GD20844@obsidianresearch.com>
 <57167D9F.9060808@grimberg.me>
 <20160419192430.GB27028@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB047108@ORSMSX109.amr.corp.intel.com>
 <20160428200759.GA32110@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0471EC@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0471EC@ORSMSX109.amr.corp.intel.com>
Sender: target-devel-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, "Weiny, Ira" <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 28, 2016 at 09:53:52PM +0000, Hefty, Sean wrote:
> > I see several litmus tests for what kinds of ports can be combined
> > into a device (eg the 'protocol'):
> > 
> > 1) Various cap tests are the same on every port. Particularly the
> >    iWarp special behaviours we are talking about here.
> > 2) AHs are not port-specific, so the AH addressing format must be
> >    defined by the device. Thus IB and iWarp cannot be combined.
> > 3) Verbs APM must work across ports. So eg rocee and IB cannot be
> >    combined since they use a different CM process.
> > 
> > Multi-port really only exists to support APM, if APM doesn't work then
> > drivers don't need to create multi-port devices.
> 
> I don't know the details of the qlogic device, but it is entirely
> possible that it allows different protocols to share resources (PDs,
> CQs, IP addresses, etc.).  I think we need to be careful dismissing
> multi-protocol devices as silly, or restricting which protocols can
> run over which port.

This isn't dismissing them as silly, it is a pragmatic need in the
core code that everything associated with a PD have a minimum standard
of uniformity - and it is very clear that includes things like the
iwarp special cases and the particular format of the AHs.

For instance, even if a hardware device can run rocee and iwarp
concurrently over a single port, today we absolutely must have
different struct ib_devices for the same physical port to be able to
plug that into the core stack.

Fundamentally we have the wrong model for such hardware. When a PD is
created it should set the 'protocol' and select the compatible member
ports that belong to the PD. Cap tests and so forth should be done
against the PD, not a port or a device.

Fixing that is major surgery, and having cap tests to the port is not
helping clarify the current situation.

> Restricting all ports on a device to support all protocols is
> different than restricting a device to supporting a single protocol,
> and it affects more than APM.

What else is there that is cross port in verbs?

Jason
