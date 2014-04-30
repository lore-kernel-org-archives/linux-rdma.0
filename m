From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Wed, 30 Apr 2014 22:41:47 +0300
Message-ID: <CAJZOPZJUksc6f6FMhenWJe5uvEVQ898ZQoLD0ss6vSrMC42ZPQ@mail.gmail.com>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org>
	<CAJZOPZJfdaZ7QzgffzY9Ps-1aUCU+q_dSrj4XfekyfxNa-k+hg@mail.gmail.com>
	<alpine.DEB.2.10.1404211605390.29907@gentwo.org>
	<CAJZOPZ+FwPc3OSVyvk0i4=gX-x0zf_+M8zL1_t9HWmEKi5397Q@mail.gmail.com>
	<alpine.DEB.2.10.1404211926050.31858@gentwo.org>
	<alpine.DEB.2.10.1404220844430.4876@gentwo.org>
	<53569261.9010805@mellanox.com>
	<alpine.DEB.2.10.1404291231250.26056@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1404291231250.26056-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 29, 2014 at 8:32 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:

> Ok I saw the ODP patches. But where are the multicast block patches? Is
> there any way to move this forward?

We can try, earlier on this thread I wrote

"Roland, how you prefer to move on here? we can come up with quick
patch that just uses the reserved field of struct ib_uverbs_create_qp
and would allow to support upto 8 creation flags, this would not
require new uverbs command, OK?"

and no reply...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
