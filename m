From: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
Subject: [PATCH rds linux-next v4 0/2] WARNING in rds_message_alloc_sgs
Date: Sun, 16 Dec 2018 09:01:07 +0200
Message-ID: <20181216070109.6758-1-shamir.rabinovitch@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, netdev@vger.kernel.org
Cc: shamir.rabinovitch@oracle.com, gerd.rausch@oracle.com, santosh.shilimkar@oracle.com, haakon.bugge@oracle.com, davem@davemloft.net
List-Id: linux-rdma@vger.kernel.org

From: shamir rabinovitch <shamir.rabinovitch@oracle.com>

This patch set fix google syzbot rds bug found in linux-next.
The first patch solve the syzbot issue.
The second patch fix issue mentioned by Leon Romanovsky that
drivers should not call WARN_ON as result from user input.

syzbot bug report can be foud here: https://lkml.org/lkml/2018/10/31/28

v1->v2:
- patch 1: make rds_iov_vector fields name more descriptive (Hakon)
- patch 1: fix potential mem leak in rds_rm_size if krealloc fail
  (Hakon)
v2->v3:
- patch 2: harden rds_sendmsg for invalid number of sgs (Gerd)
v3->v4
- Santosh a.b. on both patches + repost to net-dev

shamir rabinovitch (2):
  net/rds: fix warn in rds_message_alloc_sgs
  net/rds: remove user triggered WARN_ON in rds_sendmsg

 net/rds/message.c | 24 +++++++++++----
 net/rds/rdma.c    | 75 +++++++++++++++++++++++------------------------
 net/rds/rds.h     | 23 +++++++++++----
 net/rds/send.c    | 59 ++++++++++++++++++++++++++++++-------
 4 files changed, 120 insertions(+), 61 deletions(-)

-- 
2.19.1
