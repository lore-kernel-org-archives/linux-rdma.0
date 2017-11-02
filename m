From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and
 immediate
Date: Thu, 2 Nov 2017 14:03:18 +0800
Message-ID: <8dbc8305-f154-3b8c-795a-b5f1a6b53c73@huawei.com>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-4-git-send-email-oulijun@huawei.com>
 <20171101161328.GB7815@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------F6575EC7DE6F599522979D78"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101161328.GB7815-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--------------F6575EC7DE6F599522979D78
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit

ÔÚ 2017/11/2 0:13, Jason Gunthorpe Ð´µÀ:
> On Wed, Nov 01, 2017 at 06:00:40PM +0800, Lijun Ou wrote:
>> @@ -385,7 +385,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
>>  		case HNS_ROCE_RECV_OP_RDMA_WRITE_IMM:
>>  			wc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
>>  			wc->wc_flags = IBV_WC_WITH_IMM;
>> -			wc->imm_data = cqe->rkey_immtdata;
>> +			wc->imm_data = be32toh(cqe->rkey_immtdata);
>>  			break;
> 
> This can't be right, wc->imm_data is marked be32.
> 
> Be aware, getting the swapping correct here is an interoperability
> issue. You should test your device aginst soft roce or mellanox
> hardware to ensure that the immediate data is being transfered
> properly. verbs is setup to require no swap if the hardware DMA's the
> immediate data byte for byte into the CQE.
> 
> You need to make hns sparse clean. You can run sparse by installing
> the tool and then doing:
> 
>  mkdr build-sparse
>  cd build-sparse
>  CC=cgcc cmake -GNinja ..
>  ninja
> 
I have run the sparse successful and don't understand the result.

