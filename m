From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] RDMA/hns: Use 64-bit arithmetic instead of 32-bit
Date: Mon, 22 Oct 2018 20:22:06 +0200
Message-ID: <508a9428-53d3-2e2f-1e6a-44d9c67d31ed@embeddedor.com>
References: <20181018080258.GA1720@embeddedor.com>
 <20181022181523.GB30059@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181022181523.GB30059@ziepe.ca>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 10/22/18 8:15 PM, Jason Gunthorpe wrote:
> On Thu, Oct 18, 2018 at 10:02:58AM +0200, Gustavo A. R. Silva wrote:
>> Cast *max_num_sg* to u64 in order to give the compiler complete
>> information about the proper arithmetic to use.
>>
>> Notice that such variable is used in a context that expects an
>> expression of type u64 (64 bits, unsigned) and the following
>> expression is currently being evaluated using 32-bit
>> arithmetic:
>>
>> length = max_num_sg * page_size;
>>
>> Addresses-Coverity-ID: 1474517 ("Unintentional integer overflow")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>  drivers/infiniband/hw/hns/hns_roce_mr.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
>> index 521ad2a..d479d5e 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
>> @@ -1219,7 +1219,7 @@ struct ib_mr *hns_roce_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
>>  	int ret;
>>  
>>  	page_size = 1 << (hr_dev->caps.pbl_buf_pg_sz + PAGE_SHIFT);
>> -	length = max_num_sg * page_size;
>> +	length = (u64)max_num_sg * page_size;
> 
> This should be done with check_mul_overflow() which will also force
> the input types to the correct thing.
> 

Yep, you're right. That's part of the new API for checking overflows.

I'll use that macro.

> alloc_mr is callable from userspace so the potential overflow here
> should not be ignored.
> 

Thanks for the feedback.
--
Gustavo
