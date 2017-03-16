From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-core v3 4/9] libbnxt_re: Add support for posting and polling
Date: Thu, 16 Mar 2017 22:23:02 +0530
Message-ID: <CANjDDBiw9gVR86uJPpxvYAL-uCEmbbSqpuiHN=sAcbHkE45s5Q@mail.gmail.com>
References: <1489574253-20300-1-git-send-email-devesh.sharma@broadcom.com>
 <1489574253-20300-5-git-send-email-devesh.sharma@broadcom.com>
 <20170315163454.GD29562@obsidianresearch.com> <CANjDDBh9JP-0W4NDW4p-Jx2fivcSKS9ZAt5AdLRdQPXH8WxxCw@mail.gmail.com>
 <20170316161754.GF23821@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170316161754.GF23821-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Okay, I will get it done.

On Thu, Mar 16, 2017 at 9:47 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Mar 16, 2017 at 08:34:12AM +0530, Devesh Sharma wrote:
>
>> > Your github branch doesn't compile, btw.
>> >
>> > I ran it through sparse, this is what I suggest..
>>
>> Thanks for the suggestion, I will run sparse and try to fix all of it.
>
> You will need my sparse branch to do this:
>
> https://github.com/linux-rdma/rdma-core/pull/100
>
> There were a few places still producing warnings, at least two should
> be fixed with __force
>
> You should make a PR for this once you get Leon's changes and rebase
> it the current master.
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
