From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Tue, 31 Mar 2015 11:48:24 -0400 (EDT)
Message-ID: <20150331.114824.651005354305268415.davem@davemloft.net>
References: <20150330.233602.155832546277570456.davem@davemloft.net>
	<CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g@mail.gmail.com>
	<CAJ3xEMjfbxt2Ouh4bhuf3_LMc7qY807h6FryvdCr0rr_gdiZAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjfbxt2Ouh4bhuf3_LMc7qY807h6FryvdCr0rr_gdiZAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, 31 Mar 2015 14:22:50 +0300

> On Tue, Mar 31, 2015 at 6:47 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> Roland, I have to genuinely agree with Or, that your handling of
>>> patch integration is sub-par and really painful for anyone actually
>>> trying to get real work done here.
>>>
>>> If you simply don't have the time to devote to constantly reviewing
>>> patches as they come in, and doing so in a timely manner, please let
>>> someone who is actually interested and has the time to take over.
>>
>> It's a fair criticism, and certainly for at least the last year or so
>> I have not had the time to do enough work as a maintainer.  I have
>> hope that some of the things that have been keeping me busy are dying
>> down and that I'll have more time to spend on handling the RDMA tree,
>> but that's just talk until I actually get more done.
> 
> Roland, well, with few variations, this goes way beyond a year. I
> would say more or less half of the time you're wearing the maintainer
> hat (2005-now). The practice of updating your for-next branch to rc1
> only few days/hours before the the kernel is out and the merge window
> opens, is an attitude, not lack of resources and will not be solved by
> whatever processes people suggest. You need to act differently.

Unfortunately, and no direct offense intend to you personally Roland,
but I agree with Or here.

If a person really cares about a subsystem they are marked at the
maintainer for, they usually _make_ the time necessary to apply
patches and attend to maintainership in a reasonable manner.

If this "once every merge window" behavior was limited to one release
cycle, I'd give the benefit of the doubt, but this has been going on
for a very long time.

You cannot on the one hand say "I care about this subsystem and the
long term maintainership and ABI stability of it" yet on the other
hand not be willing to put forth even the _MOST MINIMAL_ amount of
effort and time required to steadily review and apply patches over a
period of several years.

It doesn't take a lot of time to do this work, especially if you use
the correct tools.  I can review and apply 100 patches a day, even
when I'm on vacation.  I'm an extreme example, but what you're doing
right now Roland is not acceptable and is not in agreement with your
claims about how much you care about this subsystem.

If you processed the incoming patch queue even _once_ a week, we
wouldn't even be having this conversation.  But you haven't even been
doing that.

I get sick to my stomache when a patch gets to 3 days in my patch
queue, that's already too long.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
