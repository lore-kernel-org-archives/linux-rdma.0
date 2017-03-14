From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Fwd: mlx5_ib_post_send panic on s390x
Date: Tue, 14 Mar 2017 16:02:17 +0100
Message-ID: <04049739-a008-f7c7-4f7a-30616fbf787a@linux.vnet.ibm.com>
References: <56246ac0-a706-291c-7baa-a6dd2c6331cd@linux.vnet.ibm.com>
 <dcc90daa-b932-8957-d8bc-e1f02d04e03a@linux.vnet.ibm.com>
 <20e4f31e-b2a7-89fb-d4c0-583c0dc1efb6@mellanox.com>
 <491cf3e1-b2f8-3695-ecd4-3d34b0ae9e25@linux.vnet.ibm.com>
 <AM4PR0501MB278723F1BF4DA9846C664C62C52C0@AM4PR0501MB2787.eurprd05.prod.outlook.com>
 <e57691e1-55bc-308a-fc91-0a8072218dd5@linux.vnet.ibm.com>
 <VI1PR0502MB300817FC6256218DE800497BD1220@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB300817FC6256218DE800497BD1220-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Parav,

I tried your mlx4-patch together with SMC on s390x, but it failed.
The SMC-R code tries to send 44 bytes as inline in 1 sge.
I wonder about a length check with 16 bytes, which probably explains the failure.
See my question below in the patch:

