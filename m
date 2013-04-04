From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fail post send command on error recovery
Date: Fri, 5 Apr 2013 00:45:01 +0300
Message-ID: <CAJZOPZ+dgtQRX_sfcDc=aSOW553Twi0oqNjREeminQ2tnZeEmQ@mail.gmail.com>
References: <1364496315-7588-1-git-send-email-klebers@linux.vnet.ibm.com>
	<CAL1RGDW7wMVmyFhCv-Ei8Mbca-Y9yv+nygzfREU2_TozNSZ60A@mail.gmail.com>
	<515D79B3.4090808@linux.vnet.ibm.com>
	<201304041700.40349.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201304041700.40349.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 4, 2013 at 5:00 PM, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

> This won't really help unless ALL userspace apps respond by calling
> ibv_close_device. You can check this by running ibv_asyncwatch  (in
> libibverbs/examples). Until ibv_asyncwatch
> is exited the low-level device restart won't work.

Jack, so we have two different problems here, the kernel ULPs trying
to reap completions from their CQs which will never happen, and what
you pointed on under which currently the device will not be destroyed.
I think its OK to handle them one @ a time...

Kleber , as for the 1st problem, which kernel consumers are hanging
for ever on their CQs? IPoIB is giving up after sometime e.g see in
ipoib_ib.c "assume the HW is wedged and just free up all our pending
work requests"

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
