From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: NULL pointer dereference in rdma_ucm
Date: Wed, 21 Jul 2010 16:09:46 +0300
Message-ID: <4C46F19A.3060203@Voltaire.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>	<4C4544CC.3090405@voltaire.com> <AANLkTinOmOrg14OZGnj2qe1dwPaXQbN28-0kz2TINF6n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinOmOrg14OZGnj2qe1dwPaXQbN28-0kz2TINF6n-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Josh England wrote:
> Do you think upgrading to OFED-1.5.1 would help at all?

it might help you to diagnose the problem better, if you read through the
thread I pointed on (its very short, four messages, let then two minutes),
you would see that Arthur is reporting on the lap_state and Sean is suggesting to use the IB CM sysfs counter to further debug this. I don't know if these counters exist on the IB stack used for the ofed drop you're using, but they should be in 1.5.x

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