On 03/12/2017 09:20 PM, Parav Pandit wrote:
> Hi Ursula,
> 
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ursula Braun
>> Sent: Thursday, March 9, 2017 3:54 AM
>> To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon Romanovsky
>> <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: Fwd: mlx5_ib_post_send panic on s390x
>>
>>
>>
>> On 03/06/2017 02:08 PM, Eli Cohen wrote:
>>>>>
>>>>> The problem seems to be caused by the usage of plain memcpy in
>> set_data_inl_seg().
>>>>> The address provided by SMC-code in struct ib_send_wr *wr is an
>>>>> address belonging to an area mapped with the ib_dma_map_single()
>>>>> call. On s390x those kind of addresses require extra access functions (see
>> arch/s390/include/asm/io.h).
>>>>>
>>>
>>> By definition, when you are posting a send request with inline, the address
>> must be mapped to the cpu so plain memcpy should work.
>>>
>> In the past I run SMC-R with Connect X3 cards. The mlx4 driver does not seem to
>> contain extra coding for IB_SEND_INLINE flag for ib_post_send. Does this mean
>> for SMC-R to run on Connect X3 cards the IB_SEND_INLINE flag is ignored, and
>> thus I needed the ib_dma_map_single() call for the area used with
>> ib_post_send()? Does this mean I should stay away from the IB_SEND_INLINE
>> flag, if I want to run the same SMC-R code with both, Connect X3 cards and
>> Connect X4 cards?
>>
> I had encountered the same kernel panic that you mentioned last week on ConnectX-4 adapters with smc-r on x86_64.
> Shall I submit below fix to netdev mailing list?
> I have tested above change. I also have optimization that avoids dma mapping for wr_tx_dma_addr.
> 
> -               lnk->wr_tx_sges[i].addr =
> -                       lnk->wr_tx_dma_addr + i * SMC_WR_BUF_SIZE;
> +               lnk->wr_tx_sges[i].addr = (uintptr_t)(lnk->wr_tx_bufs + i);
> 
> I also have fix for processing IB_SEND_INLINE in mlx4 driver on little older kernel base.
> I have attached below. I can rebase my kernel and provide fix in mlx5_ib driver.
> Let me know.
> 
> Regards,
> Parav Pandit
> 
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index a2e4ca5..0d984f5 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -2748,6 +2748,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  	unsigned long flags;
>  	int nreq;
>  	int err = 0;
> +	int inl = 0;
>  	unsigned ind;
>  	int uninitialized_var(stamp);
>  	int uninitialized_var(size);
> @@ -2958,30 +2959,97 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  		default:
>  			break;
>  		}
> +		if (wr->send_flags & IB_SEND_INLINE && wr->num_sge) {
> +			struct mlx4_wqe_inline_seg *seg;
> +			void *addr;
> +			int len, seg_len;
> +			int num_seg;
> +			int off, to_copy;
> +
> +			inl = 0;
> +
> +			seg = wqe;
> +			wqe += sizeof *seg;
> +			off = ((uintptr_t) wqe) & (MLX4_INLINE_ALIGN - 1);
> +			num_seg = 0;
> +			seg_len = 0;
> +
> +			for (i = 0; i < wr->num_sge; ++i) {
> +				addr = (void *) (uintptr_t) wr->sg_list[i].addr;
> +				len  = wr->sg_list[i].length;
> +				inl += len;
> +
> +				if (inl > 16) {
> +					inl = 0;
> +					err = ENOMEM;
> +					*bad_wr = wr;
> +					goto out;
> +				}
SMC-R fails due to this check. inl is 44 here. Why is 16 a limit for IB_SEND_INLINE data?
The SMC-R code calls ib_create_qp() with max_inline_data=44. And the function does not
seem to return an error.
>  
> -		/*
> -		 * Write data segments in reverse order, so as to
> -		 * overwrite cacheline stamp last within each
> -		 * cacheline.  This avoids issues with WQE
> -		 * prefetching.
> -		 */
> +				while (len >= MLX4_INLINE_ALIGN - off) {
> +					to_copy = MLX4_INLINE_ALIGN - off;
> +					memcpy(wqe, addr, to_copy);
> +					len -= to_copy;
> +					wqe += to_copy;
> +					addr += to_copy;
> +					seg_len += to_copy;
> +					wmb(); /* see comment below */
> +					seg->byte_count = htonl(MLX4_INLINE_SEG | seg_len);
> +					seg_len = 0;
> +					seg = wqe;
> +					wqe += sizeof *seg;
> +					off = sizeof *seg;
> +					++num_seg;
> +				}
>  
> -		dseg = wqe;
> -		dseg += wr->num_sge - 1;
> -		size += wr->num_sge * (sizeof (struct mlx4_wqe_data_seg) / 16);
> +				memcpy(wqe, addr, len);
> +				wqe += len;
> +				seg_len += len;
> +				off += len;
> +			}
>  
> -		/* Add one more inline data segment for ICRC for MLX sends */
> -		if (unlikely(qp->mlx4_ib_qp_type == MLX4_IB_QPT_SMI ||
> -			     qp->mlx4_ib_qp_type == MLX4_IB_QPT_GSI ||
> -			     qp->mlx4_ib_qp_type &
> -			     (MLX4_IB_QPT_PROXY_SMI_OWNER | MLX4_IB_QPT_TUN_SMI_OWNER))) {
> -			set_mlx_icrc_seg(dseg + 1);
> -			size += sizeof (struct mlx4_wqe_data_seg) / 16;
> -		}
> +			if (seg_len) {
> +				++num_seg;
> +				/*
> +				 * Need a barrier here to make sure
> +				 * all the data is visible before the
> +				 * byte_count field is set.  Otherwise
> +				 * the HCA prefetcher could grab the
> +				 * 64-byte chunk with this inline
> +				 * segment and get a valid (!=
> +				 * 0xffffffff) byte count but stale
> +				 * data, and end up sending the wrong
> +				 * data.
> +				 */
> +				wmb();
> +				seg->byte_count = htonl(MLX4_INLINE_SEG | seg_len);
> +			}
>  
> -		for (i = wr->num_sge - 1; i >= 0; --i, --dseg)
> -			set_data_seg(dseg, wr->sg_list + i);
> +			size += (inl + num_seg * sizeof (*seg) + 15) / 16;
> +		} else {
> +			/*
> +			 * Write data segments in reverse order, so as to
> +			 * overwrite cacheline stamp last within each
> +			 * cacheline.  This avoids issues with WQE
> +			 * prefetching.
> +			 */
> +
> +			dseg = wqe;
> +			dseg += wr->num_sge - 1;
> +			size += wr->num_sge * (sizeof (struct mlx4_wqe_data_seg) / 16);
> +
> +			/* Add one more inline data segment for ICRC for MLX sends */
> +			if (unlikely(qp->mlx4_ib_qp_type == MLX4_IB_QPT_SMI ||
> +				     qp->mlx4_ib_qp_type == MLX4_IB_QPT_GSI ||
> +				     qp->mlx4_ib_qp_type &
> +				     (MLX4_IB_QPT_PROXY_SMI_OWNER | MLX4_IB_QPT_TUN_SMI_OWNER))) {
> +				set_mlx_icrc_seg(dseg + 1);
> +				size += sizeof (struct mlx4_wqe_data_seg) / 16;
> +			}
>  
> +			for (i = wr->num_sge - 1; i >= 0; --i, --dseg)
> +				set_data_seg(dseg, wr->sg_list + i);
> +		}
>  		/*
>  		 * Possibly overwrite stamping in cacheline with LSO
>  		 * segment only after making sure all data segments
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
>> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
