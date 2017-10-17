From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH for-next 3/4] RDMA/hns: Update the IRRL table chunk size
 in hip08
Date: Tue, 17 Oct 2017 19:40:38 +0800
Message-ID: <59E5EC36.90207@huawei.com>
References: <1506763741-81429-1-git-send-email-xavier.huwei@huawei.com>
 <1506763741-81429-4-git-send-email-xavier.huwei@huawei.com>
 <20171001054037.GB2031@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171001054037.GB2031@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, shaobo.xu@intel.com, zhangxiping3@huawei.com, xavier.huwei@tom.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com, shaoboxu@tom.com
List-Id: linux-rdma@vger.kernel.org



On 2017/10/1 13:40, Leon Romanovsky wrote:
> On Sat, Sep 30, 2017 at 05:29:00PM +0800, Wei Hu (Xavier) wrote:
>> As the increase of the IRRL specification in hip08, the IRRL table
>> chunk size needs to be updated.
>> This patch updates the IRRL table chunk size to 256k for hip08.
>>
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
>> Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
>> Signed-off-by: Lijun Ou <oulijun@huawei.com>
>> ---
>>   drivers/infiniband/hw/hns/hns_roce_device.h |  3 +++
>>   drivers/infiniband/hw/hns/hns_roce_hem.c    | 31 ++++++++++++++---------------
>>   drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  1 +
>>   drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |  2 ++
>>   drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  1 +
>>   drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  2 ++
>>   6 files changed, 24 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
>> index 9353400..fc2a53d 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
>> @@ -236,6 +236,8 @@ struct hns_roce_hem_table {
>>   	unsigned long	num_obj;
>>   	/*Single obj size */
>>   	unsigned long	obj_size;
>> +	unsigned long	table_chunk_size;
>> +	unsigned long	hem_alloc_size;
>>   	int		lowmem;
>>   	struct mutex	mutex;
>>   	struct hns_roce_hem **hem;
>> @@ -565,6 +567,7 @@ struct hns_roce_caps {
>>   	u32		cqe_ba_pg_sz;
>>   	u32		cqe_buf_pg_sz;
>>   	u32		cqe_hop_num;
>> +	u32		chunk_sz;	/* chunk size in non multihop mode*/
>>   };
> Hi,
>
> I have two comments:
> 1. In this code table_chunk_size is equal and similar to hem_alloc_size.
> Please don't introduce unneeded complexity.
Hi, Leon
     ok, we will delete hem_alloc_size.
Thanks.
> 2. The size of table is num_obj * obj_size, there is no need to
> table_chunk_size and hem_alloc_size at all. There are plenty of macros in
> the kernel to deal with the tables.
Hi, Leon
     chunk size is limited by the hardware and is max access capactiy by 
hardware in hip06 and hip08 SoC.
     For exmple, chunk size is 128K in hip06 and 256K in hip08.
Thanks
> Thanks
