From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Wed, 27 May 2015 12:48:56 -0600
Message-ID: <20150527184856.GA16059@obsidianresearch.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgdqBnn6hobRJFut6Nyu2pKt40rb46Z3dYx3MaohR2urA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 27, 2015 at 02:54:12PM +0300, Or Gerlitz wrote:
> On Wed, May 27, 2015 at 1:07 AM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Tue, May 26, 2015 at 11:39:04PM +0300, Or Gerlitz wrote:
> >> >> Jason, you (U2 BTW) play really, really hard - refusing to say **one**
> >> >> word on your approach towards the built-in udata mechanism for uverbs
> >> >> which I asked you to comment on.
> >>
> >> > And I asked to see the user space side and you have angrily refused
> >> > every time.
> >>
> >> AFAIR I never ever refused to show any piece of code which went under
> >> my hands towards Linux to any-one.
> 
> > For future reference, when someone asks a question and you go off on
> > an tangental rant and ignore the question, then that process repeats,
> > still without answering the question - most english speakers would
> > call that refusing to answer the question. It is not looked upon kindly.
> 
> Jason,
> 
> It's not that you asked to see the code ala "hey, do you happen to
> have a git with the user space code for people to inspect while
> doing the review on the kernel part", but rather U2 saying in a
> definitive manner that posting the user space code should be imposed
> as pre-requirement to acceptance of the kernel parts.

I really didn't Or:

First ask:
 'We can't really look at the uapi changes here without also seeing the
  verbs side changes.'
 (I know others on the list feel the same, so I use 'we')

Second ask:
 'Lets see the verbs side and I'll let you know.'
(.. to your questions based on my review comments ..)

Third ask:
 'I think we need to have the same policy.'
(.. To Yann's point that other kernel communities have a mandatory
  UAPI policy)

Fourth (exasperated) ask:
 'Was it not clear? Yann and I asked to see the user space side before
  reviewing this series further.'

I know you are ESL, and I cut you alot of slack, but *come on* - that
is incredibly soft language, and certainly not bossing and imposing in
a definitive manner a blanket requirement on all patches.

Advice: You would be well served to spend a bit more time on your
emails. I have no idea what 'but rather U2 saying' means, for
instance. Sometimes I just guess at what you are trying to say :|

That is the price we pay for an inclusive international community, but
everyone needs to be careful before starting a flame war based on
percived slight in the text and phrasing of a message. email is hard.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
