From: Gal Pressman <galpress@amazon.com>
Subject: Re: [RFC v1 08/19] RDMA/irdma: Add privileged UDA queue
 implementation
Date: Sun, 24 Feb 2019 13:42:17 +0200
Message-ID: <bb00f433-d699-7091-964b-50ebc487290f@amazon.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-9-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215171107.6464-9-shiraz.saleem@intel.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On 15-Feb-19 19:10, Shiraz Saleem wrote:
> +/**
> + * irdma_puda_poll_info - poll cq for completion
> + * @cq: cq for poll
> + * @info: info return for successful completion
> + */
> +static enum irdma_status_code
> +irdma_puda_poll_info(struct irdma_sc_cq *cq, struct irdma_puda_cmpl_info *info)
> +{
> +	struct irdma_cq_uk *cq_uk = &cq->cq_uk;
> +	u64 qword0, qword2, qword3, qword6;
> +	__le64 *cqe;
> +	__le64 *ext_cqe = NULL;
> +	u64 qword7 = 0;
> +	u64 comp_ctx;
> +	bool valid_bit;
> +	bool ext_valid = 0;
> +	u32 major_err, minor_err;
> +	u32 peek_head;
> +	bool error;
> +	u8 polarity;
> +
> +	cqe = IRDMA_GET_CURRENT_CQ_ELEM(&cq->cq_uk);
> +	get_64bit_val(cqe, 24, &qword3);
> +	valid_bit = (bool)RS_64(qword3, IRDMA_CQ_VALID);
> +	if (valid_bit != cq_uk->polarity)
> +		return IRDMA_ERR_Q_EMPTY;
> +
> +	if (cq->dev->hw_attrs.hw_rev > IRDMA_GEN_1)
> +		ext_valid = (bool)RS_64(qword3, IRDMA_CQ_EXTCQE);
> +
> +	if (ext_valid) {
> +		enum irdma_status_code ret = 0;
> +
> +		peek_head = (cq_uk->cq_ring.head + 1) % cq_uk->cq_ring.size;
> +		ext_cqe = cq_uk->cq_base[peek_head].buf;
> +		get_64bit_val(ext_cqe, 24, &qword7);
> +		polarity = (u8)RS_64(qword7, IRDMA_CQ_VALID);
> +		if (!peek_head)
> +			polarity ^= 1;
> +		if (polarity != cq_uk->polarity)
> +			return IRDMA_ERR_Q_EMPTY;
> +
> +		IRDMA_RING_MOVE_HEAD(cq_uk->cq_ring, ret);

Should you check for 'ret' value here? It was initialized to 0 and overriden
here but I can't see any actual use for it.

> +		if (IRDMA_RING_CURRENT_HEAD(cq_uk->cq_ring) == 0)
> +			cq_uk->polarity = !cq_uk->polarity;
> +		/* update cq tail in cq shadow memory also */
> +		IRDMA_RING_MOVE_TAIL(cq_uk->cq_ring);
> +	}
> +
> +	irdma_debug_buf(cq->dev, IRDMA_DEBUG_PUDA, "PUDA CQE", cqe, 32);
> +	if (ext_valid)
> +		irdma_debug_buf(cq->dev, IRDMA_DEBUG_PUDA, "PUDA EXT-CQE",
> +				ext_cqe, 32);
> +
> +	error = (bool)RS_64(qword3, IRDMA_CQ_ERROR);
> +	if (error) {
> +		irdma_debug(cq->dev, IRDMA_DEBUG_PUDA, "receive error\n");
> +		major_err = (u32)(RS_64(qword3, IRDMA_CQ_MAJERR));
> +		minor_err = (u32)(RS_64(qword3, IRDMA_CQ_MINERR));
> +		info->compl_error = major_err << 16 | minor_err;
> +		return IRDMA_ERR_CQ_COMPL_ERROR;
> +	}
> +
> +	get_64bit_val(cqe, 0, &qword0);
> +	get_64bit_val(cqe, 16, &qword2);
> +
> +	info->q_type = (u8)RS_64(qword3, IRDMA_CQ_SQ);
> +	info->qp_id = (u32)RS_64(qword2, IRDMACQ_QPID);
> +	if (cq->dev->hw_attrs.hw_rev > IRDMA_GEN_1)
> +		info->ipv4 = (bool)RS_64(qword3, IRDMACQ_IPV4);
> +
> +	get_64bit_val(cqe, 8, &comp_ctx);
> +	info->qp = (struct irdma_qp_uk *)(unsigned long)comp_ctx;
> +	info->wqe_idx = (u32)RS_64(qword3, IRDMA_CQ_WQEIDX);
> +
> +	if (info->q_type == IRDMA_CQE_QTYPE_RQ) {
> +		if (ext_valid) {
> +			info->vlan_valid = (bool)RS_64(qword7, IRDMA_CQ_UDVLANVALID);
> +			if (info->vlan_valid) {
> +				get_64bit_val(ext_cqe, 16, &qword6);
> +				info->vlan = (u16)RS_64(qword6, IRDMA_CQ_UDVLAN);
> +			}
> +			info->smac_valid = (bool)RS_64(qword7, IRDMA_CQ_UDSMACVALID);
> +			if (info->smac_valid) {
> +				get_64bit_val(ext_cqe, 16, &qword6);
> +				info->smac[0] = (u8)((qword6 >> 40) & 0xFF);
> +				info->smac[1] = (u8)((qword6 >> 32) & 0xFF);
> +				info->smac[2] = (u8)((qword6 >> 24) & 0xFF);
> +				info->smac[3] = (u8)((qword6 >> 16) & 0xFF);
> +				info->smac[4] = (u8)((qword6 >> 8) & 0xFF);
> +				info->smac[5] = (u8)(qword6 & 0xFF);
> +			}
> +		}
> +
> +		if (cq->dev->hw_attrs.hw_rev == IRDMA_GEN_1) {
> +			info->vlan_valid = (bool)RS_64(qword3, IRDMA_VLAN_TAG_VALID);
> +			info->l4proto = (u8)RS_64(qword2, IRDMA_UDA_L4PROTO);
> +			info->l3proto = (u8)RS_64(qword2, IRDMA_UDA_L3PROTO);
> +		}
> +
> +		info->payload_len = (u32)RS_64(qword0, IRDMACQ_PAYLDLEN);
> +	}
> +
> +	return 0;
> +}
