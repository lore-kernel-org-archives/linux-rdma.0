From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/2] IB/mlx4: pass SMP vendor-specific attribute MADs to
 firmware
Date: Thu, 26 Jan 2012 16:41:33 +0200
Message-ID: <alpine.LRH.2.00.1201261640360.31408@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201261624540.30384@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201261624540.30384-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In the current code, such MADs (e.g with the FDR10 attribute) are
silently dropped by the driver, resulting in timeouts at the sending
side and inability to query/configure the relevant feature. However,
the ConnectX firmware is able to handle such mads. For unsupported attributes,
the firmware returns a GET_RESPONSE MAD containing an error status.

Signed-off-by: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

For example, this FDR10 node with LID 11

# ibstat mlx4_0 1

CA: 'mlx4_0'
Port 1:
State: Active
Physical state: LinkUp
Rate: 40 (FDR10)
Base lid: 11
LMC: 0
SM lid: 24
Capability mask: 0x02514868
Port GUID: 0x0002c903002e65d1
Link layer: InfiniBand

Extended Port Query (EPI) vendor mad timeouts before the patch

# smpquery EPI 11 -d

ibwarn: [4196] smp_query_via: attr 0xff90 mod 0x0 route Lid 11
ibwarn: [4196] _do_madrpc: retry 1 (timeout 1000 ms)
ibwarn: [4196] _do_madrpc: retry 2 (timeout 1000 ms)
ibwarn: [4196] _do_madrpc: timeout after 3 retries, 3000 ms
ibwarn: [4196] mad_rpc: _do_madrpc failed; dport (Lid 11)
smpquery: iberror: [pid 4196] main: failed: operation EPI: ext port info query failed

EPI query works okay with the patch

# smpquery EPI 11 -d

ibwarn: [6548] smp_query_via: attr 0xff90 mod 0x0 route Lid 11
ibwarn: [6548] mad_rpc: data offs 64 sz 64
mad data
0000 0000 0000 0001 0000 0001 0000 0001
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
# Ext Port info: Lid 11 port 0
StateChangeEnable:...............0x00
LinkSpeedSupported:..............0x01
LinkSpeedEnabled:................0x01
LinkSpeedActive:.................0x01

 drivers/infiniband/hw/mlx4/mad.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 95c94d8..259b067 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -257,12 +257,9 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			return IB_MAD_RESULT_SUCCESS;

 		/*
-		 * Don't process SMInfo queries or vendor-specific
-		 * MADs -- the SMA can't handle them.
+		 * Don't process SMInfo queries -- the SMA can't handle them.
 		 */
-		if (in_mad->mad_hdr.attr_id == IB_SMP_ATTR_SM_INFO ||
-		    ((in_mad->mad_hdr.attr_id & IB_SMP_ATTR_VENDOR_MASK) ==
-		     IB_SMP_ATTR_VENDOR_MASK))
+		if (in_mad->mad_hdr.attr_id == IB_SMP_ATTR_SM_INFO)
 			return IB_MAD_RESULT_SUCCESS;
 	} else if (in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_PERF_MGMT ||
 		   in_mad->mad_hdr.mgmt_class == MLX4_IB_VENDOR_CLASS1   ||
-- 
1.6.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
