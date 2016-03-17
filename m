From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4] IB/uverbs: Fix race between uverbs_close and remove_one
Date: Thu, 17 Mar 2016 22:01:55 +0530
Message-ID: <CANjDDBhYH7HsUyP8-Ko7G0tnWxYDGYCGgaC4HK0Eod_isvoWAA@mail.gmail.com>
References: <1457795927-16634-1-git-send-email-devesh.sharma@broadcom.com>
 <20160312204502.GA8346@obsidianresearch.com> <CANjDDBiN8X-Efgp6s2wyT1G6fpQZjdreW0pnnBG71E9jjhy-YA@mail.gmail.com>
 <20160314174814.GB5240@obsidianresearch.com> <CANjDDBhVH10=0nSr0q4P4imAX6YrFBhE7QEd4ccRe2yUhN0pQQ@mail.gmail.com>
 <20160315203112.GA2786@obsidianresearch.com> <CANjDDBj8aZTeAfwxFuyk9r=kdihfxpxDA69-c4uVxkvcAfXViw@mail.gmail.com>
 <20160317161237.GB19501@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160317161237.GB19501-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 17, 2016 at 9:42 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Mar 17, 2016 at 09:38:30PM +0530, Devesh Sharma wrote:
>
>> To my mind mutex is *not* solving the problem completely unless we
>> make it a coarser grained lock. The possible deadlock problem still
>> lingers around it.
>
> Review the last version I sent, with this statement in mind:

I am sorry I lost the track of it, which one you are point..we have
been discussion for a quite some time now!

>
>> > The fundamental thing is that the ib_uverbs_free_hw_resources thread
>> > must wait for ib_uverbs_close's ib_uverbs_cleanup_ucontext to finish,
>> > if necessary, not the other way around.
>
> It sure doesn't look like it can deadlock...
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
