From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH v2 09/23] MAINTAINERS: Add file patterns for infiniband device tree bindings
Date: Sun, 12 Mar 2017 14:16:53 +0100
Message-ID: <1489324627-19126-10-git-send-email-geert@linux-m68k.org>
References: <1489324627-19126-1-git-send-email-geert@linux-m68k.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489324627-19126-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Submitters of device tree binding documentation may forget to CC
the subsystem maintainer if this is missing.

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Please apply this patch directly if you want to be involved in device
tree binding documentation for your subsystem.

v2:
  - New.

Impact on next-20170310:

+Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
+Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
+Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
 Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
 Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
-Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> (commit_signer:2/2=100%)
-Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> (commit_signer:2/2=100%,authored:2/2=100%)
-Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (commit_signer:2/2=100%)
-Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> (commit_signer:1/2=50%)
+linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:INFINIBAND SUBSYSTEM)
 devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa42535181d48e27..c3fbd1af0f49a7e9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6459,6 +6459,7 @@ W:	http://www.openfabrics.org/
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
 S:	Supported
+F:	Documentation/devicetree/bindings/infiniband/
 F:	Documentation/infiniband/
 F:	drivers/infiniband/
 F:	include/uapi/linux/if_infiniband.h
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
