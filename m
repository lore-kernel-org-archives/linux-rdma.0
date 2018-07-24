From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 0/8] Support mlx5 flow steering with RAW data
Date: Tue, 24 Jul 2018 14:13:00 -0600
Message-ID: <20180724201300.GQ532@ziepe.ca>
References: <20180723122512.20967-1-leon@kernel.org>
 <20180724024236.GA16958@ziepe.ca>
 <20180724055609.GG3189@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180724055609.GG3189@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 24, 2018 at 08:56:09AM +0300, Leon Romanovsky wrote:
> On Mon, Jul 23, 2018 at 08:42:36PM -0600, Jason Gunthorpe wrote:
> > On Mon, Jul 23, 2018 at 03:25:04PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Changelog:
> > > v1->v2:
> > >  * Fix matcher to use the correct size.
> > >  * Rephrase commit log of the first patch.
> > > v0->v1:
> > >  * Fixed ADD_UVERBS_ATTRIBUTES_SIMPLE macro to pass the real address.
> > >  ?* Replaced UA_ALLOC_AND_COPY to regular copy_from
> > >  * Added UVERBS_ATTR_NO_DATA new macro for cleaner code.
> > >  * Used ib_dev from uobj when it exists.
> > >  * ib_is_destroy_retryable was replaced by ib_destroy_usecnt
> > >
> > > >From Yishai:
> > >
> > > This series introduces vendor create and destroy flow methods on the
> > > uverbs flow object by using the KABI infra-structure.
> > >
> > > It's done in a way that enables the driver to get its specific device
> > > attributes in a raw data to match its underlay specification while still
> > > using the generic ib_flow object for cleanup and code sharing.
> > >
> > > In addition, a specific mlx5 matcher object and its create/destroy
> > > methods were introduced. This object matches the underlay flow steering
> > > mask specification and is used as part of mlx5 create flow input data.
> > >
> > > This series supports IB_QP/TIR as its flow steering destination as
> > > applicable today via the ib_create_flow API, however, it adds also an
> > > option to work with DEVX object which its destination can be both TIR
> > > and flow table.
> > >
> > > Few changes were done in the mlx5 core layer to support forward
> > > compatible for the device specification raw data and to support flow
> > > table when the DEVX destination is used.
> > >
> > > As part of this series the default IB destroy handler
> > > (i.e. uverbs_destroy_def_handler()) was exposed from IB core to be
> > > used by the drivers and existing code was refactored to use it.
> > >
> > > Thanks
> > >
> > > Yishai Hadas (8):
> > >   net/mlx5: Add forward compatible support for the FTE match data
> > >   net/mlx5: Add support for flow table destination number
> > >   IB/mlx5: Introduce flow steering matcher object
> > >   IB: Consider ib_flow creation by the KABI infrastructure
> > >   IB/mlx5: Introduce vendor create and destroy flow methods
> > >   IB/mlx5: Support adding flow steering rule by raw data
> > >   IB/mlx5: Add support for a flow table destination
> > >   IB/mlx5: Expose vendor flow trees
> >
> > This seems fine to me. Can you send the mlx5 shared branch for the
> > first two patches?
> 
> I applied two first patches with Acked-by from Saeed to mlx5-next
> 
> 664000b6bb43 net/mlx5: Add support for flow table destination number
> 2aada6c0c96e net/mlx5: Add forward compatible support for the FTE match data

Okay, I merged the mlx5 branch and applied the series to for-next.

There was a trivial build failure with !CONFIG_INFINIBAND_USER_ACCESS
and a bunch of annoying check patch warnings regarding tabs and
leading white space. While I was fixing those I fixed the long lines
too, they had no reason to be long.

Also, I would like to keep the specs consistently formatted according
to clang-format with 'BinPackParameters: true', so I reflowed them as
well.

Please check and let me know if I made an error, diff is below.

Jason

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index c94ee1a43e2c3f..ee398a9b5f26b0 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -50,8 +50,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 	int inlen;
 	bool dest_devx, dest_qp;
 	struct ib_qp *qp = NULL;
-	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
-                         MLX5_IB_ATTR_CREATE_FLOW_HANDLE);
+	struct ib_uobject *uobj =
+		uverbs_attr_get_uobject(attrs, MLX5_IB_ATTR_CREATE_FLOW_HANDLE);
 	struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);
 
 	if (!capable(CAP_NET_RAW))
