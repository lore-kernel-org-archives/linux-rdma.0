From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 08/10]  enable vlan support in mlx4 qp path
Date: Fri, 06 Aug 2010 15:51:21 -0700
Message-ID: <4C5C91E9.10002@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080500070000040709060000"
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
--------------080500070000040709060000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

    Enable vlan support in qp path, allow traffic to be encapsulated in 
tagged
    vlan frames.
    
    Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--------------080500070000040709060000
Content-Type: text/x-patch;
 name="mlx4_fc_0008_enable_vlan_support_in_qp_path.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mlx4_fc_0008_enable_vlan_support_in_qp_path.patch"

    Enable vlan support in qp path, allow traffic to be encapsulated in tagged
    vlan frames.
    
    Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 7abe643..1e53d45 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -109,7 +109,7 @@ struct mlx4_qp_path {
 	__be32			tclass_flowlabel;
 	u8			rgid[16];
 	u8			sched_queue;
-	u8			snooper_flags;
+	u8			vlan_index;
 	u8			reserved3[2];
 	u8			counter_index;
 	u8			reserved4[7];

--------------080500070000040709060000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------080500070000040709060000--
