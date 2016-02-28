From: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Sun, 28 Feb 2016 18:03:36 +0200
Message-ID: <56D31A58.20205@mellanox.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
 <1456306924-31298-2-git-send-email-yishaih@mellanox.com>
 <20160224190230.GA10588@obsidianresearch.com>
 <56CEB4C7.60607@dev.mellanox.co.il>
 <20160225170541.GA22513@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160225170541.GA22513-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 25/02/2016 19:05, Jason Gunthorpe wrote:
> On Thu, Feb 25, 2016 at 10:01:11AM +0200, Yishai Hadas wrote:
>> On 2/24/2016 9:02 PM, Jason Gunthorpe wrote:
>>> On Wed, Feb 24, 2016 at 11:41:57AM +0200, Yishai Hadas wrote:
>>>
>>>> +enum {
>>>> +	IBV_WC_EX_WITH_8BIT_FIELDS = IBV_WC_EX_WITH_SL			|
>>>> +				     IBV_WC_EX_WITH_DLID_PATH_BITS
>>>> +};
>>>> +
>>>> +struct ibv_wc_ex {
>>>> +	uint64_t		wr_id;
>>>> +	/* wc_flags is a combination of ibv_wc_flags_ex flags. The IBV_WC_EX_WITH_XXX
>>>> +	 * flags dynamically define the valid fields in buffer[0].
>>>> +	 */
>>>> +	uint64_t		wc_flags;
>>>> +	uint32_t		status;
>>>> +	uint32_t		opcode;
>>>> +	uint32_t		vendor_err;
>>>> +	uint32_t		reserved;
>>>> +	uint8_t			buffer[0];
>>>> +};
>>>
>>> Um, maybe you should give an example of how on earth anyone is
>>> supposed to use this, all of this looks like a *really bad idea* to
>>> me.
>>>
>>
>> The last patch is this series is a clear example of a typical usage of.
>> It was added as part of rc_pingpong, please look at.
>>
>> In addition, there are detailed man pages that describe the idea/usage of
>> the new verbs around, see patch #7.
>
> The manual page and rc_pingpong do different things.
>

There are two options to use the API. They are both described well in 
the man page. This example uses the more trivial and easy-to-use way.

> This still looks like a horrible user API.
>

Why do you think so?

We want to present a completion structure that could be extended, 
without adding the overhead of setting unnecessary fields and without 
risking that adding future attributes will make the completion be bigger 
than a cache line (and create a great penalty). This also came up in the 
earlier libibverbs API discussion.

We could introduce a verb for every new field (poll_cq_ts), but what 
will a user do if he wants new_feature_a and new_feature_b from the same 
completion? In addition, polluting libibverbs with so many polling verbs 
is (to say the least) awkward.

The second option we could think of is to give the user a way to define 
which fields he would like to get - not wasting time, space and cache 
lines on fields he doesn't want. If we could do that automatically, it 
would of course be better (for example, a smart JIT or a compiler that 
compiles the user-space application along with the vendor libraries 
might be able to do that automatically. Even then, in low level 
languages it won't optimize the data layout), but since in the current 
way we work I don't see a way we could do that, I think it's best to add 
that to the API.

The user defines which fields interest him via create_cq_ex and then get 
a compact struct that consists only of the fields he need, sorted in a 
way that avoids holes if possible (alignment wise). This API guaranteed 
to be extensible without penalty and be backward compatible. In respect 
to the discussion we had on list when the kernel part was introduced, we 
believe this API represents a valid choice to fill all the requirements.

> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
