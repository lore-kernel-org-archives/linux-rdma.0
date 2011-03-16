From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Wed, 16 Mar 2011 17:41:24 -0400
Message-ID: <1300311684.18382.17.camel@lap75545.ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
 <1300148888.2772.15.camel@lap75545.ornl.gov> <4D807472.2060000@mellanox.com>
 <AANLkTimY74Wmsfc3F35SBuR2YyDW=ao78B=9uGh4LZNJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTimY74Wmsfc3F35SBuR2YyDW=ao78B=9uGh4LZNJ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-03-16 at 09:50 -0700, Roland Dreier wrote:
> On Wed, Mar 16, 2011 at 1:27 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > nothing special, just want to make sure that at this point we're talking
> > only on patches 1-8 i.e excluding the "increase DMA max_segment_size on
> > Mellanox hardware" patch, correct?
> 
> Is there still any concern about that patch possibly being wrong?

Or can speak to his concerns, but the mlx4 hunk of the patch should drop
the limit to 1 GB as that seems to be a hardware limit.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
