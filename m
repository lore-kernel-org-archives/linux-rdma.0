From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Wed, 10 Jan 2018 14:30:39 -0500
Message-ID: <1515612639.10153.3.camel@redhat.com>
References: <fcc3f226-848d-abc4-2a81-f4fd821761c9@wdc.com>
         <1515528956.3919.3.camel@redhat.com> <1515529869.3919.4.camel@redhat.com>
         <1515531079.2721.26.camel@wdc.com> <1515531652.26021.1.camel@redhat.com>
         <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
         <20180110182648.GI4518@ziepe.ca> <1515609623.2745.20.camel@wdc.com>
         <1515610750.10153.1.camel@redhat.com> <20180110191510.GK4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110191510.GK4518-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-01-10 at 12:15 -0700, Jason Gunthorpe wrote:
> On Wed, Jan 10, 2018 at 01:59:10PM -0500, Laurence Oberman wrote:
> 
> > Yep, this seems specific to the mlx5 and IB. 
> > The problem though is Linus's tree 4.15-rc-7 already has enough of
> > the
> > part of the RDMA updates to see issues.
> 
> Every time you post a backtrace it is different.. The only
> commonality
> seems to be that the CQ completion core appears to be processing
> garbage, accompanied by these sorts of sketch kernel messages from
> mlx5:
> 
> > [ 1360.511682] mlx5_core 0000:08:00.1: Shutdown was called
> > [ 1360.550531] mlx5_core 0000:08:00.1:
> > mlx5_enter_error_state:121:(pid
> > [  938.938946] mlx5_core 0000:08:00.1: Shutdown was called
> > [  938.968423] mlx5_core 0000:08:00.1:
> > mlx5_cmd_force_teardown_hca:245:(pid 14752): teardown with force
> > mode failed
> > [  938.978359] mlx5_core 0000:08:00.1:
> > mlx5_cmd_comp_handler:1445:(pid 13186): Command completion arrived
> > after timeout (entry idx = 0).
> > [  942.209464] mlx5_1:wait_for_async_commands:735:(pid 14752): done
> > with all pending requests
> 
> My other guess is a mlx5 issue where it is returning CQ wrids it
> should not return?
> 
> Leon?
> 
> I don't see anything changing in this area in rdma.git for-rc, so I
> can't give you a guess on a patch, sorry.
> 
> Do you think this test ever worked for you? You said bisect, so I
> assume so?
> 
> Jason
Hi Jason

Just to be clear, I have posted two types of stack traces, one where I
panic the other here above where I am not panicking.

This is not any special type of test. I booted the kernel, mapped the
SRP devices from the target server and proceeded to shutdown the client
with shutdown -r now.
This is part of my holistic test I always do against new patches in
Bart's tree.
I start with reboots, them rmmod's etc. before I go on to perform I/O
against the LUNS from the target.

The panic was the first issue I came across after building a kernel
with Bart's tree.
I have not even started testing anything else yet.

The trace above was provided because Bart asked me to test two kernels,
 
1. Linus's tree 4.15-rc7 
2. The RDMA tree.

Bart's Tree panics the same as the RDMA tree I cloned.

I will look at prior release candidates in Linus's tree and see where
this maybe crept in. I am of course puzzled why I am the only one to
see it, other folks must have MLX5 (CX4) like I do.

Would be good to know what test was last performed on the current RDMA
tree by Leon and team.

Regards
Laurence

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
