From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] verbs: Change the provider library file name suffix
Date: Thu, 10 Aug 2017 14:36:15 -0600
Message-ID: <20170810203615.GB24546@obsidianresearch.com>
References: <20170809215400.GA6921@obsidianresearch.com>
 <20170810064736.GQ1423@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170810064736.GQ1423-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 10, 2017 at 09:47:36AM +0300, Leon Romanovsky wrote:
> What do you think if we update it automatically?

Okay, but this is more robust, I updated the PR

>From 1819eb861a0617ca02c1619b1c7569ec21158f64 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Thu, 10 Aug 2017 11:10:54 -0600
Subject: [PATCH] verbs: Use cmake substitution on libibverbs.map

This lets us have one less copy of the value in
IBVERBS_PABI_VERSION.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/CMakeLists.txt                        | 5 ++++-
 libibverbs/{libibverbs.map => libibverbs.map.in} | 4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)
 rename libibverbs/{libibverbs.map => libibverbs.map.in} (96%)

diff --git a/libibverbs/CMakeLists.txt b/libibverbs/CMakeLists.txt
index 7a52eddc810911..863c395df99d2b 100644
--- a/libibverbs/CMakeLists.txt
+++ b/libibverbs/CMakeLists.txt
@@ -18,7 +18,10 @@ else()
   set(NEIGH "")
 endif()
 
-rdma_library(ibverbs libibverbs.map
+configure_file("libibverbs.map.in"
+  "${CMAKE_CURRENT_BINARY_DIR}/libibverbs.map" @ONLY)
+
+rdma_library(ibverbs "${CMAKE_CURRENT_BINARY_DIR}/libibverbs.map"
   # See Documentation/versioning.md
   1 1.1.${PACKAGE_VERSION}
   cmd.c
diff --git a/libibverbs/libibverbs.map b/libibverbs/libibverbs.map.in
similarity index 96%
rename from libibverbs/libibverbs.map
rename to libibverbs/libibverbs.map.in
index 56020d06a844b2..a1124421bf364d 100644
--- a/libibverbs/libibverbs.map
+++ b/libibverbs/libibverbs.map.in
@@ -85,8 +85,8 @@ IBVERBS_1.1 {
 /* NOTE: The next stanza for public symbols should be IBVERBS_1.4 due to release 12 */
 
 /* If any symbols in this stanza change ABI then the entire staza gets a new symbol
-   version. Also see the private_symver() macro */
-IBVERBS_PRIVATE_15 {
+   version. See the top level CMakeLists.txt for this setting. */
+IBVERBS_PRIVATE_@IBVERBS_PABI_VERSION@ {
 	global:
 		/* These historical symbols are now private to libibverbs */
 		ibv_cmd_alloc_mw;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
