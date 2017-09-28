From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v1 rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Thu, 28 Sep 2017 06:51:56 +0000
Message-ID: <CY1PR0701MB2012C618091A14B2A097E2CA88790@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <1505885986-5873-1-git-send-email-Michal.Kalderon@cavium.com>
 <1506518845.82712.15.camel@redhat.com>
 <CY1PR0701MB20126E3E86A45619079DFCAC88780@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20170927165339.GI2297@mtr-leonro.local>
 <20170927165610.GJ2297@mtr-leonro.local>
 <CY1PR0701MB2012A41A0744D17AD3CD10DB88780@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20170928032725.GO2297@mtr-leonro.local>
 <CY1PR0701MB20122CDD0A73BB963A43755288790@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20170928064955.GP2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170928064955.GP2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Thursday, September 28, 2017 9:50 AM
>=20
> On Thu, Sep 28, 2017 at 06:22:59AM +0000, Kalderon, Michal wrote:
> > > >
> > > > When running git log on the k.o/for-next I see the patch (last in
> > > > list below), applying this patch on top of  rdma-next works for me
> > > > and
> > > compiles cleanly.
> > > >
> > > > 2e2f2d0 RDMA/qedr: Fix rdma_type initialization
> > > > 1848757 Merge branches 'hns' and 'misc' into k.o/for-next 931bc0d I=
B:
> > > > Move PCI dependency from root KConfig to HW's KConfigs 7ae6f2a
> > > > Merge branch 'qedr' into k.o/for-next
> > > > bd491d2 RDMA/qedr: fix build error without ipv6
> > > > 89fd257 RDMA/qedr: Missing error code in qedr_init_user_queue()
> > > > 847cb1a RDMA/qedr: fix spelling mistake: "invlaid" -> "invalid"
> > > > 69ad0e7 RDMA/qedr: Add support for iWARP in user space
> > > > e411e05 RDMA/qedr: Add iWARP connection management functions
> > > de0089e
> > > > RDMA/qedr: Add iWARP connection management qp related callbacks
> > > > fb1a22b RDMA/qedr: Add support for read with invalidate, supported
> > > > in iWARP
> > > > f5b1b17 RDMA/qedr: Add iWARP support in existing verbs
> > > > e6a38c5 RDMA/qedr: Add support for registering an iWARP device
> > > >
> > > > am i missing something ?
> > >
> > > I refreshed my branches now and it worked, but your git log history
> > > looks strange. Where did you see the commit 1848757 and 931bc0d?
> >
> > git://github.com/dledford/linux.git
> > git log --oneline -- drivers/infiniband/hw/qedr
> >
> https://github.com/dledford/linux/commit/1848757c3d8bff3addf881c8bcc2b
> > 85e25ccf25e
> >
> > I was under the assumption a patch goes to github before k.o - is this =
not
> the case ?
>=20
> Repo on github is Doug's private repository, while it is much safer to st=
ick
> with one official on kernel.org.
>=20
> Thanks

Ok, thanks.=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
