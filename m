From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Wed, 22 Apr 2015 10:57:24 -0600
Message-ID: <20150422165724.GC19500@obsidianresearch.com>
References: <5534B8C9.506@profitbricks.com>
 <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com>
 <1429714792.45956.110.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429714792.45956.110.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Liran Liss <liranl@mellanox.com>, Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 10:59:52AM -0400, Doug Ledford wrote:

> > 2)The name rdma_tech_* is lame.
> > rdma_transport_*(), adhering to the above (*) remark, is much better.
> > For example, both IB and ROCE *do* use the same transport. 
> 
> I especially want to second this.  I haven't really been happy with the
> rdma_tech_* names at all.

I'm not excited about the names either..

cap_ is bad because it pollutes the global namespace.

rdma_tech_ .. as used, this is selecting the standard the port
implements. The word 'standard' is a better choice than 'transport',
and 'technology' is often synonymous with 'standard'. Meh.

I've said it already, but this patch set has probably gotten too
big. If we could just do the cap conversion without messing with other
stuff, or adding rdma_tech, that would really be the best.

Nobody seems to like the rdma_tech parts of this series.

I'd also drop '[PATCH v5 09/27] IB/Verbs: Reform IB-core
verbs/uverbs_cmd/sysfs' - that is UAPI stuff, it could be done as a
followup someday, not worth the risk right now.

Jason
