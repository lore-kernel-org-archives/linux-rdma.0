From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Thu, 28 May 2015 00:33:58 +0300
Message-ID: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com>
References: <1432134677.5304.23.camel@opteya.com>
	<CAJ3xEMjO2HqFePAwXnoCt0rCzRLfYbqdP+883v4LaMovj7Y-FA@mail.gmail.com>
	<CAJ3xEMgppUPqOFm7L0+fR3z_N2ALZFb+GpSAGvyyNROZoFCUPA@mail.gmail.com>
	<CAJ3xEMinNsQrmQ7atAVkshefBDBQ1HRuGbOT_cJ4RxEj4dWUPA@mail.gmail.com>
	<20150526160624.GA11800@obsidianresearch.com>
	<CAJ3xEMj5qphSq5QQHKPsihuK6StmJ+NHiPbkY-ZVGmpViB1AXA@mail.gmail.com>
	<20150526185315.GF11800@obsidianresearch.com>
	<CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A@mail.gmail.com>
	<20150526220724.GC4502@obsidianresearch.com>
	<CAJ3xEMgdqBnn6hobRJFut6Nyu2pKt40rb46Z3dYx3MaohR2urA@mail.gmail.com>
	<20150527184856.GA16059@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150527184856.GA16059-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 27, 2015 at 9:48 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, May 27, 2015 at 02:54:12PM +0300, Or Gerlitz wrote:
>> On Wed, May 27, 2015 at 1:07 AM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > On Tue, May 26, 2015 at 11:39:04PM +0300, Or Gerlitz wrote:
>> >> >> Jason, you (U2 BTW) play really, really hard - refusing to say **one**
>> >> >> word on your approach towards the built-in udata mechanism for uverbs
>> >> >> which I asked you to comment on.
>> >>
>> >> > And I asked to see the user space side and you have angrily refused
>> >> > every time.
>> >>
>> >> AFAIR I never ever refused to show any piece of code which went under
>> >> my hands towards Linux to any-one.
>>
>> > For future reference, when someone asks a question and you go off on
>> > an tangental rant and ignore the question, then that process repeats,
>> > still without answering the question - most english speakers would
>> > call that refusing to answer the question. It is not looked upon kindly.
>>
>> Jason,
>>
>> It's not that you asked to see the code ala "hey, do you happen to
>> have a git with the user space code for people to inspect while
>> doing the review on the kernel part", but rather U2 saying in a
>> definitive manner that posting the user space code should be imposed
>> as pre-requirement to acceptance of the kernel parts.
>
> I really didn't Or:
>
> First ask:
>  'We can't really look at the uapi changes here without also seeing the
>   verbs side changes.'
>  (I know others on the list feel the same, so I use 'we')
>
> Second ask:
>  'Lets see the verbs side and I'll let you know.'
> (.. to your questions based on my review comments ..)
>
> Third ask:
>  'I think we need to have the same policy.'
> (.. To Yann's point that other kernel communities have a mandatory
>   UAPI policy)
>
> Fourth (exasperated) ask:
>  'Was it not clear? Yann and I asked to see the user space side before
>   reviewing this series further.'
>
> I know you are ESL, and I cut you alot of slack, but *come on* - that
> is incredibly soft language, and certainly not bossing and imposing in
> a definitive manner a blanket requirement on all patches.

Jason,

ESL indeed am I, and in that respect, this clarification, even if
being tedious to set or read, helps.

Still, I'd like to further try and get you from where the bossing thing came:

(1) "show me the user space code prior to acceptance of the kernel
part" never was a requirement on this community since the day we were
born (Q4/2004)

(2) instantly rejecting a usage of a mechanism existing just for that
use case since the first year of our life (2005)

is something perceived by me as two people (that's the U2) that come
and say, "game's over, the old, non-functioning boss is gone, new boss
(== we) in town and forget about everything you knew before".

So you say that is was wrong perception, I hope so. Let's see how Doug
see your feedback, namely either as community reviewer feedback or as
new rules being set overnight, waiting.

This series is (1) simple compared to other stuff being reviewed here
nowadays, and (2) has very nice value to latency sensitive
applications, so two wins, lets get it done.

> Advice: You would be well served to spend a bit more time on your
> emails. I have no idea what 'but rather U2 saying' means, for
> instance. Sometimes I just guess at what you are trying to say :|

point taken

> That is the price we pay for an inclusive international community, but
> everyone needs to be careful before starting a flame war based on
> percived slight in the text and phrasing of a message. email is hard.

point taken. In this case (as you can see from my response above) I am
not convinced yet that this was false positive.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
