From: Yishai Hadas <yishaih@dev.mellanox.co.il>
Subject: Re: [PATCH rdma-next v3 08/14] IB/core: Support passing uhw for
 create_flow
Date: Thu, 31 May 2018 18:09:48 +0300
Message-ID: <a052d9e5-16c9-5a89-8f55-c7650eff4b38@dev.mellanox.co.il>
References: <20180531134341.18441-1-leon@kernel.org>
 <20180531134341.18441-9-leon@kernel.org>
 <14063C7AD467DE4B82DEDB5C278E8663B38F0635@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663B38F0635@FMSMSX108.amr.corp.intel.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 5/31/2018 5:42 PM, Ruhl, Michael J wrote:
>> -----Original Message-----
>> From: Leon Romanovsky [mailto:leon@kernel.org]
>> Sent: Thursday, May 31, 2018 9:44 AM
>> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
>> <jgg@mellanox.com>
>> Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
>> rdma@vger.kernel.org>; Boris Pismenny <borisp@mellanox.com>; Matan
>> Barak <matanb@mellanox.com>; Ruhl, Michael J <michael.j.ruhl@intel.com>;
>> Or Gerlitz <ogerlitz@mellanox.com>; Raed Salem <raeds@mellanox.com>;
>> Yishai Hadas <yishaih@mellanox.com>; Saeed Mahameed
>> <saeedm@mellanox.com>; linux-netdev <netdev@vger.kernel.org>
>> Subject: [PATCH rdma-next v3 08/14] IB/core: Support passing uhw for
>> create_flow
>>
>> From: Matan Barak <matanb@mellanox.com>
>>
>> This is required when user-space drivers need to pass extra information
>> regarding how to handle this flow steering specification.
>>
>> Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
>> Signed-off-by: Matan Barak <matanb@mellanox.com>
>> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>> ---
>> drivers/infiniband/core/uverbs_cmd.c | 7 ++++++-
>> drivers/infiniband/core/verbs.c      | 2 +-
>> drivers/infiniband/hw/mlx4/main.c    | 6 +++++-
>> drivers/infiniband/hw/mlx5/main.c    | 7 ++++++-
>> include/rdma/ib_verbs.h              | 3 ++-
>> 5 files changed, 20 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/uverbs_cmd.c
>> b/drivers/infiniband/core/uverbs_cmd.c
>> index e74262ee104c..ddb9d79691be 100644
>> --- a/drivers/infiniband/core/uverbs_cmd.c
>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>> @@ -3542,11 +3542,16 @@ int ib_uverbs_ex_create_flow(struct
>> ib_uverbs_file *file,
>> 		err = -EINVAL;
>> 		goto err_free;
>> 	}
>> -	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
>> +
>> +	flow_id = qp->device->create_flow(qp, flow_attr,
>> +					  IB_FLOW_DOMAIN_USER, uhw);
>> +
> 
> If the create_flow() callback is not defined, won't this cause a problem?
> 
> ib_flow_create() checks for the NULL.
> 

We are fine here.

This function is called only if the device turned on the command mask 
(i.e. IB_USER_VERBS_EX_CMD_CREATE_FLOW) which comes together with its 
callback.

see:
https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/uverbs_main.c#L709

> 
> 
>> 	if (IS_ERR(flow_id)) {
>> 		err = PTR_ERR(flow_id);
>> 		goto err_free;
>> 	}
>> +	atomic_inc(&qp->usecnt);
>> +	flow_id->qp = qp;
>> 	flow_id->uobject = uobj;
>> 	uobj->object = flow_id;
>> 	uflow = container_of(uobj, typeof(*uflow), uobject);
>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
>> index 6ddfb1fade79..0b56828c1319 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -1983,7 +1983,7 @@ struct ib_flow *ib_create_flow(struct ib_qp *qp,
>> 	if (!qp->device->create_flow)
>> 		return ERR_PTR(-EOPNOTSUPP);
>>
>> -	flow_id = qp->device->create_flow(qp, flow_attr, domain);
>> +	flow_id = qp->device->create_flow(qp, flow_attr, domain, NULL);
>> 	if (!IS_ERR(flow_id)) {
>> 		atomic_inc(&qp->usecnt);
>> 		flow_id->qp = qp;
>> diff --git a/drivers/infiniband/hw/mlx4/main.c
>> b/drivers/infiniband/hw/mlx4/main.c
>> index bf12394c13c1..6fe5d5d1d1d9 100644
>> --- a/drivers/infiniband/hw/mlx4/main.c
>> +++ b/drivers/infiniband/hw/mlx4/main.c
>> @@ -1848,7 +1848,7 @@ static int mlx4_ib_add_dont_trap_rule(struct
>> mlx4_dev *dev,
>>
>> static struct ib_flow *mlx4_ib_create_flow(struct ib_qp *qp,
>> 				    struct ib_flow_attr *flow_attr,
>> -				    int domain)
>> +				    int domain, struct ib_udata *udata)
>> {
>> 	int err = 0, i = 0, j = 0;
>> 	struct mlx4_ib_flow *mflow;
>> @@ -1866,6 +1866,10 @@ static struct ib_flow *mlx4_ib_create_flow(struct
>> ib_qp *qp,
>> 	    (flow_attr->type != IB_FLOW_ATTR_NORMAL))
>> 		return ERR_PTR(-EOPNOTSUPP);
>>
>> +	if (udata &&
>> +	    udata->inlen && !ib_is_udata_cleared(udata, 0, udata->inlen))
>> +		return ERR_PTR(-EOPNOTSUPP);
>> +
>> 	memset(type, 0, sizeof(type));
>>
>> 	mflow = kzalloc(sizeof(*mflow), GFP_KERNEL);
>> diff --git a/drivers/infiniband/hw/mlx5/main.c
>> b/drivers/infiniband/hw/mlx5/main.c
>> index 92879d2d3026..fb31a719ee25 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
>> @@ -3371,7 +3371,8 @@ static struct mlx5_ib_flow_handler
>> *create_sniffer_rule(struct mlx5_ib_dev *dev,
>>
>> static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
>> 					   struct ib_flow_attr *flow_attr,
>> -					   int domain)
>> +					   int domain,
>> +					   struct ib_udata *udata)
>> {
>> 	struct mlx5_ib_dev *dev = to_mdev(qp->device);
>> 	struct mlx5_ib_qp *mqp = to_mqp(qp);
>> @@ -3383,6 +3384,10 @@ static struct ib_flow *mlx5_ib_create_flow(struct
>> ib_qp *qp,
>> 	int err;
>> 	int underlay_qpn;
>>
>> +	if (udata &&
>> +	    udata->inlen && !ib_is_udata_cleared(udata, 0, udata->inlen))
>> +		return ERR_PTR(-EOPNOTSUPP);
>> +
>> 	if (flow_attr->priority > MLX5_IB_FLOW_LAST_PRIO)
>> 		return ERR_PTR(-ENOMEM);
>>
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index ba49e874c841..84f412f7b8f3 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -2459,7 +2459,8 @@ struct ib_device {
>> 	struct ib_flow *	   (*create_flow)(struct ib_qp *qp,
>> 						  struct ib_flow_attr
>> 						  *flow_attr,
>> -						  int domain);
>> +						  int domain,
>> +						  struct ib_udata *udata);
>> 	int			   (*destroy_flow)(struct ib_flow *flow_id);
>> 	int			   (*check_mr_status)(struct ib_mr *mr, u32
>> check_mask,
>> 						      struct ib_mr_status
>> *mr_status);
>> --
>> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
