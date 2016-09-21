From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 11/16] Remove the auto* based build systems
Date: Wed, 21 Sep 2016 09:44:21 -0600
Message-ID: <20160921154421.GA1510@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474409425-15769-12-git-send-email-jgunthorpe@obsidianresearch.com>
 <6e3d2ab0-7c86-fe1c-affd-b7fb9ba59c20@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6e3d2ab0-7c86-fe1c-affd-b7fb9ba59c20-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 21, 2016 at 04:53:23PM +0300, Yishai Hadas wrote:
> On 9/21/2016 1:10 AM, Jason Gunthorpe wrote:
> >The unified cmake version provides the same functionality now.
> 
> Can you explain how cmake preservers some compilation options which were
> enabled per vendor ? for example with previous build system someone could
> run configure of libmlx5 with --with-mlx5_debug, how can it be done now ?

On option is to do the usual 'CPPFLAGS="-DMLX5_DEBUG" cmake ..'

However we may as well document these options and provide a command
line switch as follows:

>From f964f6be593b7ef362af3168bd3c6bc8640b976d Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Wed, 21 Sep 2016 09:42:16 -0600
Subject: [PATCH] mlx5: Add cmake options to replace --with-mlx5_debug/mw_debug

Simply enable -D flags when building.

Use as:
  $ cmake -DMLX5_DEBUG=TRUE -DMLX5_MW_DEBUG=TRUE

Reported-by: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx5/CMakeLists.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/providers/mlx5/CMakeLists.txt b/providers/mlx5/CMakeLists.txt
index a34a8063eeb2..44df83b47d96 100644
--- a/providers/mlx5/CMakeLists.txt
+++ b/providers/mlx5/CMakeLists.txt
@@ -1,3 +1,15 @@
+set(MLX5_DEBUG "FALSE" CACHE BOOL
+  "Enable expensive runtime logging options for the mlx5 verbs provider")
+if (MLX5_DEBUG)
+  add_definitions("-DMLX5_DEBUG")
+endif()
+
+set(MLX5_MW_DEBUG "FALSE" CACHE BOOL
+  "Enable extra validation of memory windows for the mlx5 verbs provider")
+if (MLX5_MW_DEBUG)
+  add_definitions("-DMW_DEBUG")
+endif()
+
 rdma_provider(mlx5
   buf.c
   cq.c
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
