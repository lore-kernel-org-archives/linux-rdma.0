From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [GIT] lock scaling and bug fixes for 2.6.38
Date: Tue, 11 Jan 2011 19:33:48 +0100
Message-ID: <AANLkTinodGF24aK+KLhyqi16E4oRWR8uH3-SHFAYabcK@mail.gmail.com>
References: <1294699530.3038.27.camel@obelisk.thedillows.org>
 <adak4ic6wmo.fsf@cisco.com> <AANLkTikEnR6pjLy-L08UUbVdwS5f3k0+EutA-SrDVHMT@mail.gmail.com>
 <20110111174340.GD15933@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110111174340.GD15933-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 11, 2011 at 6:43 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Tue, Jan 11, 2011 at 06:29:52PM +0100, Bart Van Assche wrote:
>> On Tue, Jan 11, 2011 at 2:45 AM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> w=
rote:
>> >
>> > =A0> =A0 =A0git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-=
initiator.git srp-lock-scaling
>> >
>> > Thanks, pulled.
>> >
>> > Will try to merge Tejun's work queue patch shortly.
>>
>> Maybe it's=A0a good idea to add a comment above the declaration of t=
he
>> global variable "extern struct workqueue_struct *ib_wq;" that explai=
ns
>> that that variable has been added during the work queue conversion a=
nd
>> that the preferred approach for new code is to define a new work que=
ue
>> instead of using ib_wq ?
>
> But why is defining more workqueues preferred? =A0Unless there's a
> specific need, using what's already there (system or ib_wq) should be
> preferable.

Sorry, but I just noticed that I had missed the part of the discussion
that happened on the LKML and where linux-rdma was not CC-ed:
https://lkml.org/lkml/2010/12/16/244. I think that thread contains
valuable information.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
