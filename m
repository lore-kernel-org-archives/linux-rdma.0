From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs V3 3/3] Add ibv_query_port_ex support
Date: Sun, 11 May 2014 15:35:56 +0300
Message-ID: <536F6EAC.8020109@mellanox.com>
References: <1399531883-30599-1-git-send-email-ogerlitz@mellanox.com> <1399531883-30599-4-git-send-email-ogerlitz@mellanox.com> <20140508190951.GB25849@obsidianresearch.com> <CAL1RGDUiBtOaYKZVR3ghOZzG6J0p5EV5o4FTTW0E43mHz-BaVQ@mail.gmail.com> <20140509181043.GC18257@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140509181043.GC18257-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/05/2014 21:10, Jason Gunthorpe wrote:
> On Fri, May 09, 2014 at 07:01:36AM -0700, Roland Dreier wrote:
>> On Thu, May 8, 2014 at 12:09 PM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>>>>   struct verbs_context {
>>>>        /*  "grows up" - new fields go here */
>>>> +     int (*drv_query_port_ex)(struct ibv_context *context, uint8_t port_num,
>>>> +                              struct ibv_port_attr_ex *port_attr);
>>>> +     int (*lib_query_port_ex)(struct ibv_context *context, uint8_t port_num,
>>>> +                               struct ibv_port_attr_ex *port_attr);
>>>>        struct ibv_ah * (*drv_ibv_create_ah_ex)(struct ibv_pd *pd,
>>>>                                                struct ibv_ah_attr_ex *attr);
>>>>        int (*drv_ibv_destroy_flow) (struct ibv_flow *flow);
>>> I'm not sure what Roland decided to merge, but I am surprised to see
>>> drv_ elements here. That was nix'd in the round of review of the first
>>> patch set. eg create_qp_ex/etc don't have them.
>>>
>>> The flow is such that the verbs code has a chance to capture and
>>> override the function pointer after the driver sets it, there is no
>>> purpose to the drv_ values.
>>>
>>> I wouldn't like to see more added, and I think you should make a patch
>>> to ensure they are not necessary before it propogates too far.
>> Sorry, I was not aware of the feeling on drv_XXX members here and I
>> don't think I saw any review comments about them.  (Maybe they got
>> lost in the flood of "merge it merge it merge it" emails)
> To be honest, I never bothered looking at any patches beyond the core extension patches. There was no indication from you that they would ever be merged, so it didn't feel like good use of my time.

Jason, I am clueless on what you are talking (please read below), I 
think you are mixing things (see the DD comment below too)

>
>> Anyway I'm wondering if there's a way to recover without breaking ABI here (or by breaking ABI in a manageable way).  The only library using this stuff (that I know of) is libmlx4, maybe we can spin quick releases of both and pretend libibverbs 1.1.8 never happened?

Roland, Jason,

To clarify, recall that there are few faces/pieces involved in the 
extensions toy, specifically, things that relate to libibverbs/uverbs 
interaction, those who relate to libibverbs/application  and the ones 
that deal with libibverbs/vendor plugin library.

So, the XRC patches that were around here for months if not years only 
dealt with the libibverbs/uverbs part of things.

The Flow-steering kernel patches have nothing to do with extensions, and 
here (e.g the UD related ones), is where you -- Roland got few 
reminders, after you left them untouched on the floor for long time.. No 
budge or nudge was sent to you on the user space (next item) flow 
steering patches  which were posted on Feb 6th, this year, so please 
take care with DD (Devil/Details) dealing.

> I think the best approach is to rescind the last libmlx4 version so it
> never gets used then:
>    - Rename drv_* to _reserved_X
>    - Drop all references to drv_* from libverbs
>    - Have libmlx4 set the ib_ pointer only
>
> For the other problem
>    - Replace VERBS_CONTEXT_CREATE_FLOW and VERBS_CONTEXT_DESTROY_FLOW
>      with _RESERVED_x
>    - Drop the references from mlx4
>
> These are not a big deal as long as things are fixed quickly before the bad libmlx4 gets widely used. Then we could reclaim the reserved_X entires someday.
>
> The biggest issue I see is that this is creating an anti-pattern, so we need to stamp that out in the verbs source.
>
> I expect Or will get right on this..
>
> Or, it would be helpful to me if you could go back to libibverbs commit cbf2a35162a [...] and post the corrected flow steering patches with the ABI/API change as a distinct patch. I think I caught everything, but lets also correct that process error and hopefully Sean/etc can comment too.
>

So I understand that we need to remove VERBS_CONTEXT_CREATE_FLOW and 
VERBS_CONTEXT_DESTROY_FLOW and it makes sense to follow your suggestion 
of replacing them with _RESERVED_x

As for the drv_ entries, that was mine/Matan's interpretation of the 
architecture, Matan is checking this with Tzahi Oved, the founder of 
this concept and will be sending a response early this week.

I'm not sure we need to roll back to  commit cbf2a35162a and start from 
there, but if people feel this is the right thing to do, let it be.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
