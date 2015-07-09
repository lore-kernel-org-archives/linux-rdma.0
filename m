From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-4.2] IB/mlx4: Fix and optimize SRIOV slave init
Date: Thu, 9 Jul 2015 11:28:51 +0300
Message-ID: <559E30C3.5050702@mellanox.com>
References: <23f3dca9ff4b71155bd898be1f3cbd8eeb9df27f.1436394658.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <23f3dca9ff4b71155bd898be1f3cbd8eeb9df27f.1436394658.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 1:30 AM, Doug Ledford wrote:
> In mlx4_main.c:do_slave_init(), the function is supposed to queue up
> each work struct.  However, it checks to make sure the sriov support
> isn't going down first.  When it is going down, it doesn't queue up the
> work struct, which results in us leaking the work struct at the end of
> the function.  As a fix, make sure that if we don't queue up the work
> struct, then we kfree it instead.
>
> The routine was also sub-optimal in its loop operations.  Instead of
> taking and releasing a spin lock over and over again, let's just take it
> once, and quickly loop through what needs to be done under the spin lock
> and then release it.
>

Hi Doug,

I'd like Jack to review this before we ack, not sure if he's in today, 
so he might get to look on that only on Sunday.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
