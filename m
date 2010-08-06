From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 09/10] enable mlx4_fc, mlx4_fcoib in scsi Kconfig,
	makefile
Date: Fri, 06 Aug 2010 15:51:25 -0700
Message-ID: <4C5C91ED.8090803@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090601020903040908090706"
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
--------------090601020903040908090706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Enable mlx4_fc (fcoe/fcoib offload driver) and mlx4_fcoib (discovery driver)
entries in scsi/Kconfig and Makefile
    
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>


--------------090601020903040908090706
Content-Type: text/x-patch;
 name="mlx4_fc_0009_scsi_Makefile_Kconfig_enable_mlx4_fc_driver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="mlx4_fc_0009_scsi_Makefile_Kconfig_enable_mlx4_fc_driver.pat";
 filename*1="ch"

Enable mlx4_fc (fcoe/fcoib offload driver) and mlx4_fcoib (discovery driver)
entries in scsi/Kconfig and Makefile

Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>

--- a/drivers/scsi/Makefile	2010-06-28 11:16:37.000000000 -0700
+++ a/drivers/scsi/Makefile	2010-05-12 09:31:15.000000000 -0700
@@ -40,6 +40,8 @@
 obj-$(CONFIG_LIBFCOE)		+= fcoe/
 obj-$(CONFIG_FCOE)		+= fcoe/
 obj-$(CONFIG_FCOE_FNIC)		+= fnic/
+obj-$(CONFIG_MLX4_FC)		+= mlx4_fc/
+obj-$(CONFIG_MLX4_FCOIB)	+= mlx4_fc/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
 obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o
 
--- a/drivers/scsi/Kconfig	2010-06-28 11:16:37.000000000 -0700
+++ a/drivers/scsi/Kconfig	2010-05-12 09:36:56.000000000 -0700
@@ -687,6 +687,20 @@
 	  <file:Documentation/scsi/scsi.txt>.
 	  The module will be called fnic.
 
+config MLX4_FC
+	tristate "Mellanox FC module"
+	select LIBFC
+	select LIBFCOE
+	---help---
+	Mellanox Fibre Channel over Ethernet/Infiniband module
+
+config MLX4_FCOIB
+	tristate "Mellanox FCoIB discovery module"
+	depends on INFINIBAND
+	select MLX4_FC
+	---help---
+	Fibre Channel over Infiniband discovery module
+
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
 	depends on PCI && SCSI

--------------090601020903040908090706
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------090601020903040908090706--
