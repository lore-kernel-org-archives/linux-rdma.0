From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v2 03/10] IB/mlx5, mlx5_core: Support for create_mr
 and destroy_mr
Date: Thu, 31 Oct 2013 14:59:49 +0200
Message-ID: <52725445.7040005@mellanox.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-4-git-send-email-sagig@mellanox.com> <52725299.7020105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52725299.7020105-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/31/2013 2:52 PM, Jack Wang wrote:
> On 10/31/2013 01:24 PM, Sagi Grimberg wrote:
>> Support create_mr and destroy_mr verbs.
>> Creating ib_mr may be done for either ib_mr that will
>> register regular page lists like alloc_fast_reg_mr routine,
>> or indirect ib_mr's that can register other (pre-registered)
>> ib_mr's in an indirect manner.
>>
>> In addition user may request signature enable, that will mean
>> that the created ib_mr may be attached with signature attributes
>> (BSF, PSVs).
>>
>> Currently we only allow direct/indirect registration modes.
>>
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/mlx5/main.c            |    2 +
>>   drivers/infiniband/hw/mlx5/mlx5_ib.h         |    4 +
>>   drivers/infiniband/hw/mlx5/mr.c              |  109 ++++++++++++++++++++++++++
>>   drivers/net/ethernet/mellanox/mlx5/core/mr.c |   64 +++++++++++++++
>>   include/linux/mlx5/device.h                  |   25 ++++++
>>   include/linux/mlx5/driver.h                  |   19 +++++
>>   6 files changed, 223 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index 3f831de..2e67a37 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
>> @@ -1401,9 +1401,11 @@ static int init_one(struct pci_dev *pdev,
>>   	dev->ib_dev.get_dma_mr		= mlx5_ib_get_dma_mr;
>>   	dev->ib_dev.reg_user_mr		= mlx5_ib_reg_user_mr;
>>   	dev->ib_dev.dereg_mr		= mlx5_ib_dereg_mr;
>> +	dev->ib_dev.destroy_mr		= mlx5_ib_destroy_mr;
>>   	dev->ib_dev.attach_mcast	= mlx5_ib_mcg_attach;
>>   	dev->ib_dev.detach_mcast	= mlx5_ib_mcg_detach;
>>   	dev->ib_dev.process_mad		= mlx5_ib_process_mad;
>> +	dev->ib_dev.create_mr		= mlx5_ib_create_mr;
>>   	dev->ib_dev.alloc_fast_reg_mr	= mlx5_ib_alloc_fast_reg_mr;
>>   	dev->ib_dev.alloc_fast_reg_page_list = mlx5_ib_alloc_fast_reg_page_list;
>>   	dev->ib_dev.free_fast_reg_page_list  = mlx5_ib_free_fast_reg_page_list;
>> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> index 836be91..45d7424 100644
>> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> @@ -262,6 +262,7 @@ struct mlx5_ib_mr {
>>   	int			npages;
>>   	struct completion	done;
>>   	enum ib_wc_status	status;
>> +	struct mlx5_core_sig_ctx    *sig;
>>   };
>>   
>>   struct mlx5_ib_fast_reg_page_list {
>> @@ -489,6 +490,9 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
>>   				  u64 virt_addr, int access_flags,
>>   				  struct ib_udata *udata);
>>   int mlx5_ib_dereg_mr(struct ib_mr *ibmr);
>> +int mlx5_ib_destroy_mr(struct ib_mr *ibmr);
>> +struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
>> +				struct ib_mr_init_attr *mr_init_attr);
>>   struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
>>   					int max_page_list_len);
>>   struct ib_fast_reg_page_list *mlx5_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
>> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
>> index bd41df9..44f7e46 100644
>> --- a/drivers/infiniband/hw/mlx5/mr.c
>> +++ b/drivers/infiniband/hw/mlx5/mr.c
>> @@ -921,6 +921,115 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
>>   	return 0;
>>   }
>>   
>> +struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
>> +				struct ib_mr_init_attr *mr_init_attr)
>> +{
>> +	struct mlx5_ib_dev *dev = to_mdev(pd->device);
>> +	struct mlx5_create_mkey_mbox_in *in;
>> +	struct mlx5_ib_mr *mr;
>> +	int access_mode, err;
>> +	int ndescs = roundup(mr_init_attr->max_reg_descriptors, 4);
>> +
>> +	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
>> +	if (!mr)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	in = kzalloc(sizeof(*in), GFP_KERNEL);
>> +	if (!in) {
>> +		err = -ENOMEM;
>> +		goto err_free;
>> +	}
>> +
>> +	in->seg.status = 1 << 6; /* free */
>> +	in->seg.xlt_oct_size = cpu_to_be32(ndescs);
>> +	in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
>> +	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
>> +	access_mode = MLX5_ACCESS_MODE_MTT;
>> +
>> +	if (mr_init_attr->flags & IB_MR_SIGNATURE_EN) {
>> +		u32 psv_index[2];
>> +
>> +		in->seg.flags_pd = cpu_to_be32(be32_to_cpu(in->seg.flags_pd) |
>> +							   MLX5_MKEY_BSF_EN);
>> +		in->seg.bsfs_octo_size = cpu_to_be32(MLX5_MKEY_BSF_OCTO_SIZE);
>> +		mr->sig = kzalloc(sizeof(*mr->sig), GFP_KERNEL);
>> +		if (!mr->sig) {
>> +			err = -ENOMEM;
>> +			goto err_free;
>> +		}
>> +
>> +		/* create mem & wire PSVs */
>> +		err = mlx5_core_create_psv(&dev->mdev, to_mpd(pd)->pdn,
>> +					   2, psv_index);
>> +		if (err)
>> +			goto err_free_sig;
>> +
>> +		access_mode = MLX5_ACCESS_MODE_KLM;
>> +		mr->sig->psv_memory.psv_idx = psv_index[0];
>> +		mr->sig->psv_wire.psv_idx = psv_index[1];
>> +	}
>> +
>> +	in->seg.flags = MLX5_PERM_UMR_EN | access_mode;
>> +	err = mlx5_core_create_mkey(&dev->mdev, &mr->mmr, in, sizeof(*in));
>> +	kfree(in);
>> +	if (err)
>> +		goto err_destroy_psv;
>> +
>> +	mr->ibmr.lkey = mr->mmr.key;
>> +	mr->ibmr.rkey = mr->mmr.key;
>> +	mr->umem = NULL;
>> +
>> +	return &mr->ibmr;
>> +
>> +err_destroy_psv:
>> +	if (mr->sig) {
>> +		if (mlx5_core_destroy_psv(&dev->mdev,
>> +					  mr->sig->psv_memory.psv_idx))
>> +			mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
>> +				     mr->sig->psv_memory.psv_idx);
>> +		if (mlx5_core_destroy_psv(&dev->mdev,
>> +					  mr->sig->psv_wire.psv_idx))
>> +			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
>> +				     mr->sig->psv_wire.psv_idx);
>> +	}
>> +err_free_sig:
>> +	if (mr->sig)
>> +		kfree(mr->sig);
>> +err_free:
>> +	kfree(mr);
>> +	return ERR_PTR(err);
>> +}
>> +
> There are memory leak in this function, you forget to kfree in in error
> case.
>
> Jack

Nice Catch! Thanks!

I'll make sure to fix and resend.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
