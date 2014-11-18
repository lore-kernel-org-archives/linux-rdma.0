From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 2/2] IB/mlx4_ib: Disassociate support
Date: Tue, 18 Nov 2014 23:50:41 +0200
Message-ID: <CAJ3xEMjzZdf_aML2e+ht=cbYx3T9U7Lr7DOR6+JenEKTcxQ+Zw@mail.gmail.com>
References: <1416312682-7899-1-git-send-email-yishaih@mellanox.com>
	<1416312682-7899-3-git-send-email-yishaih@mellanox.com>
	<546B5AE3.9060606@mellanox.com>
	<546B7E73.40008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546B7E73.40008-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 18, 2014 at 7:14 PM, Yishai Hadas
<yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 11/18/2014 4:42 PM, Or Gerlitz wrote:

>> Can we somehow make this patch generic (e.g land in the IB core) such
>> that it can apply also for mlx5 (and other HW drivers...) basically, the
>> HW driver should tell the IB core which pages to zap and we should be
>> OK, isn't that?

> We introduced a generic API that asked the low level driver to detach a
> given ucontext from its HW resources. The specific driver implementation may
> be different between HW devices and may not involve the zap usage, that's
> why it wasn't put in IB core. In addition, the zap API should be in sync
> with inflight VMA closing to prevent zapping an already unmapped address. To
> achieve that the driver should implement some VMA ops and synchronize
> between those flows.

Again, drivers that don't want to go the zapping way, could just avoid
this generic code.

So we have already two more low-level drivers (cxgb3/4) that would be
happily using the 95% of the mlx4_ib code you wrote after the
re-factoring I suggested.
I tend to think mlx5_ib should join too. Why not try it out, write the
code in the way which

1. under the IB core
2. easiest to use under this twist for mlx4_ib

and let cxgb3/4 and mlx5 maintainers to see if/how they can use it.

> That code looks like something that fit to be done in
> the driver and not as part of a IB core.

None of the arguments above doesn't make me get into this conclusion,
open to more people, but why don't you just follow steps 1/2 above and
see where it gets you?


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
