From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Thu, 28 Apr 2016 23:23:33 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB04724A@ORSMSX109.amr.corp.intel.com>
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
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160428220945.GA1542@obsidianresearch.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, "Weiny, Ira" <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> This isn't dismissing them as silly, it is a pragmatic need in the
> core code that everything associated with a PD have a minimum standard
> of uniformity - and it is very clear that includes things like the
> iwarp special cases and the particular format of the AHs.

I was referring to Christoph's comment "that multi-protocol devices are indeed as silly as they seem".  Maybe we're using different meanings for the term 'device'.  I'm referring to the physical hardware.

> For instance, even if a hardware device can run rocee and iwarp
> concurrently over a single port, today we absolutely must have
> different struct ib_devices for the same physical port to be able to
> plug that into the core stack.
> 
> Fundamentally we have the wrong model for such hardware. When a PD is
> created it should set the 'protocol' and select the compatible member
> ports that belong to the PD. Cap tests and so forth should be done
> against the PD, not a port or a device.

I agree that the model is wrong.  But this is the first email I've read (and I skip reading a lot) mentioning the PD.  My concern is that the discussion mentioned removing multi-protocol support completely, rather than improving it.

> Fixing that is major surgery, and having cap tests to the port is not
> helping clarify the current situation.
> 
> > Restricting all ports on a device to support all protocols is
> > different than restricting a device to supporting a single protocol,
> > and it affects more than APM.
> 
> What else is there that is cross port in verbs?

I was referring to the sharing of resources (e.g. CQs, MRs) across different protocols on the same device.
