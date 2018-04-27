From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH 1/3] opa_vnic: Just use skb_get_hash instead of skb_tx_hash
Date: Fri, 27 Apr 2018 14:06:35 -0400
Message-ID: <20180427180627.4883.51935.stgit@ahduyck-green-test.jf.intel.com>
References: <20180427180142.4883.96259.stgit@ahduyck-green-test.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180427180142.4883.96259.stgit@ahduyck-green-test.jf.intel.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, niranjana.vishwanathapura@intel.com, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org

This patch is meant to clean up how the opa_vnic is obtaining entropy from
Tx packets.

The code as it was written was claiming to get 16 bits of hash, but from
what I can tell it was only ever actually getting 14 bits as it was limited
to 0 - (2^15 - 1). It then was folding the result to get a 8 bit value for
entropy.

Instead of throwing away all that input I am cutting out the middle man and
instead having the code call skb_get_hash directly and then folding the 32
bit value into a 8 bit value using a pair of shifts and XOR operations.

Execution wise this new approach should provide more entropy and be faster
since we are bypassing the reciprocal multiplication to reduce the 32b
value to 16b and instead just using a shift/XOR combination.

In addition we can drop the unneeded adapter value from the call to get the
entropy since the netdev itself isn't even needed.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c   |   21 ++++++++++----------
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |    2 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c  |    2 +-
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
index 4be3aef..267da82 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
@@ -443,17 +443,16 @@ static u8 opa_vnic_get_rc(struct __opa_veswport_info *info,
 }
 
 /* opa_vnic_calc_entropy - calculate the packet entropy */
-u8 opa_vnic_calc_entropy(struct opa_vnic_adapter *adapter, struct sk_buff *skb)
+u8 opa_vnic_calc_entropy(struct sk_buff *skb)
 {
-	u16 hash16;
-
-	/*
-	 * Get flow based 16-bit hash and then XOR the upper and lower bytes
-	 * to get the entropy.
-	 * __skb_tx_hash limits qcount to 16 bits. Hence, get 15-bit hash.
-	 */
-	hash16 = __skb_tx_hash(adapter->netdev, skb, BIT(15));
-	return (u8)((hash16 >> 8) ^ (hash16 & 0xff));
+	u32 hash = skb_get_hash(skb);
+
+	/* store XOR of all bytes in lower 8 bits */
+	hash ^= hash >> 8;
+	hash ^= hash >> 16;
+
+	/* return lower 8 bits as entropy */
+	return (u8)(hash & 0xFF);
 }
 
 /* opa_vnic_get_def_port - get default port based on entropy */
@@ -490,7 +489,7 @@ void opa_vnic_encap_skb(struct opa_vnic_adapter *adapter, struct sk_buff *skb)
 
 	hdr = skb_push(skb, OPA_VNIC_HDR_LEN);
 
-	entropy = opa_vnic_calc_entropy(adapter, skb);
+	entropy = opa_vnic_calc_entropy(skb);
 	def_port = opa_vnic_get_def_port(adapter, entropy);
 	len = opa_vnic_wire_length(skb);
 	dlid = opa_vnic_get_dlid(adapter, skb, def_port);
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h b/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
index afd95f4..43ac61f 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
@@ -299,7 +299,7 @@ struct opa_vnic_adapter *opa_vnic_add_netdev(struct ib_device *ibdev,
 void opa_vnic_rem_netdev(struct opa_vnic_adapter *adapter);
 void opa_vnic_encap_skb(struct opa_vnic_adapter *adapter, struct sk_buff *skb);
 u8 opa_vnic_get_vl(struct opa_vnic_adapter *adapter, struct sk_buff *skb);
-u8 opa_vnic_calc_entropy(struct opa_vnic_adapter *adapter, struct sk_buff *skb);
+u8 opa_vnic_calc_entropy(struct sk_buff *skb);
 void opa_vnic_process_vema_config(struct opa_vnic_adapter *adapter);
 void opa_vnic_release_mac_tbl(struct opa_vnic_adapter *adapter);
 void opa_vnic_query_mac_tbl(struct opa_vnic_adapter *adapter,
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
index ce57e0f..0c8aec6 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
@@ -104,7 +104,7 @@ static u16 opa_vnic_select_queue(struct net_device *netdev, struct sk_buff *skb,
 
 	/* pass entropy and vl as metadata in skb */
 	mdata = skb_push(skb, sizeof(*mdata));
-	mdata->entropy =  opa_vnic_calc_entropy(adapter, skb);
+	mdata->entropy = opa_vnic_calc_entropy(skb);
 	mdata->vl = opa_vnic_get_vl(adapter, skb);
 	rc = adapter->rn_ops->ndo_select_queue(netdev, skb,
 					       accel_priv, fallback);