@@ -66,7 +66,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 		return -EINVAL;
 
 	if (dest_devx) {
-		devx_obj = uverbs_attr_get_obj(attrs, MLX5_IB_ATTR_CREATE_FLOW_DEST_DEVX);
+		devx_obj = uverbs_attr_get_obj(
+			attrs, MLX5_IB_ATTR_CREATE_FLOW_DEST_DEVX);
 		if (IS_ERR(devx_obj))
 			return PTR_ERR(devx_obj);
 
@@ -97,8 +98,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 	if (dev->rep)
 		return -ENOTSUPP;
 
-	cmd_in = uverbs_attr_get_alloced_ptr(attrs,
-					     MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE);
+	cmd_in = uverbs_attr_get_alloced_ptr(
+		attrs, MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE);
 	inlen = uverbs_attr_get_len(attrs,
 				    MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE);
 	fs_matcher = uverbs_attr_get_obj(attrs,
@@ -127,9 +128,9 @@ static int flow_matcher_cleanup(struct ib_uobject *uobject,
 	return 0;
 }
 
-static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(struct ib_device *ib_dev,
-				   struct ib_uverbs_file *file,
-				   struct uverbs_attr_bundle *attrs)
+static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
+	struct ib_device *ib_dev, struct ib_uverbs_file *file,
+	struct uverbs_attr_bundle *attrs)
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_FLOW_MATCHER_CREATE_HANDLE);
@@ -141,16 +142,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(struct ib_device *
 	if (!obj)
 		return -ENOMEM;
 
-	obj->mask_len = uverbs_attr_get_len(attrs,
-					    MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK);
+	obj->mask_len = uverbs_attr_get_len(
+		attrs, MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK);
 	err = uverbs_copy_from(&obj->matcher_mask,
 			       attrs,
 			       MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK);
 	if (err)
 		goto end;
 
-	obj->flow_type = uverbs_attr_get_enum_id(attrs,
-						 MLX5_IB_ATTR_FLOW_MATCHER_FLOW_TYPE);
+	obj->flow_type = uverbs_attr_get_enum_id(
+		attrs, MLX5_IB_ATTR_FLOW_MATCHER_FLOW_TYPE);
 
 	if (obj->flow_type == MLX5_IB_FLOW_TYPE_NORMAL) {
 		err = uverbs_copy_from(&obj->priority,
@@ -182,21 +183,22 @@ DECLARE_UVERBS_NAMED_METHOD(
 			UVERBS_OBJECT_FLOW,
 			UVERBS_ACCESS_NEW,
 			UA_MANDATORY),
-	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE,
-			   UVERBS_ATTR_SIZE(1, sizeof(struct mlx5_ib_match_params)),
-			   UA_MANDATORY,
-			   UA_ALLOC_AND_COPY),
+	UVERBS_ATTR_PTR_IN(
+		MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE,
+		UVERBS_ATTR_SIZE(1, sizeof(struct mlx5_ib_match_params)),
+		UA_MANDATORY,
+		UA_ALLOC_AND_COPY),
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_MATCHER,
 			MLX5_IB_OBJECT_FLOW_MATCHER,
 			UVERBS_ACCESS_READ,
 			UA_MANDATORY),
-	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_DEST_QP, UVERBS_OBJECT_QP,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_DEST_QP,
+			UVERBS_OBJECT_QP,
 			UVERBS_ACCESS_READ),
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_DEST_DEVX,
 			MLX5_IB_OBJECT_DEVX_OBJ,
 			UVERBS_ACCESS_READ));
 
-
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	MLX5_IB_METHOD_DESTROY_FLOW,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_CREATE_FLOW_HANDLE,
@@ -212,36 +214,34 @@ ADD_UVERBS_METHODS(mlx5_ib_fs,
 DECLARE_UVERBS_NAMED_METHOD(
 	MLX5_IB_METHOD_FLOW_MATCHER_CREATE,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_FLOW_MATCHER_CREATE_HANDLE,
-			 MLX5_IB_OBJECT_FLOW_MATCHER,
-			 UVERBS_ACCESS_NEW,
-			 UA_MANDATORY),
+			MLX5_IB_OBJECT_FLOW_MATCHER,
+			UVERBS_ACCESS_NEW,
+			UA_MANDATORY),
 	UVERBS_ATTR_PTR_IN(
 		MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK,
 		UVERBS_ATTR_SIZE(1, sizeof(struct mlx5_ib_match_params)),
 		UA_MANDATORY),
