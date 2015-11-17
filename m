From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation exception
Date: Tue, 17 Nov 2015 18:53:00 +0200
Message-ID: <CAJ3xEMjB_5pzuKyXJRXxHEvaFeHwmBLK31OFFtmA-RRY0i+82A@mail.gmail.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
	<1447691861-3796-11-git-send-email-sagig@mellanox.com>
	<564ADFCC.4030109@mellanox.com>
	<564AF929.60209@dev.mellanox.co.il>
	<564AFB93.9010602@mellanox.com>
	<564B00C3.1030506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564B00C3.1030506-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Pete Wyckoff <pw-VNBDo6LsbKA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 17, 2015 at 12:26 PM, Sagi Grimberg
<sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>
>> Why? we don't support and when did we broke it after the initial 2.6.18
>> upstreaming of the driver
>>
>> Also, do we refuse to queuecommand a bidi? where?
>
>
> Or, bidirectional support is not assumed and needs to be actively set
> as a request queue flag (see iscsi_sw_tcp_slave_alloc()).

> AFAICT iser never exposed support for bidirectional commands.

AFAIR, in the past there weren't explicit means to do that.

What's makes iscsi tcp eligible to support bidi's that we don't have @ iser?

> Did things change from back in 2.6.18 that we ever carried bidi
> commands over iser?

AFAIK, Pete Wyckoff had iser working with BIDI commands for few object
storage projects.

It's been a long time, but I was totally unaware that we don't publish
the whatever means
needed by upper layers.

I copied some 2010 email address of his here...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
