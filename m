From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: 0-day build issues
Date: Thu, 24 Sep 2015 18:19:21 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1CB9D50F@CRSMSX101.amr.corp.intel.com>
References: <32E1700B9017364D9B60AED9960492BC257D3D76@fmsmsx120.amr.corp.intel.com>
 <42EC4987-428D-4988-BDDD-6B80915AA44C@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>, Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
> >
> > What is being done in the parent directory has a bug, you're right
> > that far, but this is the wrong fix. If you check the 0day failures,
> > it isn't because the InfiniBand core isn't enabled, it's because the
> > current menuconfig setup allows the IB core to be a module and the
> > staging drivers to be compiled into the kernel. That obviously is an
> > invalid condition and it applies to all of the drivers in staging right now. The
> correct fix is to resolve that issue.
> 
> That is our conclusion as well.
> 
> But how do we do that globally in staging/rdma?
> 
> The module setting of INFINIBAND does not seem to carry to the subdirs while
> the following does work.
> 
> It seems like this is the easiest fix since this is a temp home for these drivers.

Ok looks like this will fix it...  Still testing.

14:18:37 > git di
diff --git a/drivers/staging/rdma/Kconfig b/drivers/staging/rdma/Kconfig
index d7f62359d743..46ddc03c6839 100644
--- a/drivers/staging/rdma/Kconfig
+++ b/drivers/staging/rdma/Kconfig
@@ -1,10 +1,11 @@
 menuconfig STAGING_RDMA
-        bool "RDMA staging drivers"
+        tristate "RDMA staging drivers"
        depends on INFINIBAND
        depends on PCI || BROKEN
        depends on HAS_IOMEM
        depends on NET
        depends on INET
+       depends on m
         default n
         ---help---
           This option allows you to select a number of RDMA drivers that

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
