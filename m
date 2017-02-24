From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-core v2 0/9] Broadcom User Space RoCE Driver
Date: Fri, 24 Feb 2017 23:10:53 +0530
Message-ID: <CANjDDBgBYAswrEdUb8YCDRiruhRHUAmXezN7CB-gtLxrQj9UPg@mail.gmail.com>
References: <1487432638-19607-1-git-send-email-devesh.sharma@broadcom.com>
 <20170221195053.GG13138@obsidianresearch.com> <CANjDDBi7bvYMvnjgsdSXzj6ot2wJS+w1nRCp-26TgEEpE38vfg@mail.gmail.com>
 <20170222050804.GA29755@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170222050804.GA29755-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 22, 2017 at 10:38 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Feb 22, 2017 at 08:52:17AM +0530, Devesh Sharma wrote:
>> > It still doesn't compile, please make sure everything is travis clean
>> > before submitting..
>>
>> I could not find travis package, thus could not gave it try before
>> submitting v2. I will give it a shot again.
>
> To run travis you need to install docker and run
>
> $ buildlib/cbuild build-images travis
>
> Then you can run:
>
>> > $ buildlib/cbuild pkg travis
>
> Which emulates travis locally.
>
> Real travis only runs once you create a PR in github.
>

Thanks Jason, I will try it out and submit v3 of this series.

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
