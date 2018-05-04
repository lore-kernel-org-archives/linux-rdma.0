From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-next 05/14] IB/hfi1: Use after free race condition in
 send context error path
Date: Fri, 4 May 2018 16:01:04 -0400
Message-ID: <add45f95-61e0-aa96-6738-08c15a234f33@intel.com>
References: <20180502133831.20730.42677.stgit@scvm10.sc.intel.com>
 <20180502134249.20730.78919.stgit@scvm10.sc.intel.com>
 <20180504183839.6wexn5phhiyo6xra@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180504183839.6wexn5phhiyo6xra@ziepe.ca>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/4/2018 2:38 PM, Jason Gunthorpe wrote:
> On Wed, May 02, 2018 at 06:42:51AM -0700, Dennis Dalessandro wrote:
>> From: Michael J. Ruhl <michael.j.ruhl@intel.com>
>>
>> A pio send egress error can occur when the PSM library attempts to
>> to send a bad packet.  That issue is still being investigated.
>>
>> The pio error interrupt handler then attempts to progress the recovery
>> of the errored pio send context.
>>
>> Code inspection reveals that the handling lacks the necessary locking
>> if that recovery interleaves with a PSM close of the "context" object
>> contains the pio send context.
>>
>> The lack of the locking can cause the recovery to access the already
>> freed pio send context object and incorrectly deduce that the pio
>> send context is actually a kernel pio send context as shown by the
>> NULL deref stack below:
>>
>> [<ffffffff8143d78c>] _dev_info+0x6c/0x90
>> [<ffffffffc0613230>] sc_restart+0x70/0x1f0 [hfi1]
>> [<ffffffff816ab124>] ? __schedule+0x424/0x9b0
>> [<ffffffffc06133c5>] sc_halted+0x15/0x20 [hfi1]
>> [<ffffffff810aa3ba>] process_one_work+0x17a/0x440
>> [<ffffffff810ab086>] worker_thread+0x126/0x3c0
>> [<ffffffff810aaf60>] ? manage_workers.isra.24+0x2a0/0x2a0
>> [<ffffffff810b252f>] kthread+0xcf/0xe0
>> [<ffffffff810b2460>] ? insert_kthread_work+0x40/0x40
>> [<ffffffff816b8798>] ret_from_fork+0x58/0x90
>> [<ffffffff810b2460>] ? insert_kthread_work+0x40/0x40
>>
>> This is the best case scenario and other scenarios can corrupt the
>> already freed memory.
>>
>> Fix by adding the necessary locking in the pio send context error
>> handler.
>>
>> Cc: <stable@vger.kernel.org> # 4.9.x
>> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
>> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>> Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>> ---
>>   drivers/infiniband/hw/hfi1/chip.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
> 
> Why are you sending this to for-next not for-rc?

I went back and forth on this one. In the end decided against it because 
we've lived with it for so long, note stable tag is all the way back to 
4.9, that and the fact that it's extremely unlikely to occur. I would be 
fine including it with the -rc though. I think a case could be made 
either way.

-Denny
