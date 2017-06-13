From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] mlx5: Hexify device IDs
Date: Tue, 13 Jun 2017 20:13:08 +0300
Message-ID: <1497373988-26357-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To make things less eye damaging and align with the mlx4 provided
and both kernel drivers -- lets have the device IDs in hex, as seen
e.g by lspci:

81:00.0 Ethernet controller [0200]: Mellanox Technologies MT27710 Family [ConnectX-4 Lx] [15b3:1015]
82:00.0 Ethernet controller [0200]: Mellanox Technologies MT28800 Family [ConnectX-5 Ex] [15b3:1019]
82:00.2 Ethernet controller [0200]: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function] [15b3:1018]

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Stepped on that while debugging something, for quick ref here's the relevant kernel code:

        { PCI_VDEVICE(MELLANOX, 0x1011) },                      /* Connect-IB */
        { PCI_VDEVICE(MELLANOX, 0x1012), MLX5_PCI_DEV_IS_VF},   /* Connect-IB VF */
        { PCI_VDEVICE(MELLANOX, 0x1013) },                      /* ConnectX-4 */
        { PCI_VDEVICE(MELLANOX, 0x1014), MLX5_PCI_DEV_IS_VF},   /* ConnectX-4 VF */
        { PCI_VDEVICE(MELLANOX, 0x1015) },                      /* ConnectX-4LX */
        { PCI_VDEVICE(MELLANOX, 0x1016), MLX5_PCI_DEV_IS_VF},   /* ConnectX-4LX VF */
        { PCI_VDEVICE(MELLANOX, 0x1017) },                      /* ConnectX-5, PCIe 3.0 */
        { PCI_VDEVICE(MELLANOX, 0x1018), MLX5_PCI_DEV_IS_VF},   /* ConnectX-5 VF */
        { PCI_VDEVICE(MELLANOX, 0x1019) },                      /* ConnectX-5 Ex */
        { PCI_VDEVICE(MELLANOX, 0x101a), MLX5_PCI_DEV_IS_VF},   /* ConnectX-5 Ex VF */
        { PCI_VDEVICE(MELLANOX, 0x101b) },                      /* ConnectX-6 */
        { PCI_VDEVICE(MELLANOX, 0x101c), MLX5_PCI_DEV_IS_VF},   /* ConnectX-6 VF */
        { PCI_VDEVICE(MELLANOX, 0xa2d2) },                      /* BlueField integrated ConnectX-5 network controller */
        { PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},   /* BlueField integrated ConnectX-5 network controller VF */

Also, Doug/Jason, it would be cool if you can set dnf builddep rdma-core on FC to
work, this way ppl can just blindly run it instead of the manual dnf install thing.

 providers/mlx5/mlx5.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 1bbc3f2..ecd5d6a 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -66,20 +66,20 @@ static struct {
 	unsigned		vendor;
 	unsigned		device;
 } hca_table[] = {
-	HCA(MELLANOX, 4113),	/* MT4113 Connect-IB */
-	HCA(MELLANOX, 4114),	/* Connect-IB Virtual Function */
-	HCA(MELLANOX, 4115),	/* ConnectX-4 */
-	HCA(MELLANOX, 4116),	/* ConnectX-4 Virtual Function */
-	HCA(MELLANOX, 4117),	/* ConnectX-4LX */
-	HCA(MELLANOX, 4118),	/* ConnectX-4LX Virtual Function */
-	HCA(MELLANOX, 4119),	/* ConnectX-5, PCIe 3.0 */
-	HCA(MELLANOX, 4120),	/* ConnectX-5 Virtual Function */
-	HCA(MELLANOX, 4121),    /* ConnectX-5 Ex */
-	HCA(MELLANOX, 4122),	/* ConnectX-5 Ex VF */
-	HCA(MELLANOX, 4123),    /* ConnectX-6 */
-	HCA(MELLANOX, 4124),	/* ConnectX-6 VF */
-	HCA(MELLANOX, 41682),	/* BlueField integrated ConnectX-5 network controller */
-	HCA(MELLANOX, 41683),	/* BlueField integrated ConnectX-5 network controller VF */
+	HCA(MELLANOX, 0x1011),	/* MT4113 Connect-IB */
+	HCA(MELLANOX, 0x1012),	/* Connect-IB Virtual Function */
+	HCA(MELLANOX, 0x1013),	/* ConnectX-4 */
+	HCA(MELLANOX, 0x1014),	/* ConnectX-4 Virtual Function */
+	HCA(MELLANOX, 0x1015),	/* ConnectX-4LX */
+	HCA(MELLANOX, 0x1016),	/* ConnectX-4LX Virtual Function */
+	HCA(MELLANOX, 0x1017),	/* ConnectX-5, PCIe 3.0 */
+	HCA(MELLANOX, 0x1018),	/* ConnectX-5 Virtual Function */
+	HCA(MELLANOX, 0x1019),    /* ConnectX-5 Ex */
+	HCA(MELLANOX, 0x101a),	/* ConnectX-5 Ex VF */
+	HCA(MELLANOX, 0x101b),    /* ConnectX-6 */
+	HCA(MELLANOX, 0x101c),	/* ConnectX-6 VF */
+	HCA(MELLANOX, 0xa2d2),	/* BlueField integrated ConnectX-5 network controller */
+	HCA(MELLANOX, 0xa2d3),	/* BlueField integrated ConnectX-5 network controller VF */
 };
 
 uint32_t mlx5_debug_mask = 0;
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
