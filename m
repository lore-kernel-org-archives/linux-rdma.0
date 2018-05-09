From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH IB/core 0/2] Do not form IB connections between limited partition members
Date: Wed,  9 May 2018 11:30:18 +0200
Message-ID: <20180509093020.24503-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
List-Id: linux-rdma@vger.kernel.org

Systems using IB partitions might be exposed to excessive pkey
violation traps which are sent to the OpenSM. This can be close to
a DoS attack, and in addition, the OpenSM logs are flooded with these
messages, hiding potential other log messages deemed important in
order to investigate important issues.

This series prohibit RDMA CM to establish connections between two
limited partition members. This avoids pkey violation traps stemming
from unicast messages to be sent to the OpenSM.

[If this patch series get accepted by the community, I ask if
the maintainer can update the reference to the first commit in the
second commit message with a correct 12 chars SHA]

Håkon Bugge (2):
  IB/core: A full pkey is required to match a limited one
  IB/cm: Send authentic pkey in REQ msg and check eligibility of the
    pkeys

 drivers/infiniband/core/cache.c | 32 +++++++++++++++++++++++++++-----
 drivers/infiniband/core/cm.c    | 39 ++++++++++++++++++++++++++++++++-------
 include/rdma/ib_cache.h         | 18 ++++++++++++++++++
 include/rdma/ib_cm.h            |  4 +++-
 4 files changed, 80 insertions(+), 13 deletions(-)

--
2.13.6
