From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/6] RDMA/hns: Add rq inline data support for
 hip08 RoCE
Date: Tue, 26 Dec 2017 17:04:34 +0800
Message-ID: <4b1c015c-6f36-ce8e-3330-c7002c46989a@huawei.com>
References: <1514017342-91468-1-git-send-email-oulijun@huawei.com>
 <1514017342-91468-2-git-send-email-oulijun@huawei.com>
 <20171225093448.GZ2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171225093448.GZ2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2017/12/25 17:34, Leon Romanovsky 写道:
> On Sat, Dec 23, 2017 at 04:22:17PM +0800, Lijun Ou wrote:
>> This patch mainly implement rq inline data feature for hip08
>> RoCE in kernel mode.
>>
>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_device.h | 18 +++++++++
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 63 ++++++++++++++++++++++++++++-
>>  drivers/infiniband/hw/hns/hns_roce_qp.c     | 52 ++++++++++++++++++++----
>>  3 files changed, 125 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
>> index dcfd209..8d123d3 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
>> @@ -178,6 +178,7 @@ enum {
>>  enum {
>>  	HNS_ROCE_CAP_FLAG_REREG_MR		= BIT(0),
>>  	HNS_ROCE_CAP_FLAG_ROCE_V1_V2		= BIT(1),
>> +	HNS_ROCE_CAP_FLAG_RQ_INLINE		= BIT(2)
>>  };
>>
>>  enum hns_roce_mtt_type {
>> @@ -446,6 +447,21 @@ struct hns_roce_cmd_mailbox {
>>
>>  struct hns_roce_dev;
>>
>> +struct hns_roce_rinl_sge {
>> +	void			*addr;
>> +	u32			len;
>> +};
>> +
>> +struct hns_roce_rinl_wqe {
>> +	struct hns_roce_rinl_sge *sg_list;
>> +	u32			 sge_cnt;
>> +};
>> +
>> +struct hns_roce_rinl_buf {
>> +	struct hns_roce_rinl_wqe *wqe_list;
>> +	u32			 wqe_cnt;
>> +};
>> +
>>  struct hns_roce_qp {
>>  	struct ib_qp		ibqp;
>>  	struct hns_roce_buf	hr_buf;
>> @@ -477,6 +493,8 @@ struct hns_roce_qp {
>>
>>  	struct hns_roce_sge	sge;
>>  	u32			next_sge;
>> +
>> +	struct hns_roce_rinl_buf rq_inl_buf;
>>  };
>>
>>  struct hns_roce_sqp {
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> index 4d3e976..b17dcfa 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> @@ -299,6 +299,7 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
>>  	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
>>  	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
>>  	struct hns_roce_v2_wqe_data_seg *dseg;
>> +	struct hns_roce_rinl_sge *sge_list;
>>  	struct device *dev = hr_dev->dev;
>>  	struct hns_roce_v2_db rq_db;
>>  	unsigned long flags;
>> @@ -347,6 +348,14 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
>>  			dseg[i].addr = 0;
>>  		}
>>
>> +		/* rq support inline data */
>> +		sge_list = hr_qp->rq_inl_buf.wqe_list[ind].sg_list;
>> +		hr_qp->rq_inl_buf.wqe_list[ind].sge_cnt = (u32)wr->num_sge;
>> +		for (i = 0; i < wr->num_sge; i++) {
>> +			sge_list[i].addr = (void *)(u64)wr->sg_list[i].addr;
>> +			sge_list[i].len = wr->sg_list[i].length;
>> +		}
>> +
>>  		hr_qp->rq.wrid[ind] = wr->wr_id;
>>
>>  		ind = (ind + 1) & (hr_qp->rq.wqe_cnt - 1);
>> @@ -961,7 +970,8 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
>>  	caps->chunk_sz		= HNS_ROCE_V2_TABLE_CHUNK_SIZE;
>>
>>  	caps->flags		= HNS_ROCE_CAP_FLAG_REREG_MR |
>> -				  HNS_ROCE_CAP_FLAG_ROCE_V1_V2;
>> +				  HNS_ROCE_CAP_FLAG_ROCE_V1_V2 |
>> +				  HNS_ROCE_CAP_FLAG_RQ_INLINE;
>>  	caps->pkey_table_len[0] = 1;
>>  	caps->gid_table_len[0] = HNS_ROCE_V2_GID_INDEX_NUM;
>>  	caps->ceqe_depth	= HNS_ROCE_V2_COMP_EQE_NUM;
>> @@ -1476,6 +1486,7 @@ static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
>>  static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
>>  				struct hns_roce_qp **cur_qp, struct ib_wc *wc)
>>  {
>> +	struct hns_roce_rinl_sge *sge_list;
>>  	struct hns_roce_dev *hr_dev;
>>  	struct hns_roce_v2_cqe *cqe;
>>  	struct hns_roce_qp *hr_qp;
>> @@ -1673,6 +1684,46 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
>>  			break;
>>  		}
>>
>> +		if ((wc->qp->qp_type == IB_QPT_RC ||
>> +		     wc->qp->qp_type == IB_QPT_UC) &&
>> +		    (opcode == HNS_ROCE_V2_OPCODE_SEND ||
>> +		    opcode == HNS_ROCE_V2_OPCODE_SEND_WITH_IMM ||
>> +		    opcode == HNS_ROCE_V2_OPCODE_SEND_WITH_INV) &&
>> +		    (roce_get_bit(cqe->byte_4, V2_CQE_BYTE_4_RQ_INLINE_S))) {
> 
> It is better to put in separate function or inline function if you very worried about performance issues.
> 
Yes, I will refactor it as function.
>> +			u32 wr_num, wr_cnt, sge_num, sge_cnt;
>> +			u32 data_len, size;
>> +			u8 *wqe_buf;
>> +
>> +			wr_num = (u16)roce_get_field(cqe->byte_4,
>> +					V2_CQE_BYTE_4_WQE_INDX_M,
>> +					V2_CQE_BYTE_4_WQE_INDX_S) & 0xffff;
>> +			wr_cnt = wr_num & ((*cur_qp)->rq.wqe_cnt - 1);
>> +
>> +			sge_list =
>> +				(*cur_qp)->rq_inl_buf.wqe_list[wr_cnt].sg_list;
>> +			sge_num =
>> +				(*cur_qp)->rq_inl_buf.wqe_list[wr_cnt].sge_cnt;
> 
> Such level of indirection means that it is time to introduce temp variables.
> 
Maybe, it is ok after refactoring it.
>> +			wqe_buf = (u8 *)get_recv_wqe(*cur_qp, wr_cnt);
>> +			data_len = wc->byte_len;
>> +
>> +			for (sge_cnt = 0; (sge_cnt < sge_num) && (data_len);
>> +			     sge_cnt++) {
>> +				size = sge_list[sge_cnt].len < data_len ?
>> +				       sge_list[sge_cnt].len : data_len;
> 
> Use min(a, b) macro available in kernel headers.
yes, thanks.
> 
>> +
>> +				memcpy((void *)sge_list[sge_cnt].addr,
>> +					(void *)wqe_buf, size);
>> +
>> +				data_len -= size;
>> +				wqe_buf += size;
>> +			}
>> +
>> +			if (data_len) {
>> +				wc->status = IB_WC_LOC_LEN_ERR;
>> +				return -EAGAIN;
>> +			}
>> +		}
> 
> To be honest the whole new chunk is very strange, it has casting in
> almost every line and looks very suspicious. Can you clean the
> variables/function return values to avoid castings?
> 
>> +
>>  		/* Update tail pointer, record wr_id */
>>  		wq = &(*cur_qp)->rq;
>>  		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
>> @@ -1972,6 +2023,7 @@ static void modify_qp_reset_to_init(struct ib_qp *ibqp,
>>  		     !!(attr->qp_access_flags & IB_ACCESS_REMOTE_ATOMIC));
>>  	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_ATE_S, 0);
>>
>> +	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RQIE_S, 1);
>>  	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_RQIE_S, 0);
>>
>>  	roce_set_field(context->byte_80_rnr_rx_cqn, V2_QPC_BYTE_80_RX_CQN_M,
>> @@ -3114,6 +3166,15 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
>>  		hns_roce_buf_free(hr_dev, hr_qp->buff_size, &hr_qp->hr_buf);
>>  	}
>>
>> +	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE) {
>> +		if (hr_qp->rq_inl_buf.wqe_list) {
>> +			kfree(hr_qp->rq_inl_buf.wqe_list[0].sg_list);
>> +			kfree(hr_qp->rq_inl_buf.wqe_list);
>> +			hr_qp->rq_inl_buf.wqe_list[0].sg_list = NULL;
> 
> Did it work? You called to kfree the hr_qp->rq_inl_buf.wqe_list a line above?
> 
>> +			hr_qp->rq_inl_buf.wqe_list = NULL;
>> +		}
>> +	}
>> +
>>  	return 0;
>>  }
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
>> index 69e2584..7c75f21b 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_qp.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
>> @@ -494,6 +494,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>>  	int ret = 0;
>>  	u32 page_shift;
>>  	u32 npages;
>> +	int i;
>>
>>  	mutex_init(&hr_qp->mutex);
>>  	spin_lock_init(&hr_qp->sq.lock);
>> @@ -513,18 +514,42 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>>  		goto err_out;
>>  	}
>>
>> +	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE) {
>> +		/* allocate recv inline buf */
>> +		hr_qp->rq_inl_buf.wqe_list = kmalloc_array(hr_qp->rq.wqe_cnt,
>> +					       sizeof(struct hns_roce_rinl_wqe),
>> +					       GFP_KERNEL);
>> +		if (!hr_qp->rq_inl_buf.wqe_list)
>> +			goto err_out;
>> +
>> +		hr_qp->rq_inl_buf.wqe_cnt = hr_qp->rq.wqe_cnt;
>> +
>> +		hr_qp->rq_inl_buf.wqe_list[0].sg_list =
>> +				kmalloc_array(hr_qp->rq_inl_buf.wqe_cnt *
>> +					      init_attr->cap.max_recv_sge,
>> +					      sizeof(struct hns_roce_rinl_sge),
>> +					      GFP_KERNEL);
>> +		if (!hr_qp->rq_inl_buf.wqe_list[0].sg_list)
>> +			goto err_wqe_list;
>> +
>> +		for (i = 1; i < hr_qp->rq_inl_buf.wqe_cnt; i++)
>> +			hr_qp->rq_inl_buf.wqe_list[i].sg_list =
>> +				&hr_qp->rq_inl_buf.wqe_list[0].sg_list[i *
>> +				init_attr->cap.max_recv_sge];
>> +	}
> 
> I'm not an expert in this area of code, but the call to kmalloc_array on
> the first field of already kmalloc_array created pointer looks strange.
> 
> Don't know what you can do with that comment, maybe other reviewers can suggest.
> 
>> +
>>  	if (ib_pd->uobject) {
>>  		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
>>  			dev_err(dev, "ib_copy_from_udata error for create qp\n");
>>  			ret = -EFAULT;
>> -			goto err_out;
>> +			goto err_rq_sge_list;
>>  		}
>>
>>  		ret = hns_roce_set_user_sq_size(hr_dev, &init_attr->cap, hr_qp,
>>  						&ucmd);
>>  		if (ret) {
>>  			dev_err(dev, "hns_roce_set_user_sq_size error for create qp\n");
>> -			goto err_out;
>> +			goto err_rq_sge_list;
>>  		}
>>
>>  		hr_qp->umem = ib_umem_get(ib_pd->uobject->context,
>> @@ -533,7 +558,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>>  		if (IS_ERR(hr_qp->umem)) {
>>  			dev_err(dev, "ib_umem_get error for create qp\n");
>>  			ret = PTR_ERR(hr_qp->umem);
>> -			goto err_out;
>> +			goto err_rq_sge_list;
>>  		}
>>
>>  		hr_qp->mtt.mtt_type = MTT_TYPE_WQE;
>> @@ -567,13 +592,13 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>>  		    IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
>>  			dev_err(dev, "init_attr->create_flags error!\n");
>>  			ret = -EINVAL;
>> -			goto err_out;
>> +			goto err_rq_sge_list;
>>  		}
>>
>>  		if (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO) {
>>  			dev_err(dev, "init_attr->create_flags error!\n");
>>  			ret = -EINVAL;
>> -			goto err_out;
>> +			goto err_rq_sge_list;
>>  		}
>>
>>  		/* Set SQ size */
>> @@ -581,7 +606,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>>  						  hr_qp);
>>  		if (ret) {
>>  			dev_err(dev, "hns_roce_set_kernel_sq_size error!\n");
>> -			goto err_out;
>> +			goto err_rq_sge_list;
>>  		}
>>
>>  		/* QP doorbell register address */
>> @@ -597,7 +622,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>>  				       &hr_qp->hr_buf, page_shift)) {
>>  			dev_err(dev, "hns_roce_buf_alloc error!\n");
>>  			ret = -ENOMEM;
>> -			goto err_out;
>> +			goto err_rq_sge_list;
>>  		}
>>
>>  		hr_qp->mtt.mtt_type = MTT_TYPE_WQE;
>> @@ -679,6 +704,19 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>>  	else
>>  		hns_roce_buf_free(hr_dev, hr_qp->buff_size, &hr_qp->hr_buf);
>>
>> +err_rq_sge_list:
>> +	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE)
>> +		if (hr_qp->rq_inl_buf.wqe_list) {
>> +			kfree(hr_qp->rq_inl_buf.wqe_list[0].sg_list);
>> +			hr_qp->rq_inl_buf.wqe_list[0].sg_list = NULL;
> 
> IMHO, in general case, it is preferable to avoid setting NULL after kfree.
> 
>> +		}
>> +
>> +err_wqe_list:
>> +	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE) {
>> +		kfree(hr_qp->rq_inl_buf.wqe_list);
>> +		hr_qp->rq_inl_buf.wqe_list = NULL;
>> +	}
>> +
>>  err_out:
>>  	return ret;
>>  }
>> --
>> 1.9.1
>>
Thanks your reviewing. I will send the next patch for fix them.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
