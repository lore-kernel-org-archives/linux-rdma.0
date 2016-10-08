From: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH qedr 04/10] qedr: Add support for PD,PKEY and CQ verbs
Date: Sat, 8 Oct 2016 23:20:00 +0000
Message-ID: <CY1PR0701MB1337C583200AC5417584785090D90@CY1PR0701MB1337.namprd07.prod.outlook.com>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
 <1475682483-9878-5-git-send-email-Ram.Amrani@cavium.com>
 <20161006133357.GP9282@leon.nu>
 <CY1PR0701MB1337AC7B933E917765C3EBC990C60@CY1PR0701MB1337.namprd07.prod.outlook.com>
 <20161007142454.GU9282@leon.nu>
 <a146f562-1970-e939-1bd5-074af868f7d6@redhat.com>
 <20161008153942.GY9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161008153942.GY9282-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > My personal taste on things like this is that if you had something like
> > a variable with a result code, then use a separate enum for the possibl=
e
> > options.  However, in this case, you have a multi-mask item and the
> > defines are the three masks and their shifts.  I'm OK with that being
> > mixed in or being separate, but if it's separate, I would want it
> > immediately before the struct with a comment specifying that this is th=
e
> > format of the status byte in the struct.  What I wouldn't want is the
> > #defines moved far away from the struct with a bunch of other defines
> > where the context of the struct is lost.
>=20
> It looks like you are neutral on the topic, and I'm against mixing these
> specific defines with structures. Every change in such define changes
> struct as well which can be easily missed out.
>=20

Leon, I don't think that is reasonable. I can accept that refactoring all o=
f
our code so that defines end up outside the structures would make it
easier for you personally to review, but I don't agree there is any general
improved readability. Quite the opposite. The whole purpose of storing
the defines adjacent to their fields is so you can easily associate them
together. The reason that this style is used by so many people is *for*
improved debuggability and readability. This style is prevalent throughout
the kernel. Even if you think net is a bad example (while I think it is an
excellent example), you can find examples in every corner of the kernel
so this is not "a net thing".

Here are just a few examples outside of net (there are thousands):
fs/cachefiles/internal.h line 86
block/partitions/acorn.c line 69
crypto/jitterentropy.c line line 78
kernel/sched/sched.h lines 594 and 1250
drivers/block/drbd/drbd_int.h line 996
drivers/gpu/drm/gma500/psb_intel_drv.h line 128

As Doug is comfortable with this style, we are going to leave it as is.
Try thinking of our entrance to linux-rdma as an opportunity to cross-
pollinate and bring over some new techniques and new people into
the subsystem.

Thanks,
Ariel
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
