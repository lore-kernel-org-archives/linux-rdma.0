From: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Mon, 30 May 2016 18:01:24 +0300
Message-ID: <ecdbec76-31cd-74e1-25b4-7d60c3fa2af0@mellanox.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
 <574B6F71.9060808@redhat.com> <20160529233009.GA12420@obsidianresearch.com>
 <8F7BC9E2-75EC-413B-BEBE-11450225AF06@redhat.com>
 <4958edf4-7296-26c9-4cbe-8fab45be11a3@mellanox.com>
 <4e8befc4-aec5-a17d-24ce-40ff97d345da@redhat.com>
 <8708a378-4c48-df98-86a4-d210bbe690b5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8708a378-4c48-df98-86a4-d210bbe690b5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 30/05/2016 16:50, Doug Ledford wrote:
> Resend because of my mailer...
>
> On 05/30/2016 09:46 AM, Doug Ledford wrote:
>> On 05/30/2016 03:47 AM, Matan Barak wrote:
>>> On 30/05/2016 02:47, Doug Ledford wrote:
>>
>>>> Today's version has a data copy. What I'm suggesting here eliminates
>>>> that entirely and all of the branches can be optimized away at compile
>>>> time, leaving a load from a hot cache line of an offset value and then
>>>> a direct load from that offset in the hcqe. I would think that because
>>>> of the elimination of the data copy and the compile time elimination
>>>> of branches, this has the potential to meet or exceed today's
>>>> implementation. I would certainly like to see the numbers.
>>>>
>>>
>>> Not necessarily, smart compiler could fetch the data straight from the
>>> hardware's CQE and pass it through a register.
>>
>> Not while still maintaining multi-device capability.  What I laid out
>> works without having to compile for a specific piece of hardware.
>>

It has nothing to do with multi-device capability. For example, in 
cdecl, integer values are returned thorough EAX (RAX) register.

>>>>> This is a whole picture optimization and the user side is only one
>>>>> part of the equation - the function pointer scheme is also optimizing
>>>>> the driver path quite heavily, which is why it is showing positively
>>>>> in benchmarks.
>>>>
>>>> Passing an opaque hcqe pointer to the user and then only getting the
>>>> data they want out of it should similarly help optimize the driver's
>>>> path I would think.
>>>>
>>>
>>> What if the driver's CQE format has a field which is split between two
>>> different offsets?
>>
>> I have an idea for that as well.
>>
>>> We looked at storing offsets and masks before implementing this and
>>> supplying inline functions to get the various fields, but IMHO, that's a
>>> no go as it's not generic enough.
>>>
>>> Anyway, if you really want to tie yourself to one vendor, maybe we could
>>> allow static linking with the user-space driver and by using lto you
>>> could get inline-like function behavior.
>>
>> No, what I'm outlining works with multi-vendor support.  It's opaque to
>> the user application.
>>
>> Now, as to how to handle complex fields.
>>
>> I was thinking of making the wc_elements enum encode some complex
>> information.  Right now, it's just the offset number.  It would be
>> possible to set each particular element as either A) simple offset, B)
>> possibly complex (which means some vendors can do a simple offset and
>> others need a complex function), or C) all complex.  Then the #define
>> can be made smart enough to know the difference and on simple items
>> return the data, on possibly complex items you have an if statement and
>> branch so we avoid this when possible but allows different hardware
>> types to be handled, and on always complex items we are able to optimize
>> down to just the call in the compiler.  Although, I freely admit that if
>> you have more than just a handful of these complex items then it likely
>> becomes cleaner to just do the "function call per wc element" way of
>> doing things like your patch has.  But I doubt there are that many
>> complex items in your CQE.  Do you have a count?
>>
>>
>>

So, you suggest that "simple" attributes will take into account 
byte_offset, bit_offset, bits_size (or mask) and endianity. While the 
right endianity conversion function will be chosen by inspecting the 
bits_size?
Of course, this is in addition to the attribute's nature 
(simple/possible simple/complex), which we need to condition on that too.
This doesn't sound simple for me and I'm afraid it will affect 
performance more than just a real simple function call.

In addition, can we guarantee that for "simple" attribute we won't have 
any future "non-simple" vendors? If such a vendor comes up, the binary 
compatibility will break, since the attributes nature is encoded in the 
libibverbs inlined functions. Unless old applications are recompiled, 
you won't be able to use this new hardware.

Common fields (status and wr_id) are already stored in ibv_cq_ex and 
accessed directly, so we don't "pay" penalty for this fields.

There might not be a lot of complex fields in mlx5 based hardware (a 
quick count found only a few), but accessing the "simple" fields isn't 
that simple and requires a lot of logic.

The proposed API is clean, usable and simple both in respect of the 
application API and the vendor's API.

Matan and Yishai

>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
