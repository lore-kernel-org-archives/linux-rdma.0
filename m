From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Wed, 23 Aug 2017 10:08:16 -0600
Message-ID: <20170823160816.GA11188@obsidianresearch.com>
References: <1502976998-20906-1-git-send-email-yishaih@mellanox.com>
 <20170817173320.GB22792@obsidianresearch.com>
 <20170817173932.GJ23648@mtr-leonro.local>
 <20170817180349.GD24735@obsidianresearch.com>
 <99bc8f57-6a58-d309-7142-74cc498f7feb@dev.mellanox.co.il>
 <20170821152237.GA3400@obsidianresearch.com>
 <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e@dev.mellanox.co.il>
 <20170822163007.GB4922@obsidianresearch.com>
 <1b7e41dc-4873-7c0a-6cdb-bc499af70af2@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1b7e41dc-4873-7c0a-6cdb-bc499af70af2-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 23, 2017 at 03:13:38PM +0300, Yishai Hadas wrote:
> On 8/22/2017 7:30 PM, Jason Gunthorpe wrote:
> >On Tue, Aug 22, 2017 at 11:36:42AM +0300, Yishai Hadas wrote:
> >>On 8/21/2017 6:22 PM, Jason Gunthorpe wrote:
> >>>Is there existing code out there that uses cq_out->uar and works
> >>>properly today? Yes or No?
> >>
> >>No, only this fix enables that to work properly.
> 
> >Particularly since a patch to do this with proper compatibility
> >exists, and there is no reason at all to take a shortcut.
> >
> 
> We are not looking for a shortcut but for a solution that will match
> majority users if not all.

Here is the patch that takes care of everything properly. It is PR
188.

Please be more careful with the ABI requirements in the future.

>From 32ef444e45006112ff759106dcdee2b99999501a Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Wed, 23 Aug 2017 10:05:24 -0600
Subject: [PATCH] mlx5: Fix ABI break from revising the UAR pointer

Provide two implementations of mlx5dv_init_obj, one that has the
historical behaviour that has existed until now of returning the
void **uar and a new version that returns the 'void *' version
renamed to arb_db.

Apps that use this feature must refer to it as arb_db, they will not
compile on pre-rdma-core 15 releases, and they will not dynamically
link to old versions either. This provides a sane level of safety for
the end users of this library.

Fixes: c6e3439aaa93 ("mlx5: Return pointer to CQ doorbell")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/ibverbs-providers.symbols |  2 ++
 providers/mlx5/CMakeLists.txt    |  2 +-
 providers/mlx5/libmlx5.map       |  5 +++++
 providers/mlx5/mlx5.c            | 22 ++++++++++++++++++++--
 providers/mlx5/mlx5dv.h          |  2 +-
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index 5aa3b877b55b59..b03c33a2ba9fce 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -4,6 +4,8 @@ libmlx4.so.1 ibverbs-providers #MINVER#
 libmlx5.so.1 ibverbs-providers #MINVER#
  MLX5_1.0@MLX5_1.0 13
  MLX5_1.1@MLX5_1.1 14
+ MLX5_1.2@MLX5_1.2 15
  mlx5dv_init_obj@MLX5_1.0 13
+ mlx5dv_init_obj@MLX5_1.2 15
  mlx5dv_query_device@MLX5_1.0 13
  mlx5dv_create_cq@MLX5_1.1 14
diff --git a/providers/mlx5/CMakeLists.txt b/providers/mlx5/CMakeLists.txt
index 0fb9907bf258d1..ab6a42d8915a2a 100644
--- a/providers/mlx5/CMakeLists.txt
+++ b/providers/mlx5/CMakeLists.txt
@@ -11,7 +11,7 @@ if (MLX5_MW_DEBUG)
 endif()
 
 rdma_shared_provider(mlx5 libmlx5.map
-  1 1.1.${PACKAGE_VERSION}
+  1 1.2.${PACKAGE_VERSION}
   buf.c
   cq.c
   dbrec.c
diff --git a/providers/mlx5/libmlx5.map b/providers/mlx5/libmlx5.map
index 6d9fb25f00a3db..e7fe9f41697009 100644
--- a/providers/mlx5/libmlx5.map
+++ b/providers/mlx5/libmlx5.map
@@ -11,3 +11,8 @@ MLX5_1.1 {
 	global:
 		mlx5dv_create_cq;
 } MLX5_1.0;
+
+MLX5_1.2 {
+	global:
+		mlx5dv_init_obj;
+} MLX5_1.1;
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index dd825561ec740f..7ec5951b6ff1f8 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -678,7 +678,7 @@ static int mlx5dv_get_cq(struct ibv_cq *cq_in,
 	cq_out->cqe_size  = mcq->cqe_sz;
 	cq_out->buf       = mcq->active_buf->buf;
 	cq_out->dbrec     = mcq->dbrec;
-	cq_out->uar	  = mctx->uar[0];
+	cq_out->arm_db	  = mctx->uar[0];
 
 	mcq->flags	 |= MLX5_CQ_FLAGS_DV_OWNED;
 
@@ -716,7 +716,8 @@ static int mlx5dv_get_srq(struct ibv_srq *srq_in,
 	return 0;
 }
 
-int mlx5dv_init_obj(struct mlx5dv_obj *obj, uint64_t obj_type)
+int __mlx5dv_init_obj_1_2(struct mlx5dv_obj *obj, uint64_t obj_type);
+int __mlx5dv_init_obj_1_2(struct mlx5dv_obj *obj, uint64_t obj_type)
 {
 	int ret = 0;
 
@@ -731,6 +732,23 @@ int mlx5dv_init_obj(struct mlx5dv_obj *obj, uint64_t obj_type)
 
 	return ret;
 }
+asm(".symver __mlx5dv_init_obj_1_2, mlx5dv_init_obj@@MLX5_1.2");
+
+int __mlx5dv_init_obj_1_0(struct mlx5dv_obj *obj, uint64_t obj_type);
+int __mlx5dv_init_obj_1_0(struct mlx5dv_obj *obj, uint64_t obj_type)
+{
+	int ret = 0;
+
+	ret = __mlx5dv_init_obj_1_2(obj, obj_type);
+	if (!ret && (obj_type & MLX5DV_OBJ_CQ)) {
+		/* ABI version 1.0 returns the void ** in this memory
+		 * location
+		 */
+		obj->cq.out->arm_db = to_mctx(obj->cq.in->context)->uar;
+	}
+	return ret;
+}
+asm(".symver __mlx5dv_init_obj_1_0, mlx5dv_init_obj@MLX5_1.0");
 
 static void adjust_uar_info(struct mlx5_device *mdev,
 			    struct mlx5_context *context,
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index cff3a10457300f..1a2e257c4bcc6f 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -129,7 +129,7 @@ struct mlx5dv_cq {
 	__be32			*dbrec;
 	uint32_t		cqe_cnt;
 	uint32_t		cqe_size;
-	void			*uar;
+	void			*arm_db;
 	uint32_t		cqn;
 	uint64_t		comp_mask;
 };
-- 
2.7.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
