Return-Path: <SRS0=GXMw=V3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EF9C0650F
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jul 2019 13:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 418FF2089E
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jul 2019 13:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfG3Nhs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 30 Jul 2019 09:37:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3252 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725793AbfG3Nhs (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 30 Jul 2019 09:37:48 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BC4D310365489B67CA32;
        Tue, 30 Jul 2019 21:37:46 +0800 (CST)
Received: from [127.0.0.1] (10.61.25.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Jul 2019
 21:37:37 +0800
Subject: Re: [PATCH for-next 01/13] RDMA/hns: Encapsulate some lines for
 setting sq size in user mode
To:     Jason Gunthorpe <jgg@ziepe.ca>, Gal Pressman <galpress@amazon.com>
CC:     <dledford@redhat.com>, <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
References: <1564477010-29804-1-git-send-email-oulijun@huawei.com>
 <1564477010-29804-2-git-send-email-oulijun@huawei.com>
 <01dace9b-593d-39dd-99e7-d8d60803949d@amazon.com>
 <20190730121736.GA13921@ziepe.ca>
From:   oulijun <oulijun@huawei.com>
Message-ID: <5d3a9752-6a6a-1ea3-ced7-ac485556600a@huawei.com>
Date:   Tue, 30 Jul 2019 21:37:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <20190730121736.GA13921@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.61.25.96]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

在 2019/7/30 20:17, Jason Gunthorpe 写道:
> On Tue, Jul 30, 2019 at 02:16:01PM +0300, Gal Pressman wrote:
>> On 30/07/2019 11:56, Lijun Ou wrote:
>>> It needs to check the sq size with integrity when configures
>>> the relatived parameters of sq. Here moves the relatived code
>>> into a special function.
>>>
>>> Signed-off-by: Lijun Ou <oulijun@huawei.com>
>>>  drivers/infiniband/hw/hns/hns_roce_qp.c | 29 ++++++++++++++++++++++-------
>>>  1 file changed, 22 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
>>> index 9c272c2..35ef7e2 100644
>>> +++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
>>> @@ -324,16 +324,12 @@ static int hns_roce_set_rq_size(struct hns_roce_dev *hr_dev,
>>>  	return 0;
>>>  }
>>>  
>>> -static int hns_roce_set_user_sq_size(struct hns_roce_dev *hr_dev,
>>> -				     struct ib_qp_cap *cap,
>>> -				     struct hns_roce_qp *hr_qp,
>>> -				     struct hns_roce_ib_create_qp *ucmd)
>>> +static int check_sq_size_with_integrity(struct hns_roce_dev *hr_dev,
>>> +					struct ib_qp_cap *cap,
>>> +					struct hns_roce_ib_create_qp *ucmd)
>>>  {
>>>  	u32 roundup_sq_stride = roundup_pow_of_two(hr_dev->caps.max_sq_desc_sz);
>>>  	u8 max_sq_stride = ilog2(roundup_sq_stride);
>>> -	u32 ex_sge_num;
>>> -	u32 page_size;
>>> -	u32 max_cnt;
>>>  
>>>  	/* Sanity check SQ size before proceeding */
>>>  	if ((u32)(1 << ucmd->log_sq_bb_count) > hr_dev->caps.max_wqes ||
>>> @@ -349,6 +345,25 @@ static int hns_roce_set_user_sq_size(struct hns_roce_dev *hr_dev,
>>>  		return -EINVAL;
>>>  	}
>>>  
>>> +	return 0;
>>> +}
>>> +
>>> +static int hns_roce_set_user_sq_size(struct hns_roce_dev *hr_dev,
>>> +				     struct ib_qp_cap *cap,
>>> +				     struct hns_roce_qp *hr_qp,
>>> +				     struct hns_roce_ib_create_qp *ucmd)
>>> +{
>>> +	u32 ex_sge_num;
>>> +	u32 page_size;
>>> +	u32 max_cnt;
>>> +	int ret;
>>> +
>>> +	ret = check_sq_size_with_integrity(hr_dev, cap, ucmd);
>>> +	if (ret) {
>>> +		dev_err(hr_dev->dev, "Sanity check sq size fail\n");
>> Consider using ibdev_err, same applies for other patches.
> It would be good if driver authors would convert their drivers to use
> the new interfaces
>
> Jason
>
> .
Yes, I am testing the effects of both according to the recommendations.
I think we should consider replacement spparately,  Do you agree?




