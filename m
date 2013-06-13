From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: recommend setting for dev_loss_tmo and fast_io_fail_tmo
Date: Thu, 13 Jun 2013 22:21:14 +0400
Message-ID: <CACaajQvBL_DvBXTaMOisuXUBzezpiQN6fSaio-VCOYYWpiaBHQ@mail.gmail.com>
References: <CACaajQuhmd8ExRHvQQBES43FNDWKGHxEb0DjmxWJ1K2=ybUuKQ@mail.gmail.com>
 <51BA07DA.40703@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51BA07DA.40703-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

2013/6/13 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
> Hello Vasily,
>

Hello, Bart.

> The default value for the reconnect_delay parameter in that version of the
> SRP initiator is 10 seconds. So if you want to give the SRP initiator a
> chance to try once to reconnect before failing I/O fast you can set the
> fast_io_fail_tmo parameter to e.g. 15 seconds. That should limit the time
> during which I/O is stuck to about 76 seconds (61 seconds IB RC timeout + 15
> seconds for the fast I/O fail timeout).

Hm. Does it mean that if i set fast_io_fail_tmo = 40 i get timeout
after 61+40 = 101 seconds?

>How to configure dev_loss_tmo
> depends on the configuration at the initiator side. If you are using
> initiator-side mirroring then it is a good idea to set dev_loss_tmo to a
> very large value in order to avoid /dev/sd* reassignment. Note: with the
> patch series I posted earlier this week it is possible to set dev_loss_tmo
> to "off", something that is not yet possible with the ib_srp-backport
> project.

Yes, i'm using raid1 on initiator side. That means that in my case
dev_loss_tmo may be switched off?

P.S. In case of kernel 3.9.5 does i need you backported ib_srp driver
or i can use mainline kernel drivers for faster reconntects?
P.P.S. Can you provide me subject of e-mail or link to patches to
switch off dev_loss_tmo?




--
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