-	UVERBS_ATTR_ENUM_IN(
-		MLX5_IB_ATTR_FLOW_MATCHER_FLOW_TYPE,
-		mlx5_ib_flow_type,
-		UA_MANDATORY),
-	UVERBS_ATTR_PTR_IN(
-		MLX5_IB_ATTR_FLOW_MATCHER_MATCH_CRITERIA,
-		UVERBS_ATTR_TYPE(u8),
-		UA_MANDATORY));
+	UVERBS_ATTR_ENUM_IN(MLX5_IB_ATTR_FLOW_MATCHER_FLOW_TYPE,
+			    mlx5_ib_flow_type,
+			    UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_FLOW_MATCHER_MATCH_CRITERIA,
+			   UVERBS_ATTR_TYPE(u8),
+			   UA_MANDATORY));
 
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	MLX5_IB_METHOD_FLOW_MATCHER_DESTROY,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_FLOW_MATCHER_DESTROY_HANDLE,
-			 MLX5_IB_OBJECT_FLOW_MATCHER,
-			 UVERBS_ACCESS_DESTROY,
-			 UA_MANDATORY));
+			MLX5_IB_OBJECT_FLOW_MATCHER,
+			UVERBS_ACCESS_DESTROY,
+			UA_MANDATORY));
 
 DECLARE_UVERBS_NAMED_OBJECT(MLX5_IB_OBJECT_FLOW_MATCHER,
-			UVERBS_TYPE_ALLOC_IDR(flow_matcher_cleanup),
-			&UVERBS_METHOD(MLX5_IB_METHOD_FLOW_MATCHER_CREATE),
-			&UVERBS_METHOD(MLX5_IB_METHOD_FLOW_MATCHER_DESTROY));
+			    UVERBS_TYPE_ALLOC_IDR(flow_matcher_cleanup),
+			    &UVERBS_METHOD(MLX5_IB_METHOD_FLOW_MATCHER_CREATE),
+			    &UVERBS_METHOD(MLX5_IB_METHOD_FLOW_MATCHER_DESTROY));
 
 DECLARE_UVERBS_OBJECT_TREE(flow_objects,
-			&UVERBS_OBJECT(MLX5_IB_OBJECT_FLOW_MATCHER));
+			   &UVERBS_OBJECT(MLX5_IB_OBJECT_FLOW_MATCHER));
 
 int mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root)
 {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 5f08b69f8a4f60..ec8410d3c4eb2a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1232,11 +1232,9 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
 void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
 			  struct mlx5_ib_ucontext *context);
 const struct uverbs_object_tree_def *mlx5_ib_get_devx_tree(void);
-struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
-						     struct mlx5_ib_flow_matcher *fs_matcher,
-						     void *cmd_in,
-						     int inlen, int dest_id,
-						     int dest_type);
+struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(
+	struct mlx5_ib_dev *dev, struct mlx5_ib_flow_matcher *fs_matcher,
+	void *cmd_in, int inlen, int dest_id, int dest_type);
 bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id, int *dest_type);
 int mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root);
 #else
@@ -1247,17 +1245,22 @@ static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
 					struct mlx5_ib_ucontext *context) {}
 static inline const struct uverbs_object_tree_def *
 mlx5_ib_get_devx_tree(void) { return NULL; }
-static inline struct mlx5_ib_flow_handler *
-mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
-			struct mlx5_ib_flow_matcher *fs_matcher,
-			void *cmd_in,
-			int inlen, int dest_id,
-			int dest_type) { return -EOPNOTSUPP; };
-static inline bool
-mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id,
-			  int *dest_type) { return false; };
+static inline struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(
+	struct mlx5_ib_dev *dev, struct mlx5_ib_flow_matcher *fs_matcher,
+	void *cmd_in, int inlen, int dest_id, int dest_type)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+static inline bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id,
+					     int *dest_type)
+{
+	return false;
+}
 static inline int
-mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root) { return 0; };
+mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root)
+{
+	return 0;
+}
 #endif
 static inline void init_query_mad(struct ib_smp *mad)
 {
