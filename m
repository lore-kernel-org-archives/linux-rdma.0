From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: 0-day build issues
Date: Thu, 24 Sep 2015 18:12:09 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1CB9D4D4@CRSMSX101.amr.corp.intel.com>
References: <32E1700B9017364D9B60AED9960492BC257D3D76@fmsmsx120.amr.corp.intel.com>
 <42EC4987-428D-4988-BDDD-6B80915AA44C@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <42EC4987-428D-4988-BDDD-6B80915AA44C-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>, Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> What is being done in the parent directory has a bug, you're right that far, but
> this is the wrong fix. If you check the 0day failures, it isn't because the
> InfiniBand core isn't enabled, it's because the current menuconfig setup allows
> the IB core to be a module and the staging drivers to be compiled into the
> kernel. That obviously is an invalid condition and it applies to all of the drivers
> in staging right now. The correct fix is to resolve that issue.

That is our conclusion as well.

But how do we do that globally in staging/rdma?

The module setting of INFINIBAND does not seem to carry to the subdirs while the following does work.

It seems like this is the easiest fix since this is a temp home for these drivers.

Ira


13:54:05 > git di
diff --git a/drivers/staging/rdma/amso1100/Kconfig b/drivers/staging/rdma/amso1100/Kconfig
index e6ce5f209e47..809cb14ac6de 100644
--- a/drivers/staging/rdma/amso1100/Kconfig
+++ b/drivers/staging/rdma/amso1100/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_AMSO1100
        tristate "Ammasso 1100 HCA support"
-       depends on PCI && INET
+       depends on PCI && INET && INFINIBAND
        ---help---
          This is a low-level driver for the Ammasso 1100 host
          channel adapter (HCA).
diff --git a/drivers/staging/rdma/hfi1/Kconfig b/drivers/staging/rdma/hfi1/Kconfig
index fd25078ee923..97372103e947 100644
--- a/drivers/staging/rdma/hfi1/Kconfig
+++ b/drivers/staging/rdma/hfi1/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_HFI1
        tristate "Intel OPA Gen1 support"
-       depends on X86_64
+       depends on X86_64 && INFINIBAND
        default m
        ---help---
        This is a low-level driver for Intel OPA Gen1 adapter.
diff --git a/drivers/staging/rdma/ipath/Kconfig b/drivers/staging/rdma/ipath/Kconfig
index 041ce0634968..12dcd4010a18 100644
--- a/drivers/staging/rdma/ipath/Kconfig
+++ b/drivers/staging/rdma/ipath/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_IPATH
        tristate "QLogic HTX HCA support"
-       depends on 64BIT && NET && HT_IRQ
+       depends on 64BIT && NET && HT_IRQ && INFINIBAND
        ---help---
        This is a driver for the deprecated QLogic Hyper-Transport
        IB host channel adapter (model QHT7140),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
