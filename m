From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 0/2] Expose max_sge_rd correctly
Date: Tue, 27 Oct 2015 11:40:44 +0200
Message-ID: <1445938846-9240-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: Steve Wise <swise@opengridcomputing.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

This addresses a specific mlx4 issue where the max_sge_rd
is actually smaller than max_sge (rdma reads with max_sge
entries completes with error).

The second patch removes the explicit work-around from the
iser target code.

This applies on top of Christoph's device attributes modification.

Sagi Grimberg (2):
  mlx4: Expose correct max_sge_rd limit
  iser-target: Remove explicit mlx4 work-around

 drivers/infiniband/hw/mlx4/main.c       |    3 ++-
 drivers/infiniband/ulp/isert/ib_isert.c |   10 ++--------
 2 files changed, 4 insertions(+), 9 deletions(-)
