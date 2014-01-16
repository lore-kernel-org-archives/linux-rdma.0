From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 09/14] IB/mlx5: Add support for resize CQ
Date: Thu, 16 Jan 2014 10:58:07 +0100
Message-ID: <1389866287.572.32.camel@localhost.localdomain>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
	 <1389714323-20130-10-git-send-email-eli@mellanox.com>
	 <1389717410.1585.67.camel@localhost.localdomain>
	 <20140115073316.GB31664@mtldesk30>
	 <1389780175.572.10.camel@localhost.localdomain>
	 <20140115112416.GD31664@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140115112416.GD31664@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 15 janvier 2014 =C3=A0 13:24 +0200, Eli Cohen a =C3=A9crit =
:
> On Wed, Jan 15, 2014 at 11:02:55AM +0100, Yann Droneaud wrote:
> >=20
> > Is libmlx5/libibverbs the ABI ?
> >=20
> > Unfortunately, anybody is allowed to access the kernel uverbs API
> > directly, so we must take care of the kernel ABI, just in case.
> >
>=20
> I am not sure I understand the question but libibverbs to libmlx5
> relation is somehow like the relationship between ib_core and mlx5_ib=
=2E
> e.g. libibverbs sets the API and libmlx5 implements it.

It's a theoretical question:
where to draw the line of the kernel ABI when it comes to uverbs ?
Is it write() + all the data structures for request and response ?
Or is it libibverbs + provider specific library ?

In second case, we can change the behavor of the uverbs provided that i=
t
doesn't interfere with libibverbs: modifying corner case behavors which
were never hit by libibverbs is then safe: it won't break userspace
application.

But in the first case, we cannot for sure attest that modifying behavor
will not break hypothetical userspace application issuing uverbs comman=
d
without going through libibverbs: such specific/specialized application
might call uverbs in a way different that libibverbs which could break.

I'm not aware of such unknown application, but I believe it could exist=
s
in the "proprietary" world.

> >=20
> > For code not yet part of a released kernel version, we can fix that=
=2E
> > But for all other, it would require proper checking/thinking before
> > rejecting reserved field not set to 0 since it might theoterically =
break
> > existing userspace program: it will be a departure from previous AB=
I.
> >=20
>=20
> Yes, this needs to be done carefully for each driver. We need to chec=
k
> if either libibverbs or any other provider library clears the struct
> before sending. If this is the case then it should be safe to fix the
> kernel part.
>=20
> >=20
> > I would found more readable to have the two locks held next each ot=
her.
> > YMMV.
> >=20
> I am not following you here. Please be more specific.

I thought that reworking the code to move mutex_lock(&cq->resize_mutex)
and spin_lock_irqsave(&cq->lock, flags); next to each other
could show that the first one would not be needed: perhaps is it
possible doing:
 - prepare everything,
 - take the lock,
 - swap,
 - release the lock,
 - clean up.
(oh, that remind me RCU).

I agree that resizing the CQ is not a frequent operation, so trying to
rewrite the code as I suggest won't give a lot of advantages.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
