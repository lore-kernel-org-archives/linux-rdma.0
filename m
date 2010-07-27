From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: rds-tools issue starting with OFED-1.5.2-20100718-0600.tgz
Date: Tue, 27 Jul 2010 14:58:47 -0600
Message-ID: <1280264327.4816.18.camel@sale659.sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

It looks like starting on July 18, the daily snapshot for OFED-1.5.2
changed what version of rds-tools it was based on:

diff -urN OFED-1.5.2-20100717-0600/BUILD_ID OFED-1.5.2-20100718-0600/BUILD_ID
--- OFED-1.5.2-20100717-0600/BUILD_ID   2010-07-17 07:13:29.000000000 -0600
+++ OFED-1.5.2-20100718-0600/BUILD_ID   2010-07-18 07:13:29.000000000 -0600
@@ -1,4 +1,4 @@
-OFED-1.5.2-20100717-0600:
+OFED-1.5.2-20100718-0600:
 
 compat-dapl:
 http://www.openfabrics.org/downloads/dapl/compat-dapl-1.2.18.tar.gz
@@ -77,7 +77,7 @@
 
 ofa_kernel:
 git://git.openfabrics.org/ofed_1_5/linux-2.6.git ofed_kernel_1_5
-commit 0c842405cd3d204b23125836a8749fe7cd40b566
+commit 6bcc8f2eb4f005f430ee8f1d6962ba6778d6bbd8
 
 ofed-docs:
 git://git.openfabrics.org/~tziporet/docs.git ofed_1_5
@@ -105,7 +105,7 @@
 http://www.openfabrics.org/downloads/qperf/qperf-0.4.6-0.1.gb81434e.tar.gz
 
 rds-tools:
-http://www.openfabrics.org/~vlad/ofed_1_5/rds-tools/rds-tools-1.5-1.src.rpm
+http://www.openfabrics.org/downloads/rds-tools/rds-tools-2.0.3.tar.gz
 


It also looks like, from 
  http://oss.oracle.com/git/?p=agrover/rds-tools.git;a=summary

that rds-tools now builds into two RPMs, rds-tools and rds-devel,
but the OFED build scripts don't seem to know about that change.

I'd like to learn how to write apps that use RDS, so I thought
I needed rds.h to compile against, in hopes of running against the
latest upstream kernel RDS.  But, I can't seem to get it from
the 1.5.2 daily snapshot, as a rds-devel rpm isn't getting installed.

Is there somewhere else to get the appropriate rds.h from?

Thanks -- Jim



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
