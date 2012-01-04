From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Write Packets to InfiniBand HCA
Date: Wed, 4 Jan 2012 23:03:38 +0200
Message-ID: <CAJZOPZ+-muTk9s_k61-+_=JFJRsg0RGOvGuMJu46mYCAYR7uqw@mail.gmail.com>
References: <CANtVascW3aRunBOSevwJgv8vN6gnNjmZM=8vLii=pUsDaFam3w@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB5CCCCCFB63@MNEXMB1.qlogic.org>
	<CANtVasebZqgxoZOVMJ7uRGN7subRZqgq1vWjh_r11vXxa--Qog@mail.gmail.com>
	<CAL1RGDUOZw-+8R+rbsErd7PdB4gUH=zv1NYN-W1bxO5_ZgpdXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUOZw-+8R+rbsErd7PdB4gUH=zv1NYN-W1bxO5_ZgpdXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> It is possible with ConnectX (cf "MLX QPs" in the kernel driver). However I don't
> know what documentation is available and some hacking would be needed to use this for
> something more general than sending MADs on special QPs.

Greg, RAW Ethernet QPs (soon to be re-submitted upstream) which to be
implemented within the ConnnetX / mlx4 driver as MLX transport QPs
would allow you to do  that - over Ethernet.

If you're asking on IB, I would suggest using UD QPs which are
available today from user space, do you have any issue with them?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
