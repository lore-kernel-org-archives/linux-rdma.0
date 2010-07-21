From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NULL pointer dereference in rdma_ucm
Date: Wed, 21 Jul 2010 09:11:56 -0700
Message-ID: <AANLkTilFcc34DV_o-D4jxkmqgh36iGsOQ8BLah-8HjF0@mail.gmail.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
	<4C4544CC.3090405@voltaire.com>
	<AANLkTinOmOrg14OZGnj2qe1dwPaXQbN28-0kz2TINF6n@mail.gmail.com>
	<4C46F19A.3060203@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C46F19A.3060203-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I do have the sysfs counters in
/sys/class/infiniband_cm/<device>/<port_num>/cm_tx_msgs/.  Could you
point me to a reference for what they all mean?  There are a few
patches I've had to throw into 1.4.2 so I'll need to check whether
they are still needed in 1.5.1, but I'll work on that today.

Now, I'm not sure how relevant it is, but under heavy load I also see
a lot of these:
kernel: ib_cm: calculated mra timeout 67584 > 8192, decreasing use timeout_ms

-JE

On Wed, Jul 21, 2010 at 6:09 AM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> Josh England wrote:
>> Do you think upgrading to OFED-1.5.1 would help at all?
>
> it might help you to diagnose the problem better, if you read through the
> thread I pointed on (its very short, four messages, let then two minutes),
> you would see that Arthur is reporting on the lap_state and Sean is suggesting to use the IB CM sysfs counter to further debug this. I don't know if these counters exist on the IB stack used for the ofed drop you're using, but they should be in 1.5.x
>
> Or.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
