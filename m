From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Mon, 30 May 2016 10:47:29 +0300
Message-ID: <4958edf4-7296-26c9-4cbe-8fab45be11a3@mellanox.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
 <574B6F71.9060808@redhat.com> <20160529233009.GA12420@obsidianresearch.com>
 <8F7BC9E2-75EC-413B-BEBE-11450225AF06@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8F7BC9E2-75EC-413B-BEBE-11450225AF06-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 30/05/2016 02:47, Doug Ledford wrote:
>
>
> Sent from my iPhone
>
>> On May 29, 2016, at 7:30 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>>
>>> On Sun, May 29, 2016 at 06:38:41PM -0400, Doug Ledford wrote:
>>>
>>> So I've been busy with kernel stuff, but I don't really like this patch.
>>> I'm not really enamored with the entire poll_ex API.
>>
>> You should really read the whole prior discussion
>
> If there's something in particular you'd like to point out, feel free.
>
>>> First, I don't like the start_poll/poll/end_poll setup.  I would rather
>>> we do something like using refcounting on the WCs.  Maybe something like
>>> returning an array of pointers to WCs where each WC already has a
>>> ref
>>
>> Refs? Yuk. That doesn't fit the typical use model, and refs
>> involve more expensive locking per wc.
>
> It doesn't have to be refs. If I recall correctly, the libmlx4 driver has to clear each cqe by changing the ownership status back to the hardware or something like that. The release could just as easily be setting that ownership on the cqe.
>
>>> When a cq is created by the driver, it is responsible for filling out
>>> the offsets array (can be static if your driver only has one CQE
>>> format,
>>
>> *shrug* Careful benchmarking would have to prove if this is better or
>> not.
>
> Agreed.
>
>> Based on Yishai's comments I expect it is not better, since I
>> expect an offsets array to perform worse than the original bitmask
>> thing.
>
> The original bitmask version included a copy to an interim, variable struct.  The idea here is that the cqe is an opaque pointer directly to the hardware cqe. There would be no interim copies, just retrieving the desired data directly from the cqe. Maybe I should have called it a hcqe to be more clear.
>
>> Yishai's said this benchmarked better than the bitmask
>
> I would totally expect that. The bitmap version had both a data copy and a variable struct requiring lots of branches.
>

Incorrect, the driver part of the bitmap version was optimized as such 
it had a specific poll function for every common variable struct - so 
effectively you didn't (or almost didn't) have any branches.
The indirect function call + copying all required user fields to the 
ibv_wc_ex struct and then back to the user killed it.

>> and equal to
>> or better than today's versions..
>
> Today's version has a data copy. What I'm suggesting here eliminates that entirely and all of the branches can be optimized away at compile time, leaving a load from a hot cache line of an offset value and then a direct load from that offset in the hcqe. I would think that because of the elimination of the data copy and the compile time elimination of branches, this has the potential to meet or exceed today's implementation. I would certainly like to see the numbers.
>

Not necessarily, smart compiler could fetch the data straight from the 
hardware's CQE and pass it through a register.

>> This is a whole picture optimization and the user side is only one
>> part of the equation - the function pointer scheme is also optimizing
>> the driver path quite heavily, which is why it is showing positively
>> in benchmarks.
>
> Passing an opaque hcqe pointer to the user and then only getting the data they want out of it should similarly help optimize the driver's path I would think.
>

What if the driver's CQE format has a field which is split between two 
different offsets?
We looked at storing offsets and masks before implementing this and 
supplying inline functions to get the various fields, but IMHO, that's a 
no go as it's not generic enough.

Anyway, if you really want to tie yourself to one vendor, maybe we could 
allow static linking with the user-space driver and by using lto you 
could get inline-like function behavior.


Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
