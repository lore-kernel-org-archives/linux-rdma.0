From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Thu, 28 Apr 2016 21:53:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0471EC@ORSMSX109.amr.corp.intel.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-3-git-send-email-hch@lst.de>
 <20160419031425.GB27515@rhel.amr.corp.intel.com>
 <20160419173032.GD20844@obsidianresearch.com> <57167D9F.9060808@grimberg.me>
 <20160419192430.GB27028@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB047108@ORSMSX109.amr.corp.intel.com>
 <20160428200759.GA32110@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160428200759.GA32110@obsidianresearch.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, "Weiny, Ira" <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> I see several litmus tests for what kinds of ports can be combined
> into a device (eg the 'protocol'):
> 
> 1) Various cap tests are the same on every port. Particularly the
>    iWarp special behaviours we are talking about here.
> 2) AHs are not port-specific, so the AH addressing format must be
>    defined by the device. Thus IB and iWarp cannot be combined.
> 3) Verbs APM must work across ports. So eg rocee and IB cannot be
>    combined since they use a different CM process.
> 
> Multi-port really only exists to support APM, if APM doesn't work then
> drivers don't need to create multi-port devices.

I don't know the details of the qlogic device, but it is entirely possible that it allows different protocols to share resources (PDs, CQs, IP addresses, etc.).  I think we need to be careful dismissing multi-protocol devices as silly, or restricting which protocols can run over which port.  Restricting all ports on a device to support all protocols is different than restricting a device to supporting a single protocol, and it affects more than APM.

- Sean
