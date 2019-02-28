From: Shaobo He <shaobo@cs.utah.edu>
Subject: Re: [PATCH] cxgb4: fix undefined behavior in mem.c
Date: Thu, 28 Feb 2019 16:57:06 -0700
Message-ID: <a03cc0b7-c508-4937-f2dc-c5f9dbc356ba@cs.utah.edu>
References: <1551393519-96595-1-git-send-email-shaobo@cs.utah.edu>
 <1551394596.31902.209.camel@acm.org>
 <abf425b1-19ba-9cf5-8288-87ac0dbf6ac7@cs.utah.edu>
 <1551396788.31902.213.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551396788.31902.213.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org
Cc: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Good catch. But if we agree on that memory management functions are those 
specified by the C standard, would it be OK to ignore so-called use after free 
or double free bugs for the kernel as C standard does not apply to kfree?

On 2/28/19 4:33 PM, Bart Van Assche wrote:
> On Thu, 2019-02-28 at 16:18 -0700, Shaobo He wrote:
>> I can't afford a pdf version of the C standard. So I looked at the draft version
>> used in the link I put in the commit message. It says (in 6.2.4:2),
>>
>> ```
>> The lifetime of an object is the portion of program execution during which
>> storage is guaranteed to be reserved for it. An object exists, has a constant
>> address, and retains its last-stored value throughout its lifetime. If an object
>> is referred to outside of its lifetime, the behavior is undefined. The value of
>> a pointer becomes indeterminate when the object it points to (or just past)
>> reaches the end of its lifetime.
>> ```
>> I couldn't find the definition of lifetime over a dynamically allocated object
>> in the draft of C standard. I refer to this link
>> (https://en.cppreference.com/w/c/language/lifetime) which suggests that the
>> lifetime of an allocated object ends after the deallocation function is called
>> upon it.
>>
>> I think maybe the more problematic issue is that the value of a freed pointer is
>> intermediate.
> 
> In another section of the same draft I found the following:
> 
> J.2 Undefined behavior [ ... ] The value of a pointer that refers to space
> deallocated by a call to the free or realloc function is used (7.22.3).
> 
> Since the C standard explicitly refers to free() and realloc(), does that
> mean that that statement about undefined behavior does not apply to munmap()
> (for user space code) nor to kfree() (for kernel code)?
> 
> Bart.
> 