>  # See only the warnings from hns:
>  rm ./providers/hns/CMakeFiles/hns-rdmav16.dir/*.o
>  ninja
> 
> The basic result should look something like below which you can use as
> a starting point. I made some guesses, eg assuming hns does DMA in little
> endian:
> 
>>From 7056eb6b40e0ee5d44960edfb2e1bd67d74caaee Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe-uk2M96/98Pc@public.gmane.org>
> Date: Wed, 1 Nov 2017 10:08:06 -0600
> Subject: [PATCH] hns: Make the provider sparse clean
> 
> Assuming the provider works as-is, and runs on a little endian ARM,
> revise the annotations to indicate that the HW uses little endian
> data in the various DMA buffers, and flow the necessary swaps throughout.
> 
> The htole/letoh swaps are no-op for this platform, which makes the only
> substantive change the handling of imm_data which is now mandatory
> swapped.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-uk2M96/98Pc@public.gmane.org>
> ---
>  CMakeLists.txt                   |   2 +-
>  providers/hns/hns_roce_u.h       |   8 +--
>  providers/hns/hns_roce_u_hw_v1.c |  61 ++++++++++-----------
>  providers/hns/hns_roce_u_hw_v1.h | 114 +++++++++++++++++++--------------------
>  providers/hns/hns_roce_u_hw_v2.c |  37 ++++++-------
>  providers/hns/hns_roce_u_hw_v2.h |  50 ++++++++---------
>  6 files changed, 137 insertions(+), 135 deletions(-)
> 
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 5e6f245a563ee4..2dbaaa92ea168f 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -433,7 +433,7 @@ if (HAVE_COHERENT_DMA)
>  add_subdirectory(providers/bnxt_re)
>  add_subdirectory(providers/cxgb3) # NO SPARSE
>  add_subdirectory(providers/cxgb4) # NO SPARSE
> -add_subdirectory(providers/hns) # NO SPARSE
> +add_subdirectory(providers/hns)
>  add_subdirectory(providers/i40iw) # NO SPARSE
>  add_subdirectory(providers/mlx4)
>  add_subdirectory(providers/mlx4/man)
> diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
> index ea645be720f8d4..5ab756ce7dac25 100644
> --- a/providers/hns/hns_roce_u.h
> +++ b/providers/hns/hns_roce_u.h
> @@ -54,16 +54,16 @@
>  
>  #define PFX				"hns: "
>  
> -#define roce_get_field(origin, mask, shift) \
> -	(((origin) & (mask)) >> (shift))
> +#define roce_get_field(origin, mask, shift)                                    \
> +	(((le32toh(origin)) & (mask)) >> (shift))
>  
>  #define roce_get_bit(origin, shift) \
>  	roce_get_field((origin), (1ul << (shift)), (shift))
>  
>  #define roce_set_field(origin, mask, shift, val) \
>  	do { \
> -		(origin) &= (~(mask)); \
> -		(origin) |= (((unsigned int)(val) << (shift)) & (mask)); \
> +		(origin) &= ~htole32(mask); \
> +		(origin) |= htole32(((unsigned int)(val) << (shift)) & (mask)); \
>  	} while (0)
>  
>  #define roce_set_bit(origin, shift, val) \
> diff --git a/providers/hns/hns_roce_u_hw_v1.c b/providers/hns/hns_roce_u_hw_v1.c
> index 482eac90df2183..2ea46b38a61071 100644
> --- a/providers/hns/hns_roce_u_hw_v1.c
> +++ b/providers/hns/hns_roce_u_hw_v1.c
> @@ -40,17 +40,17 @@
>  static inline void set_raddr_seg(struct hns_roce_wqe_raddr_seg *rseg,
>  				 uint64_t remote_addr, uint32_t rkey)
>  {
> -	rseg->raddr    = remote_addr;
> -	rseg->rkey     = rkey;
> +	rseg->raddr    = htole64(remote_addr);
> +	rseg->rkey     = htole32(rkey);
>  	rseg->len      = 0;
>  }
>  
>  static void set_data_seg(struct hns_roce_wqe_data_seg *dseg, struct ibv_sge *sg)
>  {
>  
> -	dseg->lkey = sg->lkey;
> -	dseg->addr = sg->addr;
> -	dseg->len = sg->length;
> +	dseg->lkey = htole32(sg->lkey);
> +	dseg->addr = htole64(sg->addr);
> +	dseg->len = htole32(sg->length);
>  }
>  
>  static void hns_roce_update_rq_head(struct hns_roce_context *ctx,
> @@ -337,13 +337,13 @@ static int hns_roce_v1_poll_one(struct hns_roce_cq *cq,
>  			 get_send_wqe(*cur_qp, roce_get_field(cqe->cqe_byte_4,
>  						CQE_BYTE_4_WQE_INDEX_M,
>  						CQE_BYTE_4_WQE_INDEX_S));
> -		switch (sq_wqe->flag & HNS_ROCE_WQE_OPCODE_MASK) {
> +		switch (le32toh(sq_wqe->flag) & HNS_ROCE_WQE_OPCODE_MASK) {
>  		case HNS_ROCE_WQE_OPCODE_SEND:
>  			wc->opcode = IBV_WC_SEND;
>  			break;
>  		case HNS_ROCE_WQE_OPCODE_RDMA_READ:
>  			wc->opcode = IBV_WC_RDMA_READ;
> -			wc->byte_len = cqe->byte_cnt;
> +			wc->byte_len = le32toh(cqe->byte_cnt);
>  			break;
>  		case HNS_ROCE_WQE_OPCODE_RDMA_WRITE:
>  			wc->opcode = IBV_WC_RDMA_WRITE;
> @@ -355,11 +355,12 @@ static int hns_roce_v1_poll_one(struct hns_roce_cq *cq,
>  			wc->status = IBV_WC_GENERAL_ERR;
>  			break;
>  		}
> -		wc->wc_flags = (sq_wqe->flag & HNS_ROCE_WQE_IMM ?
> -				IBV_WC_WITH_IMM : 0);
> +		wc->wc_flags =
> +		    (le32toh(sq_wqe->flag) & HNS_ROCE_WQE_IMM ? IBV_WC_WITH_IMM
> +							      : 0);
>  	} else {
>  		/* Get opcode and flag in rq&srq */
> -		wc->byte_len = (cqe->byte_cnt);
> +		wc->byte_len = le32toh(cqe->byte_cnt);
>  
>  		switch (roce_get_field(cqe->cqe_byte_4,
>  				       CQE_BYTE_4_OPERATION_TYPE_M,
> @@ -368,14 +369,14 @@ static int hns_roce_v1_poll_one(struct hns_roce_cq *cq,
>  		case HNS_ROCE_OPCODE_RDMA_WITH_IMM_RECEIVE:
>  			wc->opcode   = IBV_WC_RECV_RDMA_WITH_IMM;
>  			wc->wc_flags = IBV_WC_WITH_IMM;
> -			wc->imm_data = cqe->immediate_data;
> +			wc->imm_data = htobe32(le32toh(cqe->immediate_data));
>  			break;
>  		case HNS_ROCE_OPCODE_SEND_DATA_RECEIVE:
>  			if (roce_get_bit(cqe->cqe_byte_4,
>  					 CQE_BYTE_4_IMMEDIATE_DATA_FLAG_S)) {
>  				wc->opcode   = IBV_WC_RECV;
>  				wc->wc_flags = IBV_WC_WITH_IMM;
> -				wc->imm_data = cqe->immediate_data;
> +				wc->imm_data = htobe32(le32toh(cqe->immediate_data));
>  			} else {
>  				wc->opcode   = IBV_WC_RECV;
>  				wc->wc_flags = 0;
> @@ -497,10 +498,10 @@ static int hns_roce_u_v1_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  
>  		qp->sq.wrid[ind & (qp->sq.wqe_cnt - 1)] = wr->wr_id;
>  		for (i = 0; i < wr->num_sge; i++)
> -			ctrl->msg_length += wr->sg_list[i].length;
> +			ctrl->msg_length = htole32(le32toh(ctrl->msg_length) +
> +						   wr->sg_list[i].length);
>  
> -
> -		ctrl->flag |= ((wr->send_flags & IBV_SEND_SIGNALED) ?
> +		ctrl->flag |= htole32(((wr->send_flags & IBV_SEND_SIGNALED) ?
>  				HNS_ROCE_WQE_CQ_NOTIFY : 0) |
>  			      (wr->send_flags & IBV_SEND_SOLICITED ?
>  				HNS_ROCE_WQE_SE : 0) |
> @@ -508,11 +509,11 @@ static int hns_roce_u_v1_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  			       wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM) ?
>  				HNS_ROCE_WQE_IMM : 0) |
>  			      (wr->send_flags & IBV_SEND_FENCE ?
> -				HNS_ROCE_WQE_FENCE : 0);
> +			       HNS_ROCE_WQE_FENCE : 0));
>  
>  		if (wr->opcode == IBV_WR_SEND_WITH_IMM ||
>  		    wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM)
> -			ctrl->imm_data = wr->imm_data;
> +			ctrl->imm_data = htole32(be32toh(wr->imm_data));
>  
>  		wqe += sizeof(struct hns_roce_wqe_ctrl_seg);
>  
> @@ -541,7 +542,7 @@ static int hns_roce_u_v1_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  				ps_opcode = HNS_ROCE_WQE_OPCODE_MASK;
>  				break;
>  			}
> -			ctrl->flag |= (ps_opcode);
> +			ctrl->flag |= htole32(ps_opcode);
>  			wqe  += sizeof(struct hns_roce_wqe_raddr_seg);
>  			break;
>  		case IBV_QPT_UC:
> @@ -554,7 +555,7 @@ static int hns_roce_u_v1_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  
>  		/* Inline */
>  		if (wr->send_flags & IBV_SEND_INLINE && wr->num_sge) {
> -			if (ctrl->msg_length > qp->max_inline_data) {
> +			if (le32toh(ctrl->msg_length) > qp->max_inline_data) {
>  				ret = -1;
>  				*bad_wr = wr;
>  				printf("inline data len(1-32)=%d, send_flags = 0x%x, check failed!\r\n",
> @@ -569,13 +570,13 @@ static int hns_roce_u_v1_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  				wqe = wqe + wr->sg_list[i].length;
>  			}
>  
> -			ctrl->flag |= HNS_ROCE_WQE_INLINE;
> +			ctrl->flag |= htole32(HNS_ROCE_WQE_INLINE);
>  		} else {
>  			/* set sge */
>  			for (i = 0; i < wr->num_sge; i++)
>  				set_data_seg(dseg+i, wr->sg_list + i);
>  
> -			ctrl->flag |= wr->num_sge << HNS_ROCE_WQE_SGE_NUM_BIT;
> +			ctrl->flag |= htole32(wr->num_sge << HNS_ROCE_WQE_SGE_NUM_BIT);
>  		}
>  
>  		ind++;
> @@ -783,15 +784,15 @@ static int hns_roce_u_v1_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
>  				       HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM);
>  			sg = wr->sg_list;
>  
> -			rq_wqe->va0 = (sg->addr);
> -			rq_wqe->l_key0 = (sg->lkey);
> -			rq_wqe->length0 = (sg->length);
> +			rq_wqe->va0 = htole64(sg->addr);
> +			rq_wqe->l_key0 = htole32(sg->lkey);
> +			rq_wqe->length0 = htole32(sg->length);
>  
>  			sg = wr->sg_list + 1;
>  
> -			rq_wqe->va1 = (sg->addr);
> -			rq_wqe->l_key1 = (sg->lkey);
> -			rq_wqe->length1 = (sg->length);
> +			rq_wqe->va1 = htole64(sg->addr);
> +			rq_wqe->l_key1 = htole32(sg->lkey);
> +			rq_wqe->length1 = htole32(sg->length);
>  		} else if (wr->num_sge == HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM - 1) {
>  			roce_set_field(rq_wqe->u32_2,
>  				       RC_RQ_WQE_NUMBER_OF_DATA_SEG_M,
> @@ -799,9 +800,9 @@ static int hns_roce_u_v1_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
>  				       HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM - 1);
>  			sg = wr->sg_list;
>  
> -			rq_wqe->va0 = (sg->addr);
> -			rq_wqe->l_key0 = (sg->lkey);
> -			rq_wqe->length0 = (sg->length);
> +			rq_wqe->va0 = htole64(sg->addr);
> +			rq_wqe->l_key0 = htole32(sg->lkey);
> +			rq_wqe->length0 = htole32(sg->length);
>  
>  		} else if (wr->num_sge == HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM - 2) {
>  			roce_set_field(rq_wqe->u32_2,
> diff --git a/providers/hns/hns_roce_u_hw_v1.h b/providers/hns/hns_roce_u_hw_v1.h
> index 5ba34372c7fb9f..de5fe2d64e25f5 100644
> --- a/providers/hns/hns_roce_u_hw_v1.h
> +++ b/providers/hns/hns_roce_u_hw_v1.h
> @@ -59,22 +59,22 @@ enum {
>  };
>  
>  struct hns_roce_wqe_ctrl_seg {
> -	__be32		sgl_pa_h;
> -	__be32		flag;
> -	__be32		imm_data;
> -	__be32		msg_length;
> +	__le32		sgl_pa_h;
> +	__le32		flag;
> +	__le32		imm_data;
> +	__le32		msg_length;
>  };
>  
>  struct hns_roce_wqe_data_seg {
> -	__be64		addr;
> -	__be32		lkey;
> -	__be32		len;
> +	__le64		addr;
> +	__le32		lkey;
> +	__le32		len;
>  };
>  
>  struct hns_roce_wqe_raddr_seg {
> -	__be32		rkey;
> -	__be32		len;
> -	__be64		raddr;
> +	__le32		rkey;
> +	__le32		len;
> +	__le64		raddr;
>  };
>  
>  enum {
> @@ -106,8 +106,8 @@ enum {
>  };
>  
>  struct hns_roce_cq_db {
> -	unsigned int u32_4;
> -	unsigned int u32_8;
> +	__le32 u32_4;
> +	__le32 u32_8;
>  };
>  #define CQ_DB_U32_4_CONS_IDX_S 0
>  #define CQ_DB_U32_4_CONS_IDX_M   (((1UL << 16) - 1) << CQ_DB_U32_4_CONS_IDX_S)
> @@ -126,8 +126,8 @@ struct hns_roce_cq_db {
>  #define CQ_DB_U32_8_HW_SYNC_S 31
>  
>  struct hns_roce_rq_db {
> -	unsigned int u32_4;
> -	unsigned int u32_8;
> +	__le32 u32_4;
> +	__le32 u32_8;
>  };
>  
>  #define RQ_DB_U32_4_RQ_HEAD_S 0
> @@ -142,8 +142,8 @@ struct hns_roce_rq_db {
>  #define RQ_DB_U32_8_HW_SYNC_S 31
>  
>  struct hns_roce_sq_db {
> -	unsigned int u32_4;
> -	unsigned int u32_8;
> +	__le32 u32_4;
> +	__le32 u32_8;
>  };
>  
>  #define SQ_DB_U32_4_SQ_HEAD_S 0
> @@ -163,17 +163,17 @@ struct hns_roce_sq_db {
>  #define SQ_DB_U32_8_HW_SYNC 31
>  
>  struct hns_roce_cqe {
> -	unsigned int cqe_byte_4;
> +	__le32 cqe_byte_4;
>  	union {
> -		unsigned int r_key;
> -		unsigned int immediate_data;
> +		__le32 r_key;
> +		__le32 immediate_data;
>  	};
> -	unsigned int byte_cnt;
> -	unsigned int cqe_byte_16;
> -	unsigned int cqe_byte_20;
> -	unsigned int s_mac_l;
> -	unsigned int cqe_byte_28;
> -	unsigned int reserved;
> +	__le32 byte_cnt;
> +	__le32 cqe_byte_16;
> +	__le32 cqe_byte_20;
> +	__le32 s_mac_l;
> +	__le32 cqe_byte_28;
> +	__le32 reserved;
>  };
>  #define CQE_BYTE_4_OPERATION_TYPE_S 0
>  #define CQE_BYTE_4_OPERATION_TYPE_M   \
> @@ -200,43 +200,43 @@ struct hns_roce_cqe {
>  #define ROCEE_DB_OTHERS_L_0_REG				0x238
>  
>  struct hns_roce_rc_send_wqe {
> -	unsigned int sgl_ba_31_0;
> -	unsigned int u32_1;
> +	__le32 sgl_ba_31_0;
> +	__le32 u32_1;
>  	union {
> -		unsigned int r_key;
> -		unsigned int immediate_data;
> +		__le32 r_key;
> +		__le32 immediate_data;
>  	};
> -	unsigned int msg_length;
> -	unsigned int rvd_3;
> -	unsigned int rvd_4;
> -	unsigned int rvd_5;
> -	unsigned int rvd_6;
> -	uint64_t     va0;
> -	unsigned int l_key0;
> -	unsigned int length0;
> -
> -	uint64_t     va1;
> -	unsigned int l_key1;
> -	unsigned int length1;
> +	__le32 msg_length;
> +	__le32 rvd_3;
> +	__le32 rvd_4;
> +	__le32 rvd_5;
> +	__le32 rvd_6;
> +	__le64     va0;
> +	__le32 l_key0;
> +	__le32 length0;
> +
> +	__le64     va1;
> +	__le32 l_key1;
> +	__le32 length1;
>  };
>  
>  struct hns_roce_rc_rq_wqe {
> -	unsigned int u32_0;
> -	unsigned int sgl_ba_31_0;
> -	unsigned int u32_2;
> -	unsigned int rvd_5;
> -	unsigned int rvd_6;
> -	unsigned int rvd_7;
> -	unsigned int rvd_8;
> -	unsigned int rvd_9;
> -
> -	uint64_t     va0;
> -	unsigned int l_key0;
> -	unsigned int length0;
> -
> -	uint64_t     va1;
> -	unsigned int l_key1;
> -	unsigned int length1;
> +	__le32 u32_0;
> +	__le32 sgl_ba_31_0;
> +	__le32 u32_2;
> +	__le32 rvd_5;
> +	__le32 rvd_6;
> +	__le32 rvd_7;
> +	__le32 rvd_8;
> +	__le32 rvd_9;
> +
> +	__le64     va0;
> +	__le32 l_key0;
> +	__le32 length0;
> +
> +	__le64     va1;
> +	__le32 l_key1;
> +	__le32 length1;
>  };
>  #define RC_RQ_WQE_NUMBER_OF_DATA_SEG_S 16
>  #define RC_RQ_WQE_NUMBER_OF_DATA_SEG_M \
> diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
> index 50059bfea4aa40..48bd3de63df8a0 100644
> --- a/providers/hns/hns_roce_u_hw_v2.c
> +++ b/providers/hns/hns_roce_u_hw_v2.c
> @@ -40,9 +40,9 @@
>  static void set_data_seg_v2(struct hns_roce_v2_wqe_data_seg *dseg,
>  			 struct ibv_sge *sg)
>  {
> -	dseg->lkey = sg->lkey;
> -	dseg->addr = sg->addr;
> -	dseg->len = sg->length;
> +	dseg->lkey = htole32(sg->lkey);
> +	dseg->addr = htole64(sg->addr);
> +	dseg->len = htole32(sg->length);
>  }
>  
>  static void hns_roce_v2_handle_error_cqe(struct hns_roce_v2_cqe *cqe,
> @@ -341,7 +341,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
>  
>  		case HNS_ROCE_SQ_OP_RDMA_READ:
>  			wc->opcode = IBV_WC_RDMA_READ;
> -			wc->byte_len = cqe->byte_cnt;
> +			wc->byte_len = le32toh(cqe->byte_cnt);
>  			wc->wc_flags = 0;
>  			break;
>  
> @@ -379,13 +379,13 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
>  		}
>  	} else {
>  		/* Get opcode and flag in rq&srq */
> -		wc->byte_len = cqe->byte_cnt;
> +		wc->byte_len = le32toh(cqe->byte_cnt);
>  		switch (roce_get_field(cqe->byte_4, CQE_BYTE_4_OPCODE_M,
>  			CQE_BYTE_4_OPCODE_S) & HNS_ROCE_V2_CQE_OPCODE_MASK) {
>  		case HNS_ROCE_RECV_OP_RDMA_WRITE_IMM:
>  			wc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
>  			wc->wc_flags = IBV_WC_WITH_IMM;
> -			wc->imm_data = cqe->rkey_immtdata;
> +			wc->imm_data = htobe32(le32toh(cqe->rkey_immtdata));
>  			break;
>  
>  		case HNS_ROCE_RECV_OP_SEND:
> @@ -396,13 +396,13 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
>  		case HNS_ROCE_RECV_OP_SEND_WITH_IMM:
>  			wc->opcode = IBV_WC_RECV;
>  			wc->wc_flags = IBV_WC_WITH_IMM;
> -			wc->imm_data = cqe->rkey_immtdata;
> +			wc->imm_data = htobe32(le32toh(cqe->rkey_immtdata));
>  			break;
>  
>  		case HNS_ROCE_RECV_OP_SEND_WITH_INV:
>  			wc->opcode = IBV_WC_RECV;
>  			wc->wc_flags = IBV_WC_WITH_INV;
> -			wc->imm_data = cqe->rkey_immtdata;
> +			wc->invalidated_rkey = le32toh(cqe->rkey_immtdata);
>  			break;
>  		default:
>  			wc->status = IBV_WC_GENERAL_ERR;
> @@ -517,11 +517,12 @@ static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  
>  		qp->sq.wrid[ind & (qp->sq.wqe_cnt - 1)] = wr->wr_id;
>  		for (i = 0; i < wr->num_sge; i++)
> -			rc_sq_wqe->msg_len += wr->sg_list[i].length;
> +			rc_sq_wqe->msg_len = htole32(le32toh(rc_sq_wqe->msg_len) +
> +						     wr->sg_list[i].length);
>  
>  		if (wr->opcode == IBV_WR_SEND_WITH_IMM ||
>  		    wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM)
> -			rc_sq_wqe->inv_key_immtdata = wr->imm_data;
> +			rc_sq_wqe->inv_key_immtdata = htole32(be32toh(wr->imm_data));
>  
>  		roce_set_field(rc_sq_wqe->byte_16, RC_SQ_WQE_BYTE_16_SGE_NUM_M,
>  			       RC_SQ_WQE_BYTE_16_SGE_NUM_S, wr->num_sge);
> @@ -552,8 +553,8 @@ static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  					       RC_SQ_WQE_BYTE_4_OPCODE_M,
>  					       RC_SQ_WQE_BYTE_4_OPCODE_S,
>  					       HNS_ROCE_WQE_OP_RDMA_READ);
> -				rc_sq_wqe->va = wr->wr.rdma.remote_addr;
> -				rc_sq_wqe->rkey = wr->wr.rdma.rkey;
> +				rc_sq_wqe->va = htole64(wr->wr.rdma.remote_addr);
> +				rc_sq_wqe->rkey = htole32(wr->wr.rdma.rkey);
>  				break;
>  
>  			case IBV_WR_RDMA_WRITE:
> @@ -561,8 +562,8 @@ static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  					       RC_SQ_WQE_BYTE_4_OPCODE_M,
>  					       RC_SQ_WQE_BYTE_4_OPCODE_S,
>  					       HNS_ROCE_WQE_OP_RDMA_WRITE);
> -				rc_sq_wqe->va = wr->wr.rdma.remote_addr;
> -				rc_sq_wqe->rkey = wr->wr.rdma.rkey;
> +				rc_sq_wqe->va = htole64(wr->wr.rdma.remote_addr);
> +				rc_sq_wqe->rkey = htole32(wr->wr.rdma.rkey);
>  				break;
>  
>  			case IBV_WR_RDMA_WRITE_WITH_IMM:
> @@ -570,8 +571,8 @@ static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  				       RC_SQ_WQE_BYTE_4_OPCODE_M,
>  				       RC_SQ_WQE_BYTE_4_OPCODE_S,
>  				       HNS_ROCE_WQE_OP_RDMA_WRITE_WITH_IMM);
> -				rc_sq_wqe->va = wr->wr.rdma.remote_addr;
> -				rc_sq_wqe->rkey = wr->wr.rdma.rkey;
> +				rc_sq_wqe->va = htole64(wr->wr.rdma.remote_addr);
> +				rc_sq_wqe->rkey = htole32(wr->wr.rdma.rkey);
>  				break;
>  
>  			case IBV_WR_SEND:
> @@ -585,7 +586,7 @@ static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  					     RC_SQ_WQE_BYTE_4_OPCODE_M,
>  					     RC_SQ_WQE_BYTE_4_OPCODE_S,
>  					     HNS_ROCE_WQE_OP_SEND_WITH_INV);
> -				rc_sq_wqe->inv_key_immtdata = wr->imm_data;
> +				rc_sq_wqe->inv_key_immtdata = htole32(wr->invalidate_rkey);
>  				break;
>  			case IBV_WR_SEND_WITH_IMM:
>  				roce_set_field(rc_sq_wqe->byte_4,
> @@ -628,7 +629,7 @@ static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  
>  		/* Inline */
>  		if (wr->send_flags & IBV_SEND_INLINE && wr->num_sge) {
> -			if (rc_sq_wqe->msg_len > qp->max_inline_data) {
> +			if (le32toh(rc_sq_wqe->msg_len) > qp->max_inline_data) {
>  				ret = -1;
>  				*bad_wr = wr;
>  				printf("data len=%d, send_flags = 0x%x!\r\n",
> diff --git a/providers/hns/hns_roce_u_hw_v2.h b/providers/hns/hns_roce_u_hw_v2.h
> index 28aab60acae16a..75a379a357c7a7 100644
> --- a/providers/hns/hns_roce_u_hw_v2.h
> +++ b/providers/hns/hns_roce_u_hw_v2.h
> @@ -112,8 +112,8 @@ enum {
>  };
>  
>  struct hns_roce_db {
> -	unsigned int	byte_4;
> -	unsigned int	parameter;
> +	__le32	byte_4;
> +	__le32	parameter;
>  };
>  #define DB_BYTE_4_TAG_S 0
>  #define DB_BYTE_4_TAG_M   (((1UL << 23) - 1) << DB_BYTE_4_TAG_S)
> @@ -138,8 +138,8 @@ struct hns_roce_db {
>  	(((1UL << 3) - 1) << DB_PARAM_SL_S)
>  
>  struct hns_roce_v2_cq_db {
> -	unsigned int	byte_4;
> -	unsigned int	parameter;
> +	__le32	byte_4;
> +	__le32	parameter;
>  };
>  
>  #define CQ_DB_BYTE_4_TAG_S 0
> @@ -159,14 +159,14 @@ struct hns_roce_v2_cq_db {
>  	(((1UL << 2) - 1) << CQ_DB_PARAMETER_CMD_SN_S)
>  
>  struct hns_roce_v2_cqe {
> -	unsigned int	byte_4;
> -	unsigned int	rkey_immtdata;
> -	unsigned int	byte_12;
> -	unsigned int	byte_16;
> -	unsigned int	byte_cnt;
> -	unsigned int	smac;
> -	unsigned int	byte_28;
> -	unsigned int	byte_32;
> +	__le32	byte_4;
> +	__le32	rkey_immtdata;
> +	__le32	byte_12;
> +	__le32	byte_16;
> +	__le32	byte_cnt;
> +	__le32	smac;
> +	__le32	byte_28;
> +	__le32	byte_32;
>  };
>  
>  #define CQE_BYTE_4_OPCODE_S 0
> @@ -209,13 +209,13 @@ struct hns_roce_v2_cqe {
>  #define CQE_BYTE_32_LPK_S 31
>  
>  struct hns_roce_rc_sq_wqe {
> -	unsigned int	byte_4;
> -	unsigned int	msg_len;
> -	unsigned int	inv_key_immtdata;
> -	unsigned int	byte_16;
> -	unsigned int	byte_20;
> -	unsigned int	rkey;
> -	uint64_t	va;
> +	__le32	byte_4;
> +	__le32	msg_len;
> +	__le32	inv_key_immtdata;
> +	__le32	byte_16;
> +	__le32	byte_20;
> +	__le32	rkey;
> +	__le64	va;
>  };
>  
>  #define RC_SQ_WQE_BYTE_4_OPCODE_S 0
> @@ -247,15 +247,15 @@ struct hns_roce_rc_sq_wqe {
>  	(((1UL << 24) - 1) << RC_SQ_WQE_BYTE_20_MSG_START_SGE_IDX_S)
>  
>  struct hns_roce_v2_wqe_data_seg {
> -	__be32    len;
> -	__be32    lkey;
> -	__be64    addr;
> +	__le32    len;
> +	__le32    lkey;
> +	__le64    addr;
>  };
>  
>  struct hns_roce_v2_wqe_raddr_seg {
> -	__be32		rkey;
> -	__be32		len;
> -	__be64		raddr;
> +	__le32		rkey;
> +	__le32		len;
> +	__le64		raddr;
>  };
>  
>  #endif /* _HNS_ROCE_U_HW_V2_H */
> 


--------------F6575EC7DE6F599522979D78
Content-Type: text/plain; charset="UTF-8"; name="log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="log.txt"

oulijun@HTSAT-OPENLAB-SERVER:~/rdma-core/rdma-core/build-sparse$ CC=cgcc cmake -GNinja ..
-- The C compiler identification is GNU 4.8.4
-- Check for working C compiler using: Ninja
-- Check for working C compiler using: Ninja -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Found PkgConfig: /usr/bin/pkg-config (found version "0.26")
-- Performing Test HAVE_NO_SPARSE
-- Performing Test HAVE_NO_SPARSE - Failed
Patch from '/home/oulijun/rdma-core/rdma-core/buildlib/sparse-include/25/netinet-in.h.diff' failed
Patch from '/home/oulijun/rdma-core/rdma-core/buildlib/sparse-include/23/netinet-in.h.diff' failed
-- Performing Test HAVE_C_WARNINGS
-- Performing Test HAVE_C_WARNINGS - Success
-- Performing Test HAVE_C_WMISSING_PROTOTYPES
-- Performing Test HAVE_C_WMISSING_PROTOTYPES - Success
-- Performing Test HAVE_C_WMISSING_DECLARATIONS
-- Performing Test HAVE_C_WMISSING_DECLARATIONS - Success
-- Performing Test HAVE_C_WWRITE_STRINGS
-- Performing Test HAVE_C_WWRITE_STRINGS - Success
-- Performing Test HAVE_C_WFORMAT_2
-- Performing Test HAVE_C_WFORMAT_2 - Success
-- Performing Test HAVE_C_WORKING_SHADOW
-- Performing Test HAVE_C_WORKING_SHADOW - Success
-- Performing Test HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS
-- Performing Test HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS - Failed
-- Performing Test HAVE_C_WNO_MISSING_FIELD_INITIALIZERS
-- Performing Test HAVE_C_WNO_MISSING_FIELD_INITIALIZERS - Success
-- Performing Test HAVE_NO_STRICT_ALIASING
-- Performing Test HAVE_NO_STRICT_ALIASING - Success
-- Performing Test HAVE_FUNC_ATTRIBUTE_IFUNC
-- Performing Test HAVE_FUNC_ATTRIBUTE_IFUNC - Success
-- Performing Test HAS_CLOEXEC
-- Performing Test HAS_CLOEXEC - Success
-- Performing Test HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
-- Performing Test HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE - Success
-- Performing Test SUPPORTS_AS_NEEDED
-- Performing Test SUPPORTS_AS_NEEDED - Success
-- Performing Test SUPPORTS_NO_UNDEFINED
-- Performing Test SUPPORTS_NO_UNDEFINED - Success
-- Performing Test _LDSYMVER_SUCCESS
-- Performing Test _LDSYMVER_SUCCESS - Success
-- Found LDSymVer: GNU
-- Looking for include file pthread.h
-- Looking for include file pthread.h - found
-- Looking for pthread_create
-- Looking for pthread_create - not found
-- Looking for pthread_create in pthreads
-- Looking for pthread_create in pthreads - not found
-- Looking for pthread_create in pthread
-- Looking for pthread_create in pthread - found
-- Found Threads: TRUE
-- checking for modules 'libnl-3.0;libnl-route-3.0'
--   found libnl-3.0, version 3.2.21
--   found libnl-route-3.0, version 3.2.21
-- Performing Test HAVE_WORKING_IF_H
-- Performing Test HAVE_WORKING_IF_H - Failed
-- Found UDev: /usr/lib/x86_64-linux-gnu/libudev.so
-- Check size of long
-- Check size of long - done
-- Performing Test HAVE_RDMA_IB_USER_VERBS_H
-- Performing Test HAVE_RDMA_IB_USER_VERBS_H - Success
-- Performing Test HAVE_RDMA_IB_USER_SA_H
-- Performing Test HAVE_RDMA_IB_USER_SA_H - Success
-- Performing Test HAVE_RDMA_IB_USER_CM_H
-- Performing Test HAVE_RDMA_IB_USER_CM_H - Success
-- Performing Test HAVE_RDMA_HFI_HFI1_IOCTL_H
-- Performing Test HAVE_RDMA_HFI_HFI1_IOCTL_H - Failed
-- Performing Test HAVE_RDMA_RDMA_USER_IOCTL_H
-- Performing Test HAVE_RDMA_RDMA_USER_IOCTL_H - Failed
-- Performing Test HAVE_RDMA_IB_USER_MAD_H
-- Performing Test HAVE_RDMA_IB_USER_MAD_H - Success
-- Performing Test HAVE_RDMA_RDMA_NETLINK_H
-- Performing Test HAVE_RDMA_RDMA_NETLINK_H - Failed
-- Performing Test HAVE_RDMA_RDMA_USER_CM_H
-- Performing Test HAVE_RDMA_RDMA_USER_CM_H - Success
-- Performing Test HAVE_RDMA_RDMA_USER_RXE_H
-- Performing Test HAVE_RDMA_RDMA_USER_RXE_H - Failed
-- Performing Test HAVE_RDMA_VMW_PVRDMA-ABI_H
-- Performing Test HAVE_RDMA_VMW_PVRDMA-ABI_H - Failed
-- Performing Test HAVE_COHERENT_DMA
-- Performing Test HAVE_COHERENT_DMA - Success
-- Could NOT find Systemd (missing:  SYSTEMD_LIBRARIES LIBSYSTEMD_INCLUDE_DIRS)
-- Looking for valgrind/memcheck.h
-- Looking for valgrind/memcheck.h - found
-- Looking for valgrind/drd.h
-- Looking for valgrind/drd.h - found
-- Performing Test LIBC_HAS_LIBRT
-- Performing Test LIBC_HAS_LIBRT - Success
-- Performing Test HAVE_C_WSTRICT_PROTOTYPES
-- Performing Test HAVE_C_WSTRICT_PROTOTYPES - Success
-- Performing Test HAVE_C_WOLD_STYLE_DEFINITION
-- Performing Test HAVE_C_WOLD_STYLE_DEFINITION - Success
-- Performing Test HAVE_C_WREDUNDANT_DECLS
-- Performing Test HAVE_C_WREDUNDANT_DECLS - Failed
-- Missing Optional Items:
--  C11 stdatomic.h NOT available (old compiler)
--  netlink/route/link.h and net/if.h NOT co-includable (old headers)
--  libsystemd NOT found (disabling features)
--  rdma/rdma_netlink.h NOT found (old system kernel headers)
--  rdma/rdma_user_rxe.h NOT found (old system kernel headers)
--  rdma/vmw_pvrdma-abi.h NOT found (old system kernel headers)
--  -Wmissing-field-initializers does NOT work
--  -Wredundant-decls does NOT work
-- Configuring done
-- Generating done
-- Build files have been written to: /home/oulijun/rdma-core/rdma-core/build-sparse
oulijun@HTSAT-OPENLAB-SERVER:~/rdma-core/rdma-core/build-sparse$ ninja
[10/190] Building C object util/CMakeFiles/rdma_util_pic.dir/mmio.c.o
/usr/include/linux/types.h:4:11: error: unable to open 'asm/types.h'
[10/190] Building C object util/CMakeFiles/rdma_util.dir/mmio.c.o
/usr/include/linux/types.h:4:11: error: unable to open 'asm/types.h'
[19/190] Building C object libibverbs/examples/CMakeFiles/ibverbs_tools.dir/pingpong.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[33/190] Building C object librdmacm/examples/CMakeFiles/rdmacm_tools.dir/common.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[34/190] Building C object libibumad/tests/CMakeFiles/umad_compile_test.dir/umad_compile_test.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[35/190] Building C object libibverbs/CMakeFiles/ibverbs.dir/marshall.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[35/190] Building C object libibverbs/CMakeFiles/ibverbs.dir/enum_strs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[35/190] Building C object libibverbs/CMakeFiles/ibverbs.dir/sysfs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[35/190] Building C object libibumad/CMakeFiles/ibumad.dir/sysfs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[35/190] Building C object libibumad/CMakeFiles/ibumad.dir/umad_str.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[35/190] Building C object rdma-ndd/CMakeFiles/rdma-ndd.dir/rdma-ndd.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[36/190] Building C object libibverbs/CMakeFiles/ibverbs.dir/device.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[36/190] Building C object iwpmd/CMakeFiles/iwpmd.dir/iwarp_pm_common.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[36/190] Building C object libibverbs/CMakeFiles/ibverbs.dir/memory.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[36/190] Building C object iwpmd/CMakeFiles/iwpmd.dir/iwarp_pm_helper.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[36/190] Building C object libibverbs/CMakeFiles/ibverbs.dir/neigh.c.o
/usr/include/linux/types.h:4:11: error: unable to open 'asm/types.h'
[36/190] Building C object libibverbs/CMakeFiles/ibverbs.dir/compat-1_0.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[36/190] Building C object libibverbs/CMakeFiles/ibverbs.dir/init.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[36/190] Building C object libibverbs/CMakeFiles/ibverbs.dir/verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[36/190] Building C object iwpmd/CMakeFiles/iwpmd.dir/iwarp_pm_server.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[37/190] Building C object libibumad/CMakeFiles/ibumad.dir/umad.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[41/190] Building C object libibumad/tests/CMakeFiles/umad_reg2.dir/umad_reg2_compat.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[42/190] Building C object libibverbs/CMakeFiles/ibverbs.dir/cmd.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[43/190] Building C object libibumad/tests/CMakeFiles/umad_register2.dir/umad_register2.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[87/190] Building C object providers/bnxt_re/CMakeFiles/bnxt_re-rdmav16.dir/memory.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[88/190] Building C object providers/cxgb3/CMakeFiles/cxgb3-rdmav16.dir/iwch.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[89/190] Building C object librdmacm/CMakeFiles/rdmacm.dir/indexer.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[90/190] Building C object providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_buf.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[91/190] Building C object providers/mthca/CMakeFiles/mthca-rdmav16.dir/buf.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[92/190] Building C object providers/mlx4/CMakeFiles/mlx4.dir/buf.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[93/190] Building C object providers/mlx4/CMakeFiles/mlx4.dir/dbrec.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[94/190] Building C object providers/i40iw/CMakeFiles/i40iw-rdmav16.dir/i40iw_umain.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[95/190] Building C object providers/bnxt_re/CMakeFiles/bnxt_re-rdmav16.dir/db.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[96/190] Building C object librdmacm/CMakeFiles/rdmacm.dir/addrinfo.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[97/190] Building C object providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[98/190] Building C object providers/mlx5/CMakeFiles/mlx5.dir/dbrec.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[99/190] Building C object providers/cxgb4/CMakeFiles/cxgb4-rdmav16.dir/dev.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[100/190] Building C object providers/mlx4/CMakeFiles/mlx4.dir/mlx4.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[101/190] Building C object providers/mlx4/CMakeFiles/mlx4.dir/srq.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[102/190] Building C object providers/bnxt_re/CMakeFiles/bnxt_re-rdmav16.dir/main.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[103/190] Building C object providers/cxgb3/CMakeFiles/cxgb3-rdmav16.dir/cq.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[104/190] Building C object providers/mlx5/CMakeFiles/mlx5.dir/srq.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[105/190] Building C object providers/cxgb3/CMakeFiles/cxgb3-rdmav16.dir/verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[106/190] Building C object librdmacm/CMakeFiles/rdmacm.dir/acm.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[107/190] Building C object providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[108/190] Building C object providers/cxgb4/CMakeFiles/cxgb4-rdmav16.dir/verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[110/190] Building C object providers/mthca/CMakeFiles/mthca-rdmav16.dir/ah.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[110/190] Building C object providers/mthca/CMakeFiles/mthca-rdmav16.dir/memfree.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[111/190] Building C object providers/mthca/CMakeFiles/mthca-rdmav16.dir/mthca.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[112/190] Building C object providers/cxgb3/CMakeFiles/cxgb3-rdmav16.dir/qp.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[113/190] Building C object providers/nes/CMakeFiles/nes-rdmav16.dir/nes_umain.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[114/190] Building C object providers/ocrdma/CMakeFiles/ocrdma-rdmav16.dir/ocrdma_main.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[115/190] Building C object providers/mlx4/CMakeFiles/mlx4.dir/qp.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[118/190] Building C object providers/mthca/CMakeFiles/mthca-rdmav16.dir/srq.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[118/190] Building C object providers/qedr/CMakeFiles/qedr-rdmav16.dir/qelr_chain.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[118/190] Building C object providers/qedr/CMakeFiles/qedr-rdmav16.dir/qelr_main.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[119/190] Building C object providers/cxgb4/CMakeFiles/cxgb4-rdmav16.dir/qp.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[120/190] Building C object providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[121/190] Building C object providers/mlx5/CMakeFiles/mlx5.dir/buf.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[123/190] Building C object providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v1.c.o
/usr/include/linux/types.h:4:11: error: unable to open 'asm/types.h'
[124/190] Building C object providers/i40iw/CMakeFiles/i40iw-rdmav16.dir/i40iw_uverbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[125/190] Building C object providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/pvrdma_main.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[126/190] Building C object providers/mlx4/CMakeFiles/mlx4.dir/cq.c.o
/usr/include/linux/types.h:4:11: error: unable to open 'asm/types.h'
[127/190] Building C object providers/cxgb4/CMakeFiles/cxgb4-rdmav16.dir/cq.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[128/190] Building C object providers/i40iw/CMakeFiles/i40iw-rdmav16.dir/i40iw_uk.c.o
/usr/include/linux/types.h:4:11: error: unable to open 'asm/types.h'
[129/190] Building C object libibcm/CMakeFiles/ibcm.dir/cm.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[130/190] Building C object providers/hfi1verbs/CMakeFiles/hfi1verbs-rdmav16.dir/hfiverbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[130/190] Building C object providers/mthca/CMakeFiles/mthca-rdmav16.dir/cq.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[130/190] Building C object providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/verbs.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[130/190] Building C object providers/mthca/CMakeFiles/mthca-rdmav16.dir/verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[130/190] Building C object providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/cq.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[130/190] Building C object providers/mlx5/CMakeFiles/mlx5.dir/mlx5.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[130/190] Building C object providers/ipathverbs/CMakeFiles/ipathverbs-rdmav16.dir/ipathverbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[131/190] Building C object ibacm/CMakeFiles/ib_acme.dir/src/acme.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[131/190] Building C object libibverbs/examples/CMakeFiles/ibv_devices.dir/device_list.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[132/190] Building C object ibacm/CMakeFiles/ib_acme.dir/src/parse.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[132/190] Building C object libibverbs/examples/CMakeFiles/ibv_asyncwatch.dir/asyncwatch.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[133/190] Building C object providers/mthca/CMakeFiles/mthca-rdmav16.dir/qp.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[134/190] Building C object providers/vmw_pvrdma/CMakeFiles/vmw_pvrdma-rdmav16.dir/qp.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[135/190] Building C object ibacm/CMakeFiles/ibacm.dir/src/acm_util.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[135/190] Building C object providers/mlx4/CMakeFiles/mlx4.dir/verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[136/190] Building C object providers/hfi1verbs/CMakeFiles/hfi1verbs-rdmav16.dir/verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[137/190] Building C object providers/bnxt_re/CMakeFiles/bnxt_re-rdmav16.dir/verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[138/190] Building C object srp_daemon/CMakeFiles/srp_daemon.dir/srp_sync.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[138/190] Building C object ibacm/CMakeFiles/ib_acme.dir/src/libacm.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[140/190] Building C object providers/ipathverbs/CMakeFiles/ipathverbs-rdmav16.dir/verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[141/190] Building C object providers/rxe/CMakeFiles/rxe-rdmav16.dir/rxe.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[142/190] Building C object libibverbs/examples/CMakeFiles/ibv_uc_pingpong.dir/uc_pingpong.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[143/190] Building C object libibverbs/examples/CMakeFiles/ibv_devinfo.dir/devinfo.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[144/190] Building C object providers/nes/CMakeFiles/nes-rdmav16.dir/nes_uverbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[145/190] Building C object srp_daemon/CMakeFiles/srp_daemon.dir/srp_handle_traps.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[145/190] Building C object providers/mlx5/CMakeFiles/mlx5.dir/qp.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[145/190] Building C object libibverbs/examples/CMakeFiles/ibv_ud_pingpong.dir/ud_pingpong.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[146/190] Building C object libibverbs/examples/CMakeFiles/ibv_rc_pingpong.dir/rc_pingpong.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[147/190] Building C object providers/mlx5/CMakeFiles/mlx5.dir/verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[147/190] Building C object libibverbs/examples/CMakeFiles/ibv_xsrq_pingpong.dir/xsrq_pingpong.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[148/190] Building C object providers/ocrdma/CMakeFiles/ocrdma-rdmav16.dir/ocrdma_verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[149/190] Building C object libibverbs/examples/CMakeFiles/ibv_srq_pingpong.dir/srq_pingpong.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[150/190] Building C object providers/qedr/CMakeFiles/qedr-rdmav16.dir/qelr_verbs.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[151/190] Building C object librdmacm/CMakeFiles/rdmacm.dir/cma.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[151/190] Building C object srp_daemon/CMakeFiles/srp_daemon.dir/srp_daemon.c.o
/usr/include/bits/ioctls.h:23:11: error: unable to open 'asm/ioctls.h'
[152/190] Building C object ibacm/CMakeFiles/ibacm.dir/src/acm.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[154/190] Building C object librdmacm/CMakeFiles/rdmacm.dir/rsocket.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[172/190] Building C object librdmacm/CMakeFiles/rspreload.dir/indexer.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[172/190] Building C object librdmacm/examples/CMakeFiles/rdma_xserver.dir/rdma_xserver.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[173/190] Building C object librdmacm/examples/CMakeFiles/rdma_client.dir/rdma_client.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[174/190] Building C object librdmacm/examples/CMakeFiles/rdma_xclient.dir/rdma_xclient.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[175/190] Building C object providers/mlx5/CMakeFiles/mlx5.dir/cq.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[176/190] Building C object librdmacm/examples/CMakeFiles/rcopy.dir/rcopy.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[177/190] Building C object librdmacm/examples/CMakeFiles/rdma_server.dir/rdma_server.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[178/190] Building C object librdmacm/examples/CMakeFiles/mckey.dir/mckey.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[180/190] Building C object librdmacm/examples/CMakeFiles/udpong.dir/udpong.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[181/190] Building C object librdmacm/examples/CMakeFiles/riostream.dir/riostream.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[182/190] Building C object libibcm/examples/CMakeFiles/cmpost.dir/cmpost.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[183/190] Building C object librdmacm/examples/CMakeFiles/cmtime.dir/cmtime.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[184/190] Building C object librdmacm/examples/CMakeFiles/rstream.dir/rstream.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[185/190] Building C object librdmacm/examples/CMakeFiles/ucmatose.dir/cmatose.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[186/190] Building C object librdmacm/examples/CMakeFiles/rping.dir/rping.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[187/190] Building C object librdmacm/examples/CMakeFiles/udaddy.dir/udaddy.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[188/190] Building C object librdmacm/CMakeFiles/rspreload.dir/preload.c.o
/usr/include/bits/socket.h:345:11: error: unable to open 'asm/socket.h'
[189/190] Building C object ibacm/CMakeFiles/ibacmp.dir/prov/acmp/src/acmp.c.o
/usr/include/linux/errno.h:1:11: error: unable to open 'asm/errno.h'
[190/190] Linking C shared module lib/libibacmp.so
oulijun@HTSAT-OPENLAB-SERVER:~/rdma-core/rdma-core/build-sparse$



.

--------------F6575EC7DE6F599522979D78--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
