From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] ib_srp: Avoid that LUN scanning creates duplicate devices
Date: Tue, 19 Jul 2011 09:16:34 -0700
Message-ID: <CAL1RGDW9WXswoGQYiSzZpuoQ07u2AMe3Xqni0Cc=O9d1sJ1OPQ@mail.gmail.com>
References: <201106251010.30994.bvanassche@acm.org> <1309018469.6908.3.camel@obelisk.thedillows.org>
 <CAO+b5-rfaf2DQtuGQePivWppzX5YC+Zbj_6Et1U6HrMJF6CLXA@mail.gmail.com> <1311091437.18631.1.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311091437.18631.1.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2011 at 9:03 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> I Ack'd thinking Roland would pick it up directly since has done that in
> the past for singe patches, but I'm fine with pulling it into my tree
> and pushing that way.
>
> Roland?

I've had it in my for-next branch for a while now... since it wasn't a
regression (AFAICT, we've been that way approximately forever), I
was waiting for 3.1 to ask Linus to take it.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
