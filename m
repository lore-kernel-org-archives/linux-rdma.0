From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V6 05/10] IB/core: Add RoCE GID table management
Date: Thu, 23 Jul 2015 13:05:08 -0600
Message-ID: <20150723190508.GA31577@obsidianresearch.com>
References: <1435150766-6803-1-git-send-email-matanb@mellanox.com>
 <1435150766-6803-6-git-send-email-matanb@mellanox.com>
 <20150717190245.GA20632@obsidianresearch.com>
 <CAAKD3BA2Qgw87uXiS-M9gO1-jXPfQncyWzscMuusMABPRRzA8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BA2Qgw87uXiS-M9gO1-jXPfQncyWzscMuusMABPRRzA8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 21, 2015 at 11:42:29AM +0300, Matan Barak wrote:
> On Fri, Jul 17, 2015 at 10:02 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Wed, Jun 24, 2015 at 03:59:21PM +0300, Matan Barak wrote:
> >> +
> >> +     /* in rdma_cap_roce_gid_table, this funciton should be protected by a
> >> +      * sleep-able lock.
> >> +      */
> >> +     write_lock(&table->data_vec[ix].lock);
> >
> > I'm having a hard time understanding this comment
> >
> 
> The same function is used for both RoCE and IB. Since RoCE unlocks the
> rwlock, calls the vendor's callback and
> locks it again. If two write_gid(s) are executed simultaneously,  you
> need to protect them from writing to the
> same entry. The vendor's callback might sleep so we require a sleep-able lock.

You might want to retouch that comment a bit..

> >> +int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
> >> +                  union ib_gid *gid, struct ib_gid_attr *attr)
> >> +{
> >> +     struct ib_gid_table **ports_table =
> >> +             READ_ONCE(ib_dev->cache.gid_cache);
> >> +     /* all table reads depend on ports_table, no need for smp_rmb() */
> >> +     if (!ports_table)
> >> +             return -EOPNOTSUPP;
> >
> > This common pattern does look genuinely odd...
> >
> > The gid_cache is part of the common API, it really shouldn't be kfree'd
> > while held struct ib_devices are around. The kfree for all the cache.c
> > stuff should probably be called from ib_device_release, not from the
> > client release.
> >
> > That is actually something the current code does that is possibly
> > wrong. It is trivially fixed by moving all the kfrees to
> > ib_device_release.
> >
> 
> But cache as a whole is implemented as a client (cache_client).
> Isn't it a bit odd to free a client in ib_device_release?

The cache is part of the core code, it exports core APIs that need to
continue working as long as a ib_device object exists.

It abuses the client stuff to hook registration, that doesn't make it
'wholly implemented as a client'

It is not odd for core code to free its memory in ib_device_release.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
