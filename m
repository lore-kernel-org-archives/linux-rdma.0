From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Tue, 26 May 2015 23:39:04 +0300
Message-ID: <CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A@mail.gmail.com>
References: <20150519191553.GP18675@obsidianresearch.com>
	<CAJ3xEMjj31SpZmYXORCePVCQfMOWVKEhtNay-v59FcnCOQWm9w@mail.gmail.com>
	<20150520002915.GD16941@obsidianresearch.com>
	<555C9D00.2090609@mellanox.com>
	<1432134677.5304.23.camel@opteya.com>
	<CAJ3xEMjO2HqFePAwXnoCt0rCzRLfYbqdP+883v4LaMovj7Y-FA@mail.gmail.com>
	<CAJ3xEMgppUPqOFm7L0+fR3z_N2ALZFb+GpSAGvyyNROZoFCUPA@mail.gmail.com>
	<CAJ3xEMinNsQrmQ7atAVkshefBDBQ1HRuGbOT_cJ4RxEj4dWUPA@mail.gmail.com>
	<20150526160624.GA11800@obsidianresearch.com>
	<CAJ3xEMj5qphSq5QQHKPsihuK6StmJ+NHiPbkY-ZVGmpViB1AXA@mail.gmail.com>
	<20150526185315.GF11800@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150526185315.GF11800-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 26, 2015 at 9:53 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, May 26, 2015 at 09:33:18PM +0300, Or Gerlitz wrote:
>> On Tue, May 26, 2015 at 7:06 PM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > On Tue, May 26, 2015 at 11:10:45AM +0300, Or Gerlitz wrote:
>> >
>> >> Jason, ping, it's fair to require that if you made a review argument against
>> >> the design done here and we've responded about a week ago, saying why
>> >> this design is valid (e.g goes along the 10y old IB stack udata mechanism and
>> >> such) -- you would comment on the response and not  leave it in the air.
>> >
>> > Was it not clear? Yann and I asked to see the user space side before
>> > reviewing this series further.
>>
>> Jason, you (U2 BTW) play really, really hard - refusing to say **one**
>> word on your approach towards the built-in udata mechanism for uverbs
>> which I asked you to comment on.

> And I asked to see the user space side and you have angrily refused
> every time.

AFAIR I never ever refused to show any piece of code which went under
my hands towards Linux to any-one.

> So I guess we are both playing hard.

I disagree, you act as sort of being the boss here, stating every now
and then your preferences and way of engineering things as the
ultimate guidelines for Linux and/or RDMA engineering.

> FWIW, your comments on udata seemed compelling

Good to hear

> but I want to see the whole solution before saying I'm OK with it.

go look, not the final cut but should be close to what we'll submit

https://github.com/matanb10/libibverbs timestamp-v0
https://github.com/matanb10/libmlx4 timestamp-v0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
