From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and
 immediate
Date: Mon, 6 Nov 2017 09:43:05 +0800
Message-ID: <7dba9ad9-5a71-c4fe-b2b9-ccc35c188f8c@huawei.com>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-4-git-send-email-oulijun@huawei.com>
 <20171101161328.GB7815@ziepe.ca> <20171104100846.GA1636@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171104100846.GA1636-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2017/11/4 18:08, Leon Romanovsky 写道:
> On Wed, Nov 01, 2017 at 10:13:28AM -0600, Jason Gunthorpe wrote:
>> On Wed, Nov 01, 2017 at 06:00:40PM +0800, Lijun Ou wrote:
>>> @@ -385,7 +385,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
>>>  		case HNS_ROCE_RECV_OP_RDMA_WRITE_IMM:
>>>  			wc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
>>>  			wc->wc_flags = IBV_WC_WITH_IMM;
>>> -			wc->imm_data = cqe->rkey_immtdata;
>>> +			wc->imm_data = be32toh(cqe->rkey_immtdata);
>>>  			break;
>>
>> This can't be right, wc->imm_data is marked be32.
> 
> Lijun,
> 
> Are you going to fix it?
> 
> Thanks
> 
Yes， I think that it is not fixed. I have tested the roce device aginst hip08, D05(ARM64) and
CX3, and I also have tested the D05 aginst cx3 and D05.  I also tried to run sparse and
don't produce a userful result. I also  follow Jason's advice. Is it ok?

Thanks
Lijun Ou


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
