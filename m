From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Tue, 28 Feb 2017 09:56:57 +0200
Message-ID: <CAFgAxU8KkrOS6aib4ykf8vj1sQFGK_oMW=fX3vZ2X2_r3ryDVA@mail.gmail.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <20170227185912.GM5891@obsidianresearch.com> <CAFgAxU9XJTXkaeL_VE7zHASPBM+j=TZd2L+McKBcJRThJtUN5w@mail.gmail.com>
 <20170227223600.GA1526@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170227223600.GA1526-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "M: Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 28, 2017 at 12:36 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Feb 28, 2017 at 12:11:58AM +0200, Alex Rosenbaum wrote:
>
>> This is definitely one approach I was thinking about as well. It will
>> surely help clean some of the older, not extendible API's.
>> I'd like to call out to all provide library maintainer. if you have
>> started code porting from the old ibv_register_driver() to the new
>> extendible verbs_register_driver() then please move forward with
>> submitting it. Once using the extendible 'struct verbs_device' it will
>> be easy to add the new unint_device() functionality to all provided
>> library in order to support plug-in for all.
>
> Someone is going to have to take this on..
>
> Conceptually it isn't hard to do, but I figured it was too complicated
> to undertake without the ability to test.
>
> Maybe you could help out by providing a bunch of information how to do
> the conversion and show a patch for something like RXE.
>
> Jason

We can definitely portal all providers (some extra work) but as you
wrote, i'm also not sure how to proceed with code review and
testing...? we'll surely need the maintainers ACK.
If not, we can proceed with my initial suggestion where libraries that
don't want this new HotPlug support will not change there code, and
libibverbs will manage the old and new drivers list.

Anyway, I'll take it with MoshS for RXE and we'll provide an example
of porting a provider library to the new extendible
verbs_register_driver().

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
