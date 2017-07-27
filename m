From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Common infrastructure for auto loading rdma
 modules
Date: Thu, 27 Jul 2017 22:28:59 +0000
Message-ID: <1501194538.2516.10.camel@wdc.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1500929067-1583-2-git-send-email-jgunthorpe@obsidianresearch.com>
         <1501002916.8931.4.camel@wdc.com>
         <20170725173947.GA10905@obsidianresearch.com>
         <20170727221850.GB16986@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170727221850.GB16986-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <C8D7FB573F75AC4BBA686FD3510FF189-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org" <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-27 at 16:18 -0600, Jason Gunthorpe wrote:
> On Tue, Jul 25, 2017 at 11:39:47AM -0600, Jason Gunthorpe wrote:
> > > > +# Hardware that supports RoCE
> > > > +DRIVERS=3D=3D"be2net", ENV{ID_RDMA_ROCE}=3D"1"
> > > > +DRIVERS=3D=3D"bnxt_en", ENV{ID_RDMA_ROCE}=3D"1"
> > > > +DRIVERS=3D=3D"hns", ENV{ID_RDMA_ROCE}=3D"1"
> > > > +DRIVERS=3D=3D"i40e", ENV{ID_RDMA_ROCE}=3D"1"
> > > > +DRIVERS=3D=3D"mlx4_core", ENV{ID_RDMA_ROCE}=3D"1"
> > > > +DRIVERS=3D=3D"mlx5_core", ENV{ID_RDMA_ROCE}=3D"1"
> > > > +DRIVERS=3D=3D"qede", ENV{ID_RDMA_ROCE}=3D"1"
> > >=20
> > > Should the "rdma_rxe" driver be added to this list?
> >=20
> > No.. I need to figure out something else for rxe. We have no way in
> > RDMA to determine the driver binding to the RDMA device (eg like
>=20
> This looks like a good bet for now:
>=20
> DEVPATH=3D=3D"*/infiniband/rxe*", ATTR{parent}=3D=3D"*", ENV{ID_RDMA_ROCE=
}=3D"1"
>=20
> Now that I'm looking at rxe I notice that srp_daemon starts
> automatically for roce ports.
>=20
> I assume this is not desired?

Hello Jason,

The srp_daemon communicates with the IB SA to discover SRP target ports. As
you know there is no SA in a RoCE network. I think it is harmless to start
srp_daemon against a RoCE port but I don't think this makes sense.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
