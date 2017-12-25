From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 2/6] RDMA/hns: Update the usage of sr_max and
 rr_max field
Date: Mon, 25 Dec 2017 18:14:26 +0800
Message-ID: <bfcfca0e-d8c3-034d-e973-c7fab6cd4f0f@huawei.com>
References: <1514017342-91468-1-git-send-email-oulijun@huawei.com>
 <1514017342-91468-3-git-send-email-oulijun@huawei.com>
 <20171225094112.GA2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171225094112.GA2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2017/12/25 17:41, Leon Romanovsky 写道:
> On Sat, Dec 23, 2017 at 04:22:18PM +0800, Lijun Ou wrote:
>> This patch fixes the usage with sr_max filed and rr_max of qp
>> context when modify qp. Its modifications include:
>> 1. Adjust location of filling sr_max filed of qpc
>> 2. Only assign the number of responder resource if
>>    IB_QP_MAX_DEST_RD_ATOMIC bit is set
>> 3. Only assign the number of outstanding resource if
>>    IB_QP_MAX_QP_RD_ATOMIC
>> 4. Fix the assgin algorithms for the field of sr_max
>>    and rr_max of qp context
>>
>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 33 ++++++++++++++++++++----------
>>  1 file changed, 22 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> index b17dcfa..092f133 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> @@ -2531,11 +2531,17 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
>>  		roce_set_bit(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_LBI_S, 0);
>>  	}
>>
>> -	roce_set_field(context->byte_140_raq, V2_QPC_BYTE_140_RR_MAX_M,
>> -		       V2_QPC_BYTE_140_RR_MAX_S,
>> -		       ilog2((unsigned int)attr->max_dest_rd_atomic));
>> -	roce_set_field(qpc_mask->byte_140_raq, V2_QPC_BYTE_140_RR_MAX_M,
>> -		       V2_QPC_BYTE_140_RR_MAX_S, 0);
>> +	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) {
>> +		if (attr->max_dest_rd_atomic) {
> 
> if ((attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) && attr->max_dest_rd_atomic) {
> 
Good advice, thanks. I will fix it.
> 
> 
>> +			roce_set_field(context->byte_140_raq,
>> +				       V2_QPC_BYTE_140_RR_MAX_M,
>> +				       V2_QPC_BYTE_140_RR_MAX_S,
>> +				       fls(attr->max_dest_rd_atomic - 1));
>> +			roce_set_field(qpc_mask->byte_140_raq,
>> +				       V2_QPC_BYTE_140_RR_MAX_M,
>> +				       V2_QPC_BYTE_140_RR_MAX_S, 0);
>> +		}
>> +	}
>>
>>  	roce_set_field(context->byte_56_dqpn_err, V2_QPC_BYTE_56_DQPN_M,
>>  		       V2_QPC_BYTE_56_DQPN_S, attr->dest_qp_num);
>> @@ -2625,12 +2631,6 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
>>  		       V2_QPC_BYTE_168_LP_SGEN_INI_M,
>>  		       V2_QPC_BYTE_168_LP_SGEN_INI_S, 0);
>>
>> -	roce_set_field(context->byte_208_irrl, V2_QPC_BYTE_208_SR_MAX_M,
>> -		       V2_QPC_BYTE_208_SR_MAX_S,
>> -		       ilog2((unsigned int)attr->max_rd_atomic));
>> -	roce_set_field(qpc_mask->byte_208_irrl, V2_QPC_BYTE_208_SR_MAX_M,
>> -		       V2_QPC_BYTE_208_SR_MAX_S, 0);
>> -
>>  	roce_set_field(context->byte_28_at_fl, V2_QPC_BYTE_28_SL_M,
>>  		       V2_QPC_BYTE_28_SL_S, rdma_ah_get_sl(&attr->ah_attr));
>>  	roce_set_field(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_SL_M,
>> @@ -2834,6 +2834,17 @@ static int modify_qp_rtr_to_rts(struct ib_qp *ibqp,
>>  	roce_set_field(qpc_mask->byte_196_sq_psn, V2_QPC_BYTE_196_SQ_MAX_PSN_M,
>>  		       V2_QPC_BYTE_196_SQ_MAX_PSN_S, 0);
>>
>> +	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC) {
>> +		if (attr->max_rd_atomic) {
>> +			roce_set_field(context->byte_208_irrl,
>> +				       V2_QPC_BYTE_208_SR_MAX_M,
>> +				       V2_QPC_BYTE_208_SR_MAX_S,
>> +				       fls(attr->max_rd_atomic - 1));
>> +			roce_set_field(qpc_mask->byte_208_irrl,
>> +				       V2_QPC_BYTE_208_SR_MAX_M,
>> +				       V2_QPC_BYTE_208_SR_MAX_S, 0);
>> +		}
>> +	}
>>  	return 0;
>>  }
>>
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
