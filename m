From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fail post send command on error recovery
Date: Mon, 8 Apr 2013 18:47:15 +0300
Message-ID: <CAJZOPZKUHB5h=0JE+YnUDxcQ7oog1WcupVJbfEZO0ug7L2Fq5Q@mail.gmail.com>
References: <1364496315-7588-1-git-send-email-klebers@linux.vnet.ibm.com>
	<CAL1RGDW7wMVmyFhCv-Ei8Mbca-Y9yv+nygzfREU2_TozNSZ60A@mail.gmail.com>
	<515D79B3.4090808@linux.vnet.ibm.com>
	<201304041700.40349.jackm@dev.mellanox.co.il>
	<CAJZOPZ+dgtQRX_sfcDc=aSOW553Twi0oqNjREeminQ2tnZeEmQ@mail.gmail.com>
	<5162CB51.3080600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5162CB51.3080600-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 8, 2013 at 4:51 PM, Kleber Sacilotto de Souza
<klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> Or, I don't have a very comprehensive testcase to stress most part of
> the IB stack during error recovery, but during my tests the kernel
> consumer that are still hanging is the ib_sa module, mcast_remove_one()
> is waiting for the port completion queue:

best if you can send the whole relevant picture, e.g use the sysrq "t"
dump when things are hanged and send the stack trace of all (or all
involved) kernel-threads/processes

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
