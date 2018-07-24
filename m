From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 0/8] Support mlx5 flow steering with RAW data
Date: Tue, 24 Jul 2018 14:35:45 -0600
Message-ID: <20180724203545.GR532@ziepe.ca>
References: <20180723122512.20967-1-leon@kernel.org>
 <20180724024236.GA16958@ziepe.ca>
 <20180724055609.GG3189@mtr-leonro.mtl.com>
 <20180724201300.GQ532@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180724201300.GQ532@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 24, 2018 at 02:13:00PM -0600, Jason Gunthorpe wrote:

> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index 5f08b69f8a4f60..ec8410d3c4eb2a 100644
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -1232,11 +1232,9 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
>  void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
>  			  struct mlx5_ib_ucontext *context);
>  const struct uverbs_object_tree_def *mlx5_ib_get_devx_tree(void);
> -struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
> -						     struct mlx5_ib_flow_matcher *fs_matcher,
> -						     void *cmd_in,
> -						     int inlen, int dest_id,
> -						     int dest_type);
> +struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(
> +	struct mlx5_ib_dev *dev, struct mlx5_ib_flow_matcher *fs_matcher,
> +	void *cmd_in, int inlen, int dest_id, int dest_type);
>  bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id, int *dest_type);
>  int mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root);
>  #else
> @@ -1247,17 +1245,22 @@ static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
>  					struct mlx5_ib_ucontext *context) {}
>  static inline const struct uverbs_object_tree_def *
>  mlx5_ib_get_devx_tree(void) { return NULL; }
> -static inline struct mlx5_ib_flow_handler *
> -mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
> -			struct mlx5_ib_flow_matcher *fs_matcher,
> -			void *cmd_in,
> -			int inlen, int dest_id,
> -			int dest_type) { return -EOPNOTSUPP; };
> -static inline bool
> -mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id,
> -			  int *dest_type) { return false; };
> +static inline struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(
> +	struct mlx5_ib_dev *dev, struct mlx5_ib_flow_matcher *fs_matcher,
> +	void *cmd_in, int inlen, int dest_id, int dest_type)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}

Bah, I botched the compile test for this - this entire static inline
should just be removed because the function is defined in main.c which
is always compiled.

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index ec8410d3c4eb2a..462505c8fa25a0 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1245,12 +1245,6 @@ static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
                                        struct mlx5_ib_ucontext *context) {}
 static inline const struct uverbs_object_tree_def *
 mlx5_ib_get_devx_tree(void) { return NULL; }
-static inline struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(
-       struct mlx5_ib_dev *dev, struct mlx5_ib_flow_matcher *fs_matcher,
-       void *cmd_in, int inlen, int dest_id, int dest_type)
-{
-       return ERR_PTR(-EOPNOTSUPP);
-}
 static inline bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id,
                                             int *dest_type)
 {

Jason
