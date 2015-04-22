From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH v5 22/27] IB/Verbs: Use management helper cap_ipoib()
Date: Wed, 22 Apr 2015 16:54:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC6523@ORSMSX109.amr.corp.intel.com>
References: <5534B8C9.506@profitbricks.com>
 <5534BBC2.4010902@profitbricks.com>
 <20150422054058.GB29609@obsidianresearch.com>
 <553760A8.2090802@profitbricks.com>
 <20150422164512.GC1494@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422164512.GC1494@phlsvsds.ph.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Weiny, Ira" <ira.weiny@intel.com>, Michael Wang <yun.wang@profitbricks.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Roland Dreier <roland@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, infinipath <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, "Latif, Faisal" <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

> > > I thought we were dropping this in favor of listing the actual
> > > features the ULP required unconditionally? One of my messages had the
> > > start of a list..
> 
> ???  I forget.  I was arguing that we should not have it.  But I thought
> others
> disagreed with me so it was left in.

I don't remember, but I agree with Jason.  The ULPs should check for the features that they need.
