From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libibverbs V3 2/3] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Thu, 8 May 2014 23:22:47 +0300
Message-ID: <CAJZOPZJzcvQLar+Hkgbg3CGhVGrydsbgomocpiEAagan63MmdA@mail.gmail.com>
References: <CAJZOPZLrLL444ce_hXdnN5_JPfUVAy_Qsj+eVo2-YG3Jqqe01Q@mail.gmail.com>
	<20140508201549.GA32622@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140508201549.GA32622-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 8, 2014 at 11:15 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, May 08, 2014 at 11:05:41PM +0300, Or Gerlitz wrote:
>
>> Thanks for looking && commenting, Matan and myself will digest your
>> feedback and respond/fix what's needed. BTW - note that this is V3
>> where V0/1/2 were posted three months ago, where the earlier rounds of
>> reviewers were focused on other portions of the series. So better late
>> than never, review on the verbs extensions elements now happens :)
>
> What changed is that Roland took the verbs extensions patches, so now
> I am willing to spend time on proposed ABI changes :)
>
> From now on I think every proposed API/ABI change should be in an
> isolated patch from anything else, it should be accompanied by other
> patches showing the implementation, and the ABI patch specifically
> should earn a public Reviewed-By from at least two of people who
> designed this monster: Sean, Liran and myself.

Did you mean Tzahi?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
