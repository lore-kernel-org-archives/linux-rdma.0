From: eran ben elisha <eranlinuxmellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 0/7] Add support for multicast loopback
 prevention to mlx4
Date: Wed, 26 Aug 2015 12:12:15 +0300
Message-ID: <CAKHjkjnk9sFfr3KhNGBD_LzXUbDdb7_=vF2A3Z5+ousFShfxJw@mail.gmail.com>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com>
	<alpine.DEB.2.11.1508251143430.16801@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1508251143430.16801-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 25, 2015 at 7:44 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, 20 Aug 2015, Eran Ben Elisha wrote:
>
>> This patch-set adds a new  implementation for multicast loopback prevention for
>> mlx4 driver.  The current implementation is very limited, especially if link
>> layer is Ethernet. The new implementation is based on HW feature of dropping
>> incoming multicast packets if the sender QP counter index is equal to the
>> receiver counter index.
>
> Do you have this in a git tree somewhere for testing?

Yes,
please pull from https://github.com/eranbenelisha/linux branch
rebased-for-4.3/lb_prev

If you with to get the user space as well for testing, please use:
https://github.com/eranbenelisha/libibverbs branch for-linux-rdma-lb_prev
https://github.com/eranbenelisha/libmlx4 branch for-linux-rdma-lb_prev

Eran.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
