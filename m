From: Sagar Arun Kamble <sagar.a.kamble-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Creating cyclecounter and lock member in timecounter structure [
 Was Re: [RFC 1/4] drm/i915/perf: Add support to correlate GPU timestamp with
 system time]
Date: Mon, 27 Nov 2017 15:35:38 +0530
Message-ID: <63a2a495-1bdb-5d47-1202-9b538e9601d8@intel.com>
References: <1510748034-14034-1-git-send-email-sagar.a.kamble@intel.com>
 <1510748034-14034-2-git-send-email-sagar.a.kamble@intel.com>
 <151074872901.26264.3145709294590477412@mail.alporthouse.com>
 <d529503f-2eb3-b353-763d-901235383c6c@intel.com>
 <alpine.DEB.2.20.1711231947280.2364@nanos>
 <83805c37-99b2-2922-e8e8-ea435f9da7d0@intel.com>
 <alpine.DEB.2.20.1711241429050.1757@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711241429050.1757@nanos>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 11/24/2017 7:01 PM, Thomas Gleixner wrote:
> On Fri, 24 Nov 2017, Sagar Arun Kamble wrote:
>> On 11/24/2017 12:29 AM, Thomas Gleixner wrote:
>>> On Thu, 23 Nov 2017, Sagar Arun Kamble wrote:
>>>> We needed inputs on possible optimization that can be done to
>>>> timecounter/cyclecounter structures/usage.
>>>> This mail is in response to review of patch
>>>> https://patchwork.freedesktop.org/patch/188448/.
>>>>
>>>> As Chris's observation below, about dozen of timecounter users in the
>>>> kernel
>>>> have below structures
>>>> defined individually:
>>>>
>>>> spinlock_t lock;
>>>> struct cyclecounter cc;
>>>> struct timecounter tc;
>>>>
>>>> Can we move lock and cc to tc? That way it will be convenient.
>>>> Also it will allow unifying the locking/overflow watchdog handling across
>>>> all
>>>> drivers.
>>> Looks like none of the timecounter usage sites has a real need to separate
>>> timecounter and cyclecounter.
>> Yes. Will share patch for this change.
>>
>>> The lock is a different question. The locking of the various drivers
>>> differs and I have no idea how you want to handle that. Just sticking the
>>> lock into the datastructure and then not making use of it in the
>>> timercounter code and leave it to the callsites does not make sense.
>> Most of the locks are held around timecounter_read. In some instances it
>> is held when cyclecounter is updated standalone or is updated along with
>> timecounter calls.  Was thinking if we move the lock in timecounter
>> functions, drivers just have to do locking around its operations on
>> cyclecounter. But then another problem I see is there are variation of
>> locking calls like lock_irqsave, lock_bh, write_lock_irqsave (some using
>> rwlock_t). Should this all locking be left to driver only then?
> You could have the lock in the struct and protect the inner workings in the
> related core functions.
>
> That might remove locking requirements from some of the callers and the
> others still have their own thing around it.

For drivers having static/fixed cyclecounter, we can rely only on lock inside timecounter.
Most of the network drivers update cyclecounter at runtime and they will have to rely on two locks if
we add one to timecounter. This may not be efficient for them. Also the lock in timecounter has to be less restrictive (may be seqlock) I guess.

Cc'd Mellanox list for inputs on this.

I have started feeling that the current approach of drivers managing the locks is the right one so better leave the
lock out of timecounter.

> Thanks,
>
> 	tglx

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
