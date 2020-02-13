Return-Path: <SRS0=pr8h=4B=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5E7C352A4
	for <linux-rdma@archiver.kernel.org>; Thu, 13 Feb 2020 02:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A99720848
	for <linux-rdma@archiver.kernel.org>; Thu, 13 Feb 2020 02:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgBMCQs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 12 Feb 2020 21:16:48 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:39014 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729333AbgBMCQs (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 12 Feb 2020 21:16:48 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EA16C4CAFFD25B241C2C;
        Thu, 13 Feb 2020 10:16:46 +0800 (CST)
Received: from [127.0.0.1] (10.40.168.149) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Feb 2020
 10:16:40 +0800
Subject: Re: [PATCH for-next] RDMA/hns: Optimize eqe buffer allocation flow
To:     Leon Romanovsky <leon@kernel.org>
CC:     <dledford@redhat.com>, <jgg@ziepe.ca>,
        <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
References: <20200126145835.11368-1-liweihang@huawei.com>
 <20200127055205.GH3870@unreal>
 <10b7a08c-e069-0751-8bde-e5d19521c0b2@huawei.com>
 <20200210092508.GB495280@unreal>
 <512fa0f9-2bef-b3d8-fb3d-144984ee468c@huawei.com>
 <20200210102120.GC495280@unreal>
 <d8ccdc94-917e-19be-dcd7-e15afd9c005a@huawei.com>
 <20200212081812.GC679970@unreal>
From:   Weihang Li <liweihang@huawei.com>
Message-ID: <824f2f26-12eb-d7cf-1487-9941fb8b32ee@huawei.com>
Date:   Thu, 13 Feb 2020 10:16:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200212081812.GC679970@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.168.149]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 2020/2/12 16:18, Leon Romanovsky wrote:
> On Mon, Feb 10, 2020 at 07:26:59PM +0800, Weihang Li wrote:
>>
>>
>> On 2020/2/10 18:21, Leon Romanovsky wrote:
>>> On Mon, Feb 10, 2020 at 05:48:05PM +0800, Weihang Li wrote:
>>>>
>>>>
>>>> On 2020/2/10 17:25, Leon Romanovsky wrote:
>>>>>>>> -		if (!eq->bt_l0)
>>>>>>>> -			return -ENOMEM;
>>>>>>>> -
>>>>>>>> -		eq->cur_eqe_ba = eq->l0_dma;
>>>>>>>> -		eq->nxt_eqe_ba = 0;
>>>>>>>> +	/* alloc a tmp list for storing eq buf address */
>>>>>>>> +	ret = hns_roce_alloc_buf_list(&region, &buf_list, 1);
>>>>>>>> +	if (ret) {
>>>>>>>> +		dev_err(hr_dev->dev, "alloc eq buf_list error\n");
>>>>>>> The same comment like we gave for bnxt driver, no dev_* prints inside
>>>>>>> driver, use ibdev_*.
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>> Hi Leon,
>>>>>>
>>>>>> map_eq_buf() is called before ib_register_device(), so we can't use
>>>>>> ibdev_* here.
>>>>> As long as map_eq_buf() is called after ib_alloc_device(), you will be fine.
>>>>>
>>>>> Thanks
>>>>
>>>> Hi Leon,
>>>>
>>>> eq is used to queue hardware event, it should be ready before hardware is initialized.
>>>> So we can't call map_eq_buf() after ib_alloc_device().
>>>
>>> How can it be that your newly added function has hns_roce_dev in the
>>> signature and you didn't call to ib_alloc_device()?
>>>
>>>  +static int map_eq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_eq *eq,
>>>  +                u32 page_shift)
>>>
>>> Thanks
>>>
>>
>> Sorry, I confused ib_alloc_device() and ib_register_device(). What I was about to say is
>> ib_register_device().
>>
>> Order of these functions in hns driver is:
>>
>> 1. ib_alloc_device()
>> 2. map_eq_buf()
>> 3. ib_register_device()
>>
>> Refer to code in __ibdev_printk():
>>
>> 	else if (ibdev)
>> 		printk("%s%s: %pV",
>> 		       level, dev_name(&ibdev->dev), vaf);
>>
>>
>> If we called ibdev_*() before ib_register_device(), it will print "null" for the device
>> name. And I make a simple test, it will print like this:
>>
>> [   41.400347] (null): -------------- This is a test!----------
>>
>> Because map_eq_buf() should be finished before ib_register_device(), so I think we have
>> to use dev_*() in it.
> 
> Interesting, I wonder why "ibdev->dev" is set so late. I afraid that it
> is a bug in hns.
> 
> Thanks
> 

I will check the code in hns and ib core to find out the reasons. Thank you.

Weihang

>>
>>>>
>>>> Thanks
>>>> Weihang
>>>>
>>>>>
>>>>>> Thanks for your reminder, another patch that replace other dev_* in
>>>>>> hns driver with ibdev_* is on preparing.
>>>>>>
>>>>>> Weihang
>>>>>>
>>>>>>> .
>>>>>>>
>>>>> .
>>>>>
>>>>
>>>
>>> .
>>>
>>
> 
> .
> 

