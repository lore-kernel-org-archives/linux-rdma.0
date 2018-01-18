From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Request for Comments on SoftiWarp
Date: Thu, 18 Jan 2018 17:03:49 +0000
Message-ID: <OFC86A1EC5.60F00E9A-ON00258219.005DA6A4-00258219.005DBBB9@notes.na.collabserv.com>
References: <20180118072958.GW13639@mtr-leonro.local>,<20180114223603.19961-1-bmt@zurich.ibm.com>
 <031f01d38fad$422520c0$c66f6240$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180118072958.GW13639-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


-----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----

>To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>Date: 01/18/2018 08:30AM
>Cc: "'Bernard Metzler'" <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>,
>linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v3 00/13] Request for Comments on SoftiWarp
>
>On Wed, Jan 17, 2018 at 10:07:22AM -0600, Steve Wise wrote:
>> Hey Bernard,
>>
>> >
>> > This patch set contributes a new version of the SoftiWarp
>> > driver, as originally introduced Oct 6th, 2017.
>> >
>>
>>
>> Two things I think will help with review:
>>
>> 1) provide a github linux kernel repo with this series added.  That
>allows
>> reviewers to easily use both patches and a full kernel tree for
>reviewing.
>>
>> 2) provide the userlib patches (and a github repo) that works with
>the
>> latest upstream rdma-core.  That will allow folks to test use-side
>rdma as
>> part of their review.
>
>And please don't call it "PATCH" in subject, but "RFC".
>The "PATCH" is misleading.
>

Makes sense. I will make sure I remember.

>>
>> I'll review the individual patches in detail asap.
>
>I would like to review too to learn iWARP a little bit closer, but
>most
>probably won't have time to do it till -rc1.
>

Sure!

Let me set up a github thing which mirrors the most recent
kernel sources + the siw RFC ;) attached. Shall I just take
https://github.com/torvalds/linux ?

Thank you!
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
