From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mlx4: BUG: unable to handle kernel at ffffffffa02be210
Date: Wed, 8 Jul 2015 21:22:26 +0300
Message-ID: <CAJ3xEMhrsxaE9y1HUPSrB9cnbENQOC6v3zM-oOy2rXeuMRZWXA@mail.gmail.com>
References: <CAD+HZHXi2bB59eWLYaGiXj5-b5w3V1NhwUJbSjx5NfdmhEaRhA@mail.gmail.com>
	<559D1562.2070309@mellanox.com>
	<CAD+HZHVCMa97zEQ1SB=JXCKHOGgSO93BPyLha2PDrOOTsHTUCw@mail.gmail.com>
	<559D2A80.4040909@mellanox.com>
	<CAD+HZHWBn-KZCsskSGPKLtntj-LjDRodda9jngr+qcKSxLhkGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAD+HZHWBn-KZCsskSGPKLtntj-LjDRodda9jngr+qcKSxLhkGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 8, 2015 at 5:07 PM, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Looks the last one is missing in OFED 2.4 driver, I just checked the
> history of mainline
>
> commit bf1bac5b7882daa41249f85fbc97828f0597de5c
> Author: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Date:   Thu Oct 23 15:57:27 2014 +0300
>
>   net/mlx4_core: Call synchronize_irq() before freeing EQ buffer

[...]

> This fix looks fit the bug we're hitting. Yes, we plan to update 3.0
> OFED recently, and the fix is included there.
> Will report if the bug is still there

Again... could you comment why aren't you using the stock 3.18.14 mlx4
driver? what feature is missing there for your needs?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
