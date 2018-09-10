From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 1/2] IB/hfi1: Ensure ucast_dlid access doesnt exceed
 bounds
Date: Mon, 10 Sep 2018 07:53:55 -0700
Message-ID: <20180910145349.10122.35039.stgit@scvm10.sc.intel.com>
References: <20180910143437.10122.50679.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180910143437.10122.50679.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The dlid assignment made by looking into the u_ucast_dlid array does not do an
explicit check for the size of the array. The code path to arrive at def_port,
the index value is long and complicated and its best to just have an explicit
check here.

Cc: stable@vger.kernel.org
Fixes: 7d6f728c677e ("IB/opa-vnic: Virtual Network Interface Controller (VNIC) netdev")
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
index 267da82..31cd361 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
@@ -351,7 +351,8 @@ static uint32_t opa_vnic_get_dlid(struct opa_vnic_adapter *adapter,
 			if (unlikely(!dlid))
 				v_warn("Null dlid in MAC address\n");
 		} else if (def_port != OPA_VNIC_INVALID_PORT) {
-			dlid = info->vesw.u_ucast_dlid[def_port];
+			if (def_port < OPA_VESW_MAX_NUM_DEF_PORT)
+				dlid = info->vesw.u_ucast_dlid[def_port];
 		}
 	}
 
