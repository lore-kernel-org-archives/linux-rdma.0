From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 0/7] Add support for multicast loopback
 prevention to mlx4
Date: Wed, 7 Oct 2015 00:49:15 +0300
Message-ID: <CAJ3xEMiNk2ZXgg_Ji5dg+ahL_D5_RAvEzEEhMsPDjC-PJYDu7Q@mail.gmail.com>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com>
	<CAKHjkjnQNqeLu+irEg97a1hcKp_ziXsDOFaTRwcaPpZAX_fMng@mail.gmail.com>
	<560AD75A.7080700@redhat.com>
	<CAJ3xEMiuPEJZ5EQueC=8wQyok2QbEaywQ3gRYVpqOwSaFQcj0A@mail.gmail.com>
	<5613F145.3040204@redhat.com>
	<CAJ3xEMhsr5uRLZ=Ur56TOpZy5XT3UbK=M1kcgjt=zx_x3HNcSQ@mail.gmail.com>
	<56143C8E.9090407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56143C8E.9090407-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 7, 2015 at 12:26 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Nothing so simple unfortunately.  And it isn't an IB/RoCE cluster, it's
> IB/IB/OPA/RoCE/IWARP cluster.  Regardless though, that's not my problem
> and what I'm chasing.

To be precise no two transports out of IB/RoCE/iWARP/OPA are
inter-operable, so these are "just" different cards/transports under
the same IB core on this cluster.

> Yes, I know how to do DOA testing.

So what's dead in your env after (say) 59m of examination?

>> What we do know that needs fixing for 4.3-rc
>> --> RoCE, you need the patch re-posted by Haggai few hours ago
>> "IB/cma: Accept connection without a valid netdev on RoCE" -- without
>> it, RoCE isn't working.

> I have that already.  It's available on both github and k.o and just
> waiting for a pull request.

Maybe wait to get the fixes for the non-default pkey on mlx5 (see more below)?

Did you actually note that before Haggai posted the patch?!

once I realized how deep was the breakage, I became sort of very
worried re your testing env not shouting hard on us this something is
broken even before 4.3-rc1

>> --> **mlx5** devices and no-default IB pkeys, Haggai and Co are
>> working on a fix since this isn't working since 4.3-rc1. I told them
>> we need it till rc5.5 (i.e few days before rc6 and if not, will have
>> to revert some 4.3-rc1 bits.

> I already have on patch related to this in my repo as well.  The 0day
> testing just came back and it's all good.

I suspect that you don't... do you have rping up and running between
mlx4 and mlx5 on non default pkey? the breakage is a bit tricky and
you might not see it if you run mlx5 against mlx5, BTW which patch is
that?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
