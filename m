From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 9 Sep 2015 08:44:05 -0700
Message-ID: <CA+55aFxJovuBGpg04YM0AvrzL_TPDoHebkP21R7tO3=QMQUUXQ@mail.gmail.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
	<CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
	<CA+55aFyeLEab0qjNV1+V-mX2ZhExs1z5VtdusgpDnMeNBg-d6Q@mail.gmail.com>
	<55EFA2BF.7060006@redhat.com>
	<CA+55aFwg+QCM=xaoK4ic+4AymqCYrF4Ny8WO9iY2hHFBLNT3VQ@mail.gmail.com>
	<55F02006.5020504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F02006.5020504-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 9, 2015 at 5:03 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Me telling Matan to Cc: netdev on patches related to their subsystem:
> http://marc.info/?l=linux-rdma&m=143398479529819&w=4
>
> Above was v5 of the patchset.  Both the v6 and v7 of the patchset had
> netdev Cc:ed on the cover letter and at least the first three patches.

Ok, good. That's the kind of information I was missing.

> Here's the v7 cover and the first three patches in the netdev archives:
> http://marc.info/?l=linux-netdev&m=143827052913936&w=4

.. and this is the one I will effectively have to revert because of
the conflict.

> Here Jason Gunthorpe is asking me if I was going to take netdev stuff
> without an ack from netdev in the netdev archives:
> http://marc.info/?l=linux-netdev&m=143836033706501&w=4
>
> And here is my response to Jason, again, in the netdev archives:
> http://marc.info/?l=linux-netdev&m=143836450808174&w=4

Good. So this was all done right, it just wasn't visible in the commit history.

> See above.  This was done.

Ok. I've merged it in my tree now, it's just waiting for the usual compile-test.

Note that a correct merge (which looking at it, Stephen didn't
actually do after all) also involves getting rid of the "struct
netdev_changeupper_info" type that _isn't_ actually getting filled at
all, and converting your one user of it in
drivers/infiniband/core/roce_gid_mgmt.c to what the networking layer
actually does.

> I see perfectly well Linus.  I am not new to engineering.  You have
> stated several times that I'm missing the point, or do I see your point,
> please understand mine: I *did* the things you are assuming I didn't do.

Yes, I see them, thanks for the links.

It would have helped if the commit logs had had a record of this
somehow (ie a "Cc: netdev" etc so that I could tell during the merge
that this was actually something the networking people knew about).

That would have avoided a lot of my angst. Sorry,

                     Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
