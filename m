From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 07/10] query the steer capabilities of mlx4 device
Date: Fri, 06 Aug 2010 15:51:10 -0700
Message-ID: <4C5C91DE.1080301@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090600070403010007050307"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------090600070403010007050307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Add API to query the steer capabilities of mlx4 device

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>


--------------090600070403010007050307
Content-Type: text/x-patch;
 name="mlx4_fc_0007_add_query_steer_cap.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mlx4_fc_0007_add_query_steer_cap.patch"

Add API to query the steer capabilities of mlx4 device
    
Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>

diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 4408b96..1777965 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -396,6 +394,14 @@ struct mlx4_init_port_param {
 	u64			si_guid;
 };
 
+static inline void mlx4_query_steer_cap(struct mlx4_dev *dev, int *log_mac,
+					int *log_vlan, int *log_prio)
+{
+	*log_mac = dev->caps.log_num_macs;
+	*log_vlan = dev->caps.log_num_vlans;
+	*log_prio = dev->caps.log_num_prios;
+}
+
 #define mlx4_foreach_port(port, dev, type)				\
 	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	\
 		if (((type) == MLX4_PORT_TYPE_IB ? (dev)->caps.port_mask : \

--------------090600070403010007050307
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------090600070403010007050307--
