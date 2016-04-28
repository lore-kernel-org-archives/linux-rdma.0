From: "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Thu, 28 Apr 2016 23:25:35 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E22EC858F@CRSMSX101.amr.corp.intel.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-3-git-send-email-hch@lst.de>
 <20160419031425.GB27515@rhel.amr.corp.intel.com>
 <20160419173032.GD20844@obsidianresearch.com> <57167D9F.9060808@grimberg.me>
 <20160419192430.GB27028@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB047108@ORSMSX109.amr.corp.intel.com>
 <20160428200759.GA32110@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0471EC@ORSMSX109.amr.corp.intel.com>
 <20160428220945.GA1542@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160428220945.GA1542@obsidianresearch.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Hefty, Sean" <sean.hefty@intel.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Thu, Apr 28, 2016 at 09:53:52PM +0000, Hefty, Sean wrote:
> > > I see several litmus tests for what kinds of ports can be combined
> > > into a device (eg the 'protocol'):
> > >
> > > 1) Various cap tests are the same on every port. Particularly the
> > >    iWarp special behaviours we are talking about here.
> > > 2) AHs are not port-specific, so the AH addressing format must be
> > >    defined by the device. Thus IB and iWarp cannot be combined.
> > > 3) Verbs APM must work across ports. So eg rocee and IB cannot be
> > >    combined since they use a different CM process.
> > >
> > > Multi-port really only exists to support APM, if APM doesn't work
> > > then drivers don't need to create multi-port devices.
> >
> > I don't know the details of the qlogic device, but it is entirely
> > possible that it allows different protocols to share resources (PDs,
> > CQs, IP addresses, etc.).  I think we need to be careful dismissing
> > multi-protocol devices as silly, or restricting which protocols can
> > run over which port.
> 
> This isn't dismissing them as silly, it is a pragmatic need in the core code that
> everything associated with a PD have a minimum standard of uniformity -
> and it is very clear that includes things like the iwarp special cases and the
> particular format of the AHs.
> 
> For instance, even if a hardware device can run rocee and iwarp concurrently
> over a single port, today we absolutely must have different struct ib_devices
> for the same physical port to be able to plug that into the core stack.
> 
> Fundamentally we have the wrong model for such hardware. When a PD is
> created it should set the 'protocol' and select the compatible member ports
> that belong to the PD. Cap tests and so forth should be done against the PD,
> not a port or a device.
> 
> Fixing that is major surgery, and having cap tests to the port is not helping
> clarify the current situation.
> 
> > Restricting all ports on a device to support all protocols is
> > different than restricting a device to supporting a single protocol,
> > and it affects more than APM.
> 
> What else is there that is cross port in verbs?
> 

Well the statement said nothing about verbs.  It said 

<quote>
But until we get agreement from Doug and all the core maintainers that we can kill 
> it from the core, and that multi-protocol devices are indeed as silly 
> as they seem
</quote>

What Sean is again pointing out is that there are devices which support multiple protocols even on the same port.  What you say is true for _verbs_ QPs and _verbs_ PDs but not everything is a QP.

Also part of the history is that when these immutable capability flags were added we recognized that some devices would be supporting Ethernet (RoCE) on 1 port and IB on the other.  I do agree wih you that this is probably better modeled as 2 devices each with a single port.

Mellanox how hard will it be to change your drivers to that model?  I'm not even sure how the detection of Link Layer works any more.  Back in the day it took a config file and was done when the module loaded.  But I thought support for autodetection was in the works.  Is the driver capable of that now?  If so I see a number of issues here with users changing 1 of 2 IB ports from an IB switch to an Ethernet switch and having autodetection have to tear down a single port and create a device with the other.  What happens with APM then?   :-/

But all that is different from the qib/hfi case where we have 1 port with 2 protocols on it.  If we are going to add PSM into the core then I think it is _semantically_ appropriate for users to be able to query for the protocols supported on a port and get back more than 1.

I did not oppose the change Christoph suggested but that was before we started talking about adding in PSM...

Ira
