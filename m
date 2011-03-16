From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Wed, 16 Mar 2011 09:50:55 -0700
Message-ID: <AANLkTimY74Wmsfc3F35SBuR2YyDW=ao78B=9uGh4LZNJ@mail.gmail.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
 <1300148888.2772.15.camel@lap75545.ornl.gov> <4D807472.2060000@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D807472.2060000-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 16, 2011 at 1:27 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> nothing special, just want to make sure that at this point we're talking
> only on patches 1-8 i.e excluding the "increase DMA max_segment_size on
> Mellanox hardware" patch, correct?

Is there still any concern about that patch possibly being wrong?

Because I'd be inclined to merge it at this point.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
