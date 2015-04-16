From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH v4 10/27] IB/Verbs: Reform cm related part in IB-core
 cma/ucm
Date: Thu, 16 Apr 2015 16:55:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC2452@ORSMSX109.amr.corp.intel.com>
References: <552F6CF2.4000606@profitbricks.com>
 <552F6DEA.9080701@profitbricks.com>
 <20150416155823.GB21809@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150416155823.GB21809@obsidianresearch.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, infinipath <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, "Latif, Faisal" <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, "Weiny, Ira" <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>
List-Id: linux-rdma@vger.kernel.org

> After the discussion settled, I ended up thinking that implementing
> explicit device checks, for use by CM, and the BUG_ON at register to
> require all ports have the same value was the best option.

Sure, but why not update the other areas anyway?  This way when listens become per port, rather than per device, we only need to update that portion of the code.
