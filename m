From: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Remove dependency on X86
Date: Fri, 14 Feb 2014 10:29:49 +1100
Message-ID: <31741.1392334189@ale.ozlabs.ibm.com>
References: <1392317393-26762-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1392317393-26762-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> Remove dependency of mlx5_ib on X86 arch since there is no such dependency.
>
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There's another Kconfig you need to fix as well.  Full patch below.
With this it compiles and loads on powerpc.


From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

IB/mlx5: Remove dependency on X86

Remove dependency of mlx5_ib on X86 arch since there is no such
dependency.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>

diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw/mlx5/Kconfig
index 8e6aebf..10df386 100644
--- a/drivers/infiniband/hw/mlx5/Kconfig
+++ b/drivers/infiniband/hw/mlx5/Kconfig
@@ -1,6 +1,6 @@
 config MLX5_INFINIBAND
 	tristate "Mellanox Connect-IB HCA support"
-	depends on NETDEVICES && ETHERNET && PCI && X86
+	depends on NETDEVICES && ETHERNET && PCI
 	select NET_VENDOR_MELLANOX
 	select MLX5_CORE
 	---help---
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 157fe8d..8ff57e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -4,5 +4,5 @@
 
 config MLX5_CORE
 	tristate
-	depends on PCI && X86
+	depends on PCI
 	default n

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
