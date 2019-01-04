From: YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH -next] IB/qib: Add missing err handle for
 qib_user_sdma_rb_insert
Date: Fri, 4 Jan 2019 14:08:57 +0800
Message-ID: <ca55a85f-77d2-fd69-8aaf-d3ada07eed75@huawei.com>
References: <20181221021938.13784-1-yuehaibing@huawei.com>
 <20190102171224.GA26765@ziepe.ca> <20190102184050.GI5424@mtr-leonro.mtl.com>
 <20190102190740.GH26211@ziepe.ca> <20190102192211.GJ5424@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190102192211.GJ5424@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


On 2019/1/3 3:22, Leon Romanovsky wrote:> On Wed, Jan 02, 2019 at 12:07:40PM -0700, Jason Gunthorpe wrote:
>> On Wed, Jan 02, 2019 at 08:40:50PM +0200, Leon Romanovsky wrote:
>>> On Wed, Jan 02, 2019 at 10:12:24AM -0700, Jason Gunthorpe wrote:
>>>> On Fri, Dec 21, 2018 at 10:19:38AM +0800, YueHaibing wrote:
>>>>> It should goto err handle if qib_user_sdma_rb_insert fails,
>>>>> other than success return.
>>>>>
>>>>> Fixes: 67810e8c3c01 ("RDMA/qib: Remove all occurrences of BUG_ON()")
>>>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>>>>  drivers/infiniband/hw/qib/qib_user_sdma.c | 2 ++
>>>>>  1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
>>>>> index 31c523b..e87c0a7 100644
>>>>> +++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
>>>>> @@ -237,6 +237,8 @@ qib_user_sdma_queue_create(struct device *dev, int unit, int ctxt, int sctxt)
>>>>>
>>>>>  		ret = qib_user_sdma_rb_insert(&qib_user_sdma_rb_root,
>>>>>  					sdma_rb_node);
>>>>> +		if (ret == 0)
>>>>> +			goto err_rb;
>>>>>  	}
>>>>
>>>> This doesn't look right, what about undoing the kmalloc directly
>>>> above?
>>>
>>> Back then, I came to conclusion that qib_user_sdma_rb_insert() never
>>> returns 0. Otherwise, Dennis would see that BUG_ON() for a long time
>>> ago.
>>
>> It fails if the index is in the RB tree, which would indicate a
>> programming bug.
> 
> I tried to say that this programming bug doesn't exist in the reality.

In view of this, leave it just as this.
> 
>>
>> The way to replace the BUG_ON is something like:
>>
>> if (WARN_ON(ret == 0)) {
>>     kfree()
>>     goto err_rb;
>> }
>>
>> Jason
