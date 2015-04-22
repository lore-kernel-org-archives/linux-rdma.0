From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Wed, 22 Apr 2015 10:40:34 -0600
Message-ID: <20150422164034.GB19500@obsidianresearch.com>
References: <5534B8C9.506@profitbricks.com>
 <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com>
 <20150422024123.GA18675@phlsvsds.ph.intel.com>
 <DB4PR05MB086335365371E756B789FE84B1EE0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DB4PR05MB086335365371E756B789FE84B1EE0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Liran Liss <liranl@mellanox.com>
Cc: "ira.weiny" <ira.weiny@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 11:38:34AM +0000, Liran Liss wrote:

> This is redundant. All IB ports have SMI, so if you know that you
> are using an IB device, you know you have an SMI.

You should really go back and read the whole thread, this has already
been discussed.

The patch set was developed from the 'bottom up' - all the points that
did 'if is iwarp/rocee/ib/foo' were examined, Michael figured out what
*difference* that code actually required and made a dedicated test for it.

It turns out, one of those differences is SMI, !SMI.

The tests are an inventory of all the spec differences the code cares
about. This is the entire point.

Yes, of course, an abstract notion like <link-type, transport,
node-type> can describe the same state space, but then the call sites
loose the insight into *WHY* the code cares, and *WHAT* the difference
is.

This is bad:
  if (rdma_standard_ib() || rdma_standard_rocee() ||
     rdma_standard_opa())

This is worse:
   if (!rdma_standard_iwarp())

This is better:
  if (rdma_cap_mad())

Going forward, we are growing more tests, and worse, they are for
standards that are not public. We need to stop open-coding 'is
standard' type code and actually start documenting these differences.

Jason
