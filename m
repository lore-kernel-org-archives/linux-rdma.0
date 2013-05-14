From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: [ANNOUNCE] SRP: ProfitBricks publishes its SRP Initiator patches
Date: Tue, 14 May 2013 14:00:26 +0400
Message-ID: <CACaajQun61QAM0qqwadWECSFO7UxUaOrdO1-0vGLPQBjdwdMyw@mail.gmail.com>
References: <5167EDC8.3030909@profitbricks.com> <CACaajQs0PswMb5KhpSkE1=_Sd1SwX2BznZP9x1FCkEk6ukJYrA@mail.gmail.com>
 <5183A355.5090401@acm.org> <CACaajQtQk0YJ3g0G5PyOue0qG3SzhaW3qmXj_TLqYDVqzKwJXQ@mail.gmail.com>
 <51876D79.50003@profitbricks.com> <51877B71.3080202@acm.org> <518A7233.9070400@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <518A7233.9070400-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

if i need faster reconnects and ability to close session from
initiator side under qlogic hardware, does it possible? Or this
patches only covers mallanox cards?

2013/5/8 Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>:
> FYI: I've released version 0.6 of my SRP patches today.
>
> The automatic reconnect is included now. The tests for that will follow
> in the next version. But we already did quite intensive testing for that.
>
> Hard reboot and also soft reboot of the target are possible with that
> reconnect. It just reconnects and everything is fine again.
>
> With soft reboot I mean: disabling the target, removing the exports,
> rebooting, exporting the same LUNs, re-enabling the target.
>
> It also has an automatic mechanism to reduce the possibility of a DDoS
> attack reconnect. It automatically reconnects at different intervals.
>
> Check it out:
> https://github.com/sriemer/ib_srp
>
> Cheers,
> Sebastian



-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
