From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 04/14] ib_srp: Set block layer timeout
Date: Sat, 17 Dec 2011 17:39:15 -0500
Message-ID: <1324161555.17849.21.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112011959.11956.bvanassche@acm.org>
	 <CAJZOPZKQ4rg6D=ZDt2q+aJbsNAQbgqgh19FmGC5Vi6_EQ4ROFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKQ4rg6D=ZDt2q+aJbsNAQbgqgh19FmGC5Vi6_EQ4ROFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2011-12-18 at 00:03 +0200, Or Gerlitz wrote:
> Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> 
> > The default block layer timeout is 30 seconds.
> 
> Could you provider a pointer to where this is defined?
> 
> > Typical values for the QP local ack
> > timeout and retry count are 19 and 7 respectively, which means
> > that it can take up to 60.1 seconds before a HCA submits an error completion.
> 
> isn't timeout(R,X) = R * ~4us * 2^X  ==> timeout(7,19) = 7 * ~2seconds
> = ~14 seconds

C9-141 says we could take up to 4 times longer than 4us * 2^X to detect
the ACK loss.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
