From: Shaobo He <shaobo@cs.utah.edu>
Subject: Re: [PATCH] cxgb4: fix undefined behavior in mem.c
Date: Thu, 28 Feb 2019 16:18:40 -0700
Message-ID: <abf425b1-19ba-9cf5-8288-87ac0dbf6ac7@cs.utah.edu>
References: <1551393519-96595-1-git-send-email-shaobo@cs.utah.edu>
 <1551394596.31902.209.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551394596.31902.209.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org
Cc: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

I can't afford a pdf version of the C standard. So I looked at the draft version 
used in the link I put in the commit message. It says (in 6.2.4:2),

```
The lifetime of an object is the portion of program execution during which 
storage is guaranteed to be reserved for it. An object exists, has a constant 
address, and retains its last-stored value throughout its lifetime. If an object 
is referred to outside of its lifetime, the behavior is undefined. The value of 
a pointer becomes indeterminate when the object it points to (or just past) 
reaches the end of its lifetime.
```
I couldn't find the definition of lifetime over a dynamically allocated object 
in the draft of C standard. I refer to this link 
(https://en.cppreference.com/w/c/language/lifetime) which suggests that the 
lifetime of an allocated object ends after the deallocation function is called 
upon it.

I think maybe the more problematic issue is that the value of a freed pointer is 
intermediate.

Shaobo
On 2/28/19 3:56 PM, Bart Van Assche wrote:
> On Thu, 2019-02-28 at 15:38 -0700, Shaobo He wrote:
>> In function `c4iw_dealloc_mw`, variable mhp's value is printed after
>> freed, which triggers undefined behavior according to this post:
>> https://trust-in-soft.com/dangling-pointer-indeterminate/.
>>
>> This commit fixes it by swapping the order of `kfree` and `pr_debug`.
>>
>> Signed-off-by: Shaobo He <shaobo@cs.utah.edu>
>> ---
>>   drivers/infiniband/hw/cxgb4/mem.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
>> index 7b76e6f..bb8e0bc 100644
>> --- a/drivers/infiniband/hw/cxgb4/mem.c
>> +++ b/drivers/infiniband/hw/cxgb4/mem.c
>> @@ -684,8 +684,8 @@ int c4iw_dealloc_mw(struct ib_mw *mw)
>>   			  mhp->wr_waitp);
>>   	kfree_skb(mhp->dereg_skb);
>>   	c4iw_put_wr_wait(mhp->wr_waitp);
>> -	kfree(mhp);
>>   	pr_debug("ib_mw %p mmid 0x%x ptr %p\n", mw, mmid, mhp);
>> +	kfree(mhp);
>>   	return 0;
>>   }
> 
> Please quote the relevant paragraphs from the C standard. All I have found
> about free() in ISO/IEC 9899:2017 is the following:
> 
> Description
> The free function causes the space pointed to by ptr to be deallocated, that
> is, made available for further allocation. If ptr is a null pointer, no
> action occurs. Otherwise, if the argument does not match a pointer earlier
> returned by a memory management function, or if the space has been
> deallocated by a call to free or realloc, the behavior is undefined.
> 
> That is not sufficient to claim that the above code triggers undefined
> behavior.
> 
> Bart.
> 
