From: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Tue, 1 Mar 2016 10:52:33 +0200
Message-ID: <56D55851.60206@mellanox.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
 <1456306924-31298-2-git-send-email-yishaih@mellanox.com>
 <20160224190230.GA10588@obsidianresearch.com>
 <56CEB4C7.60607@dev.mellanox.co.il>
 <20160225170541.GA22513@obsidianresearch.com> <56D31A58.20205@mellanox.com>
 <20160229191734.GA15042@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160229191734.GA15042-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 29/02/2016 21:17, Jason Gunthorpe wrote:
> On Sun, Feb 28, 2016 at 06:03:36PM +0200, Matan Barak (External) wrote:
>
>>> The manual page and rc_pingpong do different things.
>>
>> There are two options to use the API. They are both described well in the
>> man page. This example uses the more trivial and easy-to-use way.
>
> Gross.
>
>>> This still looks like a horrible user API.
>>>
>>
>> Why do you think so?
>
> By my count it scores about a 2 on the Rusty API scale, which is
> pretty bad.
>

This is like writing something that means nothing....
Opinions are always appreciated if they contain valid arguments, so please.

>> We want to present a completion structure that could be extended, without
>> adding the overhead of setting unnecessary fields and without risking that
>> adding future attributes will make the completion be bigger than a cache
>> line (and create a great penalty). This also came up in the earlier
>> libibverbs API discussion.
>
> This series trade cache line efficiency for computation efficiency,
> and it isn't at all clear to me that is going to be a win. Better
> include some good benchmarks.
>

WRONG. Which computational overhead are you talking about?
The user-space driver could optimize the common cases and eliminate 
*almost* all extra computational overhead (this is done in libmlx4 and 
libmlx5 user-space drivers).
Even if there was such an overhead, this is not related to the API. 
Future hardwares could do that even entirely in hardware eliminating 
this all together.

> Hint: Cacheline size is much less important if the cache lines are
> resident and dirty, and the driver writes make them dirty. The driver
> should be dirtying them in a way that avoids a RMW penalty.
>

The user-space driver writes one completion at a time, which (depending 
on the user configuration) is probably less than a cache line. Why do 
you think it's worse than how ibv_poll_cq behaves? The way the 
user-space driver optimizes/dirties the cache line is unrelated to the API.

>> We could introduce a verb for every new field (poll_cq_ts), but what will a
>> user do if he wants new_feature_a and new_feature_b from the same
>> completion? In addition, polluting libibverbs with so many polling verbs is
>> (to say the least) awkward.
>
> As opposed to asking the user to hand craft structures and use ugly
> awkward macros?
>

Function per every completion fields permutation is uglier for sure 
(there are currently 9 optional completion fields in this proposal, you 
could easily do the math to calculate how many permutations we have).

> I'd say give it another think and try and make the user facing API
> saner.
>

Lets think of the main requirement here - an extensible way of getting 
completions with only user required data. So either you give an explicit 
function for every permutation - which is pretty awful (to say the 
least) or you have a way to say "this is what I want" and "if the vendor 
reported this field, please give it to me".

Since it could be possible telling a future hardware "I'm only 
interested in these fields in a CQ", the second approach seems to be better.

> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
