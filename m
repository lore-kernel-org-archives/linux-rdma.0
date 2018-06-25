From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 01/12] RDMA/uverbs: Protect from attempts to
 create flows on unsupported QP
Date: Mon, 25 Jun 2018 15:14:40 -0600
Message-ID: <20180625211440.GA29264@ziepe.ca>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180624082353.16138-2-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 24, 2018 at 11:23:42AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Flows can be created on UD and RAW_PACKET QP types. Attempts to provide
> other QP types as an input causes to various unpredictable failures.
> 
> The reason to it that in order to support all various types (e.g. XRC),
> we are supposed to use real_qp handle and not qp handle and give to
> driver/FW to fail such (XRC) flows. Being valuable solution, the simpler
> and safer variant is to ban all QP types except UD and RAW_PACKET,
> instead of relying on driver/FW.
> 
> Cc: <stable@vger.kernel.org> # 3.11
> Fixes: 436f2ad05a0b ("IB/core: Export ib_create/destroy_flow through uverbs")
> Cc: syzkaller <syzkaller@googlegroups.com>
> Reported-by: Noa Osherovich <noaos@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 779892b63729..c842a9423fbf 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -3553,14 +3553,20 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
>  		goto err_free_attr;
>  	}
>  
> -	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd.qp_handle, file->ucontext);
> +	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd.qp_handle,
> +			       file->ucontext);

This hunk is just whitespace changing

>  	if (!qp) {
>  		err = -EINVAL;
>  		goto err_uobj;
>  	}
>  
> +	if (qp->qp_type != IB_QPT_UD && qp->qp_type != IB_QPT_RAW_PACKET) {
> +		err = -EINVAL;
> +		goto err_put;
> +	}
> +
>  	flow_attr = kzalloc(struct_size(flow_attr, flows,
> -				cmd.flow_attr.num_of_specs), GFP_KERNEL);
> +					cmd.flow_attr.num_of_specs), GFP_KERNEL);

Same here.

I dropped the two hunks and applied this to for-rc since it has
stable tags.

Jason
