From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH rdma-next 3/5] RDMA/hns: Increase checking CMQ status
 timeout value
Date: Wed, 23 May 2018 14:15:48 +0800
Message-ID: <5B050714.2040205@huawei.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-4-git-send-email-xavier.huwei@huawei.com>
 <20180523054918.GB2933@mtr-leonro.mtl.com> <5B0505A9.8040908@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5B0505A9.8040908@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org



On 2018/5/23 14:09, Wei Hu (Xavier) wrote:
>
> On 2018/5/23 13:49, Leon Romanovsky wrote:
>> On Thu, May 17, 2018 at 04:02:51PM +0800, Wei Hu (Xavier) wrote:
>>> This patch increases checking CMQ status timeout value and
>>> uses the same value with NIC driver to avoid deficiency of
>>> time.
>>>
>>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
>>> ---
>>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
>>> index 182b672..f16df1b 100644
>>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
>>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
>>> @@ -76,7 +76,7 @@
>>>  #define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFFF000
>>>  #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
>>>  #define HNS_ROCE_INVALID_LKEY			0x100
>>> -#define HNS_ROCE_CMQ_TX_TIMEOUT			200
>>> +#define HNS_ROCE_CMQ_TX_TIMEOUT			30000
>> Don't you think that loop of 30 seconds too much?
>>
>> Thanks
> Leon, 30ms
Because firmware take turns excuting NIC and RoCE command.
Although RoCE command does not  take so long,  we still use
the same timeout value with NIC driver.
Thanks
>>>  #define HNS_ROCE_CONTEXT_HOP_NUM		1
>>>  #define HNS_ROCE_MTT_HOP_NUM			1
>>> --
>>> 1.9.1
>>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> .
>
