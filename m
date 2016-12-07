From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/28] Broadcom RoCE Driver (bnxt_re)
Date: Wed, 7 Dec 2016 17:03:23 +0530
Message-ID: <CA+sbYW1aNeGCwKLE_-=MiscVELPAqBZzD5ZQM1ePc6Jv-ys0tQ@mail.gmail.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
 <20161205165144.GB24852@obsidianresearch.com> <CA+sbYW1sUrv8CBHScMjU7ozBm709-tiVWaynDQK_Dq3AqAfggA@mail.gmail.com>
 <20161206163456.GB28066@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206163456.GB28066-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 6, 2016 at 10:04 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Dec 06, 2016 at 11:31:14AM +0530, Selvin Xavier wrote:
>> > Do you have a git tree someplace for this?
>
>> I assume you are referring to our uverbs library.
>
> No, I mean this series for linux. It is very hard to read these
> patches when they touch the same file again and again and have
> dependencies on net trees and things. I encourage people to include a
> git tree for such large works..

I will send out our repository info  along with the v2 patch set.

>
>> > Do you have the user space component ready for rdma-core as well?
>> >
>> This is not ready yet. Currently working on it.
>
> I'm also encouraging people to have their user space ready so the
> kernel driver can be properly reviewed.
The user space library is also ready. We would be posting it out soon.
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
