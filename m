From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: RE: [PATCH v3 00/13] Request for Comments on SoftiWarp
Date: Tue, 23 Jan 2018 17:31:43 +0000
Message-ID: <OFBAFFC6C5.1B1CE5FF-ON0025821E.006049EC-0025821E.006049EE@notes.na.collabserv.com>
References: <031f01d38fad$422520c0$c66f6240$@opengridcomputing.com>,<20180114223603.19961-1-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <031f01d38fad$422520c0$c66f6240$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



-----"Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote: -----

>To: "'Bernard Metzler'" <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>,
><linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>Date: 01/17/2018 05:07PM
>Subject: RE: [PATCH v3 00/13] Request for Comments on SoftiWarp
>
>Hey Bernard,
>
>> 
>> This patch set contributes a new version of the SoftiWarp
>> driver, as originally introduced Oct 6th, 2017.
>> 
>
>
>Two things I think will help with review:
>
>1) provide a github linux kernel repo with this series added.  That
>allows
>reviewers to easily use both patches and a full kernel tree for
>reviewing.
>

I have cloned https://github.com/torvalds/linux,
patched it and pushed it to
https://github.com/zrlio/softiwarp-for-linux-rdma


I will make another clone available for the patched linux-rdma user
level part of it.


>2) provide the userlib patches (and a github repo) that works with
>the
>latest upstream rdma-core.  That will allow folks to test use-side
>rdma as
>part of their review.
>
>I'll review the individual patches in detail asap.
>
>Thanks!
>
>Steve.
>
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
