From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH V5 2/5] ipath,qib: Expose max_sge_rd correctly
Date: Sun, 05 Jul 2015 12:44:47 -0500
Message-ID: <20150705174446.10042.77074.stgit@build2.ogc.int>
References: <20150705174353.10042.39648.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150705174353.10042.39648.stgit@build2.ogc.int>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: infinipath@intel.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Applications must not assume that max_sge and max_sge_rd are the same,
Hence expose max_sge_rd correctly as well.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
---

 drivers/infiniband/hw/ipath/ipath_verbs.c |    1 +
 drivers/infiniband/hw/qib/qib_verbs.c     |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 48253b8..d958236 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1521,6 +1521,7 @@ static int ipath_query_device(struct ib_device *ibdev, struct ib_device_attr *pr
 	props->max_qp = ib_ipath_max_qps;
 	props->max_qp_wr = ib_ipath_max_qp_wrs;
 	props->max_sge = ib_ipath_max_sges;
+	props->max_sge_rd = ib_ipath_max_sges;
 	props->max_cq = ib_ipath_max_cqs;
 	props->max_ah = ib_ipath_max_ahs;
 	props->max_cqe = ib_ipath_max_cqes;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index a05d1a3..bc723b5 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1574,6 +1574,7 @@ static int qib_query_device(struct ib_device *ibdev, struct ib_device_attr *prop
 	props->max_qp = ib_qib_max_qps;
 	props->max_qp_wr = ib_qib_max_qp_wrs;
 	props->max_sge = ib_qib_max_sges;
+	props->max_sge_rd = ib_qib_max_sges;
 	props->max_cq = ib_qib_max_cqs;
 	props->max_ah = ib_qib_max_ahs;
 	props->max_cqe = ib_qib_max_cqes;
