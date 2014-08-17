From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/3] mlx4_core: Add helper functions to support
 MR re-registration
Date: Sun, 17 Aug 2014 16:16:55 +0300
Message-ID: <53F0AB47.8050804@mellanox.com>
References: <1406793690-3816-1-git-send-email-ogerlitz@mellanox.com> <1406793690-3816-3-git-send-email-ogerlitz@mellanox.com> <53E206A2.6040800@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53E206A2.6040800-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/8/2014 1:42 PM, Sagi Grimberg wrote:
> On 7/31/2014 11:01 AM, Or Gerlitz wrote:
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Add few helper functions to support a mechanism of getting an
>> MPT, modifying it and updating the HCA with the modified object.
>>
>> The code takes 2 paths, one for directly changing the MPT (and sometimes
>> its related MTTs) and another one which queries the MPT and updates the
>> HCA via fw command SW2HW_MPT. The first path is used in native mode; the
>> second path is slower and is used only in SRIOV.
>>
>
> Hey Matan,
>
> Couple of comments below...
>
>> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    2 +
>>   drivers/net/ethernet/mellanox/mlx4/mr.c            |  160
>> ++++++++++++++++++++
>>   .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   26 +++-
>>   include/linux/mlx4/device.h                        |   16 ++
>>   4 files changed, 202 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
>> b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
>> index 1d8af73..b40d587 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
>> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
>> @@ -279,6 +279,8 @@ struct mlx4_icm_table {
>>   #define MLX4_MPT_FLAG_PHYSICAL        (1 <<  9)
>>   #define MLX4_MPT_FLAG_REGION        (1 <<  8)
>>
>> +#define MLX4_MPT_PD_MASK        (0x1FFFFUL)
>> +#define MLX4_MPT_PD_VF_MASK        (0xFE0000UL)
>>   #define MLX4_MPT_PD_FLAG_FAST_REG   (1 << 27)
>>   #define MLX4_MPT_PD_FLAG_RAE        (1 << 28)
>>   #define MLX4_MPT_PD_FLAG_EN_INV        (3 << 24)
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/mr.c
>> b/drivers/net/ethernet/mellanox/mlx4/mr.c
>> index 2839abb..7d717ec 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/mr.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
>> @@ -298,6 +298,131 @@ static int mlx4_HW2SW_MPT(struct mlx4_dev *dev,
>> struct mlx4_cmd_mailbox *mailbox
>>                   MLX4_CMD_TIME_CLASS_B, MLX4_CMD_WRAPPED);
>>   }
>>
>> +int mlx4_mr_hw_get_mpt(struct mlx4_dev *dev, struct mlx4_mr *mmr,
>> +               struct mlx4_mpt_entry ***mpt_entry)
>> +{
>> +    int err;
>> +    int key = key_to_hw_index(mmr->key) & (dev->caps.num_mpts - 1);
>> +    struct mlx4_cmd_mailbox *mailbox = NULL;
>> +
>> +    /* Make sure that at this point we have single-threaded access
>> only */
>
> This is not a specific comment for the below, but a general comment for
> the routine (otherwise I would expect the condition below to be
> atomic_read). Maybe it's better to document it as a requirement of the
> routine above (in kernel-doc style)?
>
>> +
>> +    if (mmr->enabled != MLX4_MPT_EN_HW)
>> +        return -EINVAL;
>> +
>> +    err = mlx4_HW2SW_MPT(dev, NULL, key);
>
> Nit: I'd lose this extra line between err=/if(err) statements.
> I see you did in some sections of this patch...
>
>> +
>> +    if (err) {
>> +        mlx4_warn(dev, "HW2SW_MPT failed (%d).", err);
>> +        mlx4_warn(dev, "Most likely the MR has MWs bound to it.\n");
>> +        return err;
>> +    }
>> +
>> +    mmr->enabled = MLX4_MPT_EN_SW;
>> +
>> +    if (!mlx4_is_mfunc(dev)) {
>> +        **mpt_entry = mlx4_table_find(
>> +                &mlx4_priv(dev)->mr_table.dmpt_table,
>> +                key, NULL);
>> +    } else {
>> +        mailbox = mlx4_alloc_cmd_mailbox(dev);
>> +        if (IS_ERR_OR_NULL(mailbox))
>> +            return PTR_ERR(mailbox);
>> +
>> +        err = mlx4_cmd_box(dev, 0, mailbox->dma, key,
>> +                   0, MLX4_CMD_QUERY_MPT,
>> +                   MLX4_CMD_TIME_CLASS_B,
>> +                   MLX4_CMD_WRAPPED);
>> +
>> +        if (err)
>> +            goto free_mailbox;
>> +
>> +        *mpt_entry = (struct mlx4_mpt_entry **)&mailbox->buf;
>> +    }
>> +
>> +    if (!(*mpt_entry) || !(**mpt_entry)) {
>> +        err = -ENOMEM;
>> +        goto free_mailbox;
>> +    }
>> +
>> +    return 0;
>> +
>> +free_mailbox:
>> +    mlx4_free_cmd_mailbox(dev, mailbox);
>> +    return err;
>> +}
>> +EXPORT_SYMBOL_GPL(mlx4_mr_hw_get_mpt);
>> +
>> +int mlx4_mr_hw_write_mpt(struct mlx4_dev *dev, struct mlx4_mr *mmr,
>> +             struct mlx4_mpt_entry **mpt_entry)
>> +{
>> +    int err;
>> +
>> +    if (!mlx4_is_mfunc(dev)) {
>> +        /* Make sure any changes to this entry are flushed */
>> +        wmb();
>> +
>> +        *(u8 *)(*mpt_entry) = MLX4_MPT_STATUS_HW;
>> +
>> +        /* Make sure the new status is written */
>> +        wmb();
>> +
>> +        err = mlx4_SYNC_TPT(dev);
>> +    } else {
>> +        int key = key_to_hw_index(mmr->key) & (dev->caps.num_mpts - 1);
>> +
>> +        struct mlx4_cmd_mailbox *mailbox =
>> +            container_of((void *)mpt_entry, struct mlx4_cmd_mailbox,
>> +                     buf);
>> +
>> +        err = mlx4_SW2HW_MPT(dev, mailbox, key);
>> +    }
>> +
>> +    mmr->pd = be32_to_cpu((*mpt_entry)->pd_flags) & MLX4_MPT_PD_MASK;
>
> Here you update the PD even if you failed while ib_core changes them
> only if it succeeded, that would causes inconsistency. I think it will
> be better to write this update only after write/put_mpt succeeded
> (meaning it might be better to move it to the caller - mlx4_ib).
>
>> +    if (!err)
>> +        mmr->enabled = MLX4_MPT_EN_HW;
>> +    return err;
>> +}
>> +EXPORT_SYMBOL_GPL(mlx4_mr_hw_write_mpt);
>> +
>> +void mlx4_mr_hw_put_mpt(struct mlx4_dev *dev,
>> +            struct mlx4_mpt_entry **mpt_entry)
>> +{
>> +    if (mlx4_is_mfunc(dev)) {
>> +        struct mlx4_cmd_mailbox *mailbox =
>> +            container_of((void *)mpt_entry, struct mlx4_cmd_mailbox,
>> +                     buf);
>> +        mlx4_free_cmd_mailbox(dev, mailbox);
>> +    }
>> +}
>> +EXPORT_SYMBOL_GPL(mlx4_mr_hw_put_mpt);
>> +
>> +int mlx4_mr_hw_change_pd(struct mlx4_dev *dev, struct mlx4_mpt_entry
>> *mpt_entry,
>> +             u32 pdn)
>> +{
>> +    u32 pd_flags = be32_to_cpu(mpt_entry->pd_flags);
>> +    /* The wrapper function will put the slave's id here */
>> +    if (mlx4_is_mfunc(dev))
>> +        pd_flags &= ~MLX4_MPT_PD_VF_MASK;
>> +    mpt_entry->pd_flags = cpu_to_be32((pd_flags &  ~MLX4_MPT_PD_MASK) |
>
> Here you protect against bad pd_flags (corrupted mpt_entry was given?)
> with & ~MLX4_MPT_PD_MASK, but you might hide the mpt_corruption by
> masking it... isn't it better to fail (internal error) in this case?
>
>> +                      (pdn & MLX4_MPT_PD_MASK)
>> +                      | MLX4_MPT_PD_FLAG_EN_INV);
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(mlx4_mr_hw_change_pd);
>> +
>> +int mlx4_mr_hw_change_access(struct mlx4_dev *dev,
>> +                 struct mlx4_mpt_entry *mpt_entry,
>> +                 u32 access)
>> +{
>> +    u32 flags = (be32_to_cpu(mpt_entry->flags) & ~MLX4_PERM_MASK) |
>> +            (access & MLX4_PERM_MASK);
>> +
>> +    mpt_entry->flags = cpu_to_be32(flags);
>
> Note that you don't update the mmr access flags no where. after you
> succeed query_mr will probably return the old permissions.
>
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(mlx4_mr_hw_change_access);
>> +
>>   static int mlx4_mr_alloc_reserved(struct mlx4_dev *dev, u32 mridx,
>> u32 pd,
>>                  u64 iova, u64 size, u32 access, int npages,
>>                  int page_shift, struct mlx4_mr *mr)
>> @@ -463,6 +588,41 @@ int mlx4_mr_free(struct mlx4_dev *dev, struct
>> mlx4_mr *mr)
>>   }
>>   EXPORT_SYMBOL_GPL(mlx4_mr_free);
>>
>> +void mlx4_mr_rereg_mem_cleanup(struct mlx4_dev *dev, struct mlx4_mr *mr)
>> +{
>> +    mlx4_mtt_cleanup(dev, &mr->mtt);
>> +}
>> +EXPORT_SYMBOL_GPL(mlx4_mr_rereg_mem_cleanup);
>> +
>> +int mlx4_mr_rereg_mem_write(struct mlx4_dev *dev, struct mlx4_mr *mr,
>> +                u64 iova, u64 size, int npages,
>> +                int page_shift, struct mlx4_mpt_entry *mpt_entry)
>> +{
>> +    int err;
>> +
>> +    mpt_entry->start       = cpu_to_be64(mr->iova);
>> +    mpt_entry->length      = cpu_to_be64(mr->size);
>
> You pass u64 iova, u64 size, but you don't use them...
> probably better to use them (and update the mmr after the change - at
> mlx4_ib)
>
>> +    mpt_entry->entity_size = cpu_to_be32(mr->mtt.page_shift);
>> +
>> +    err = mlx4_mtt_init(dev, npages, page_shift, &mr->mtt);
>> +    if (err)
>> +        return err;
>> +
>> +    if (mr->mtt.order < 0) {
>> +        mpt_entry->flags |= cpu_to_be32(MLX4_MPT_FLAG_PHYSICAL);
>> +        mpt_entry->mtt_addr = 0;
>> +    } else {
>> +        mpt_entry->mtt_addr = cpu_to_be64(mlx4_mtt_addr(dev,
>> +                          &mr->mtt));
>> +        if (mr->mtt.page_shift == 0)
>> +            mpt_entry->mtt_sz    = cpu_to_be32(1 << mr->mtt.order);
>> +    }
>> +    mr->enabled = MLX4_MPT_EN_SW;
>> +
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(mlx4_mr_rereg_mem_write);
>> +
>>   int mlx4_mr_enable(struct mlx4_dev *dev, struct mlx4_mr *mr)
>>   {
>>       struct mlx4_cmd_mailbox *mailbox;
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
>> b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
>> index 0efc136..1089367 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
>> @@ -2613,12 +2613,34 @@ int mlx4_QUERY_MPT_wrapper(struct mlx4_dev
>> *dev, int slave,
>>       if (err)
>>           return err;
>>
>> -    if (mpt->com.from_state != RES_MPT_HW) {
>> +    if (mpt->com.from_state == RES_MPT_MAPPED) {
>> +        /* In order to allow rereg in SRIOV, we need to alter the MPT
>> entry. To do
>> +         * that, the VF must read the MPT. But since the MPT entry
>> memory is not
>> +         * in the VF's virtual memory space, it must use QUERY_MPT to
>> obtain the
>> +         * entry contents. To guarantee that the MPT cannot be
>> changed, the driver
>> +         * must perform HW2SW_MPT before this query and return the
>> MPT entry to HW
>> +         * ownership fofollowing the change. The change here allows
>> the VF to
>> +         * perform QUERY_MPT also when the entry is in SW ownership.
>> +         */
>> +        struct mlx4_mpt_entry *mpt_entry = mlx4_table_find(
>> +                    &mlx4_priv(dev)->mr_table.dmpt_table,
>> +                    mpt->key, NULL);
>> +
>> +        if (NULL == mpt_entry || NULL == outbox->buf) {
>> +            err = -EINVAL;
>> +            goto out;
>> +        }
>> +
>> +        memcpy(outbox->buf, mpt_entry, sizeof(*mpt_entry));
>> +
>> +        err = 0;
>> +    } else if (mpt->com.from_state == RES_MPT_HW) {
>> +        err = mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
>> +    } else {
>>           err = -EBUSY;
>>           goto out;
>>       }
>>
>> -    err = mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
>>
>>   out:
>>       put_res(dev, slave, id, RES_MPT);
>> diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
>> index b12f4bb..a64c397 100644
>> --- a/include/linux/mlx4/device.h
>> +++ b/include/linux/mlx4/device.h
>> @@ -262,6 +262,7 @@ enum {
>>       MLX4_PERM_REMOTE_WRITE    = 1 << 13,
>>       MLX4_PERM_ATOMIC    = 1 << 14,
>>       MLX4_PERM_BIND_MW    = 1 << 15,
>> +    MLX4_PERM_MASK        = 0xFC00
>>   };
>>
>>   enum {
>> @@ -1243,4 +1244,19 @@ int mlx4_vf_smi_enabled(struct mlx4_dev *dev,
>> int slave, int port);
>>   int mlx4_vf_get_enable_smi_admin(struct mlx4_dev *dev, int slave,
>> int port);
>>   int mlx4_vf_set_enable_smi_admin(struct mlx4_dev *dev, int slave,
>> int port,
>>                    int enable);
>> +int mlx4_mr_hw_get_mpt(struct mlx4_dev *dev, struct mlx4_mr *mmr,
>> +               struct mlx4_mpt_entry ***mpt_entry);
>> +int mlx4_mr_hw_write_mpt(struct mlx4_dev *dev, struct mlx4_mr *mmr,
>> +             struct mlx4_mpt_entry **mpt_entry);
>> +int mlx4_mr_hw_change_pd(struct mlx4_dev *dev, struct mlx4_mpt_entry
>> *mpt_entry,
>> +             u32 pdn);
>> +int mlx4_mr_hw_change_access(struct mlx4_dev *dev,
>> +                 struct mlx4_mpt_entry *mpt_entry,
>> +                 u32 access);
>> +void mlx4_mr_hw_put_mpt(struct mlx4_dev *dev,
>> +            struct mlx4_mpt_entry **mpt_entry);
>> +void mlx4_mr_rereg_mem_cleanup(struct mlx4_dev *dev, struct mlx4_mr
>> *mr);
>> +int mlx4_mr_rereg_mem_write(struct mlx4_dev *dev, struct mlx4_mr *mr,
>> +                u64 iova, u64 size, int npages,
>> +                int page_shift, struct mlx4_mpt_entry *mpt_entry);
>>   #endif /* MLX4_DEVICE_H */
>>
>

Hi Sagi,

Thanks for the comments.
I'll look into that and fix/reply.

Thanks,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
