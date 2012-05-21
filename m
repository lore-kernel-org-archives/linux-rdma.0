From: Vipul Pandya <vipul@chelsio.com>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Mon, 21 May 2012 19:34:52 +0530
Message-ID: <4FBA4B84.9030302@chelsio.com>
References: <20120521120512.15f1e9dfc961b05dfee72f79@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120521120512.15f1e9dfc961b05dfee72f79@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org



On 21-05-2012 07:35, Stephen Rothwell wrote:

> Hi all,
> 
> After merging the infiniband tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/infiniband/hw/cxgb4/device.c: In function 'qp_release':
> drivers/infiniband/hw/cxgb4/device.c:124:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
> drivers/infiniband/hw/cxgb4/device.c: In function 'qp_open':
> drivers/infiniband/hw/cxgb4/device.c:148:2: error: implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
> drivers/infiniband/hw/cxgb4/device.c:148:11: warning: assignment makes pointer from integer without a cast [enabled by default]
> 
> Caused by commit d716a2a014ad ("RDMA/cxgb4: Use vmalloc() for debugfs QP
> dump").  See Rule 1 in Documentation/SubmitChecklist.
> 
> I have used the infiniband tree from next-20120518 for today.
> 


Hi Stephen,

Below patch should resolve this issue.

>From 433d2002d3ba2119146fdec6e0a97b67834df960 Mon Sep 17 00:00:00 2001
From: Vipul Pandya <vipul@chelsio.com>
Date: Mon, 21 May 2012 17:31:13 +0530
Subject: [PATCH] RDMA/cxgb4: Include vmalloc.h for vmalloc and vfree

Signed-off-by: Vipul Pandya <vipul@chelsio.com>
---
 drivers/infiniband/hw/cxgb4/device.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c
b/drivers/infiniband/hw/cxgb4/device.c
index c8fd1d8..cb4ecd7 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/debugfs.h>
+#include <linux/vmalloc.h>

 #include <rdma/ib_verbs.h>

--
