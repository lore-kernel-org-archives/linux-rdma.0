From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 04/14] ib_srp: Set block layer timeout
Date: Sun, 18 Dec 2011 00:03:44 +0200
Message-ID: <CAJZOPZKQ4rg6D=ZDt2q+aJbsNAQbgqgh19FmGC5Vi6_EQ4ROFQ@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112011959.11956.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011959.11956.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> The default block layer timeout is 30 seconds.

Could you provider a pointer to where this is defined?

> Typical values for the QP local ack
> timeout and retry count are 19 and 7 respectively, which means
> that it can take up to 60.1 seconds before a HCA submits an error completion.

isn't timeout(R,X) = R * ~4us * 2^X  ==> timeout(7,19) = 7 * ~2seconds
= ~14 seconds

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
