From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Wed, 16 Mar 2011 11:07:56 -0400
Message-ID: <1300288076.2205.4.camel@obelisk.thedillows.org>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
	 <1300148888.2772.15.camel@lap75545.ornl.gov>
	 <4D807472.2060000@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D807472.2060000-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-03-16 at 10:27 +0200, Or Gerlitz wrote:
> David Dillow wrote:
> > I'm getting ready to re-roll this series to address Or's review
> > comments. I'm going to leave BMME support until later, as I have a few
> > concerns about the error cases.
> > 
> > I'd like to see this go into 2.6.39 -- do you guys have any other
> > questions or comments I should address?
> 
> nothing special, just want to make sure that at this point we're talking 
> only on patches 1-8 i.e excluding the "increase DMA max_segment_size on 
> Mellanox hardware" patch, correct?

Correct. That patch is orthogonal to SRP, so it wouldn't go through my
git tree anyway -- it should go through the maintainers of those
drivers.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
