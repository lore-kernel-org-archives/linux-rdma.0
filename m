From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Tue, 25 Jul 2017 15:33:54 -0600
Message-ID: <20170725213354.GE10905@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com>
 <20170725164004.GA20959@obsidianresearch.com>
 <011601d30576$c3ac38c0$4b04aa40$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <011601d30576$c3ac38c0$4b04aa40$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 01:49:37PM -0500, Steve Wise wrote:

> After I rebooted, cxgb4 and iw_cxgb4 were loaded, but the services were not
> started.  I think that is probably due to the fact that iw_cxgb4 doesn't
> register with the rdma core until the cxgb4 interfaces are brought
> up.

Yes, it is done on demand when the kernel creates its side of the
interface.

> I then brought up port 0 of the cxgb4 card:
> 
> [root@stevo3 ~]# ip link set enp4s0f4 up
> [root@stevo3 ~]# ip addr add 172.16.3.3/24 dev enp4s0f4
> 
> And then the services were started:

Yep, everything you sent me looks fine, thanks for taking a look at
this.

This sort of hotplug that cxbg4 does is quite strange, what happens
when 'ip link set X down' is done? Does it remove the RDMA device?
Does 'ip link set down' block until all users go away?

This is going to make it harder for cxgb users to get a reliably
bootup at this time, we need more kernel autoloading for things to be
reliable, and I'm sure iwpmd.service needs some dependency adjusting,
I just don't know enough about it to do it right. :\

> I assume since iw_cxgb4 was loaded, that they worked.  Because before I
> installed rdma-core, after a reboot only cxgb4 was loaded.

Yep

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
