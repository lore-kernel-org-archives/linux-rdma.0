From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 2/6] RDMA/hns: Add gsi qp support for modifying
 qp in hip08
Date: Tue, 9 Jan 2018 09:04:11 +0800
Message-ID: <66c69e6b-8f74-be2e-1404-3e0c8c4a4024@huawei.com>
References: <1515039563-73084-1-git-send-email-oulijun@huawei.com>
 <1515039563-73084-3-git-send-email-oulijun@huawei.com>
 <1515446459.3403.94.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515446459.3403.94.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2018/1/9 5:20, Doug Ledford 写道:
> On Thu, 2018-01-04 at 12:19 +0800, Lijun Ou wrote:
>> @@ -2342,7 +2366,7 @@ static void modify_qp_init_to_init(struct ib_qp *ibqp,
>>                        V2_QPC_BYTE_80_RX_CQN_S, 0);
>>  
>>         roce_set_field(context->byte_252_err_txcqn, V2_QPC_BYTE_252_TX_CQN_M,
>> -                      V2_QPC_BYTE_252_TX_CQN_S, to_hr_cq(ibqp->recv_cq)->cqn);
>> +                      V2_QPC_BYTE_252_TX_CQN_S, to_hr_cq(ibqp->send_cq)->cqn);
> 
> This looks like a bugfix unrelated to the rest of the patch.
> 
Sure, This is found for debugging CM and The other modification of qp context in
this patch is unified for CM. As a result, I put it into the patch-set of CM.

Do I need to send PATCHv2?

thanks
Lijun Ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
