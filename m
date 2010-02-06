From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 0/2] Using multi-smps on the wire in libibnetdisc
Date: Fri, 5 Feb 2010 17:03:26 -0800
Message-ID: <20100205170326.699f7e64.weiny2@llnl.gov>
References: <20100202164514.bf2b152a.weiny2@llnl.gov>
	<f0e08f231002040619y34784bauec6a25d31e7d229b@mail.gmail.com>
	<20100204100045.4d2aa9aa.weiny2@llnl.gov>
	<f0e08f231002041201y2b48aa30nc33d2816ed11b1bf@mail.gmail.com>
	<20100204161325.c4481bfe.weiny2@llnl.gov>
	<20100204181852.f175d968.weiny2@llnl.gov>
	<f0e08f231002050427r37d326b4w4c188e30992579ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f231002050427r37d326b4w4c188e30992579ac-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 5 Feb 2010 07:27:05 -0500
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> >
> >
> > Note that 2 does not give much speed up, where 4 does. =A0Obviously=
 this could
> > have to do with the fact there were 2 nodes which were bad (so if y=
ou had
> > 100's of nodes unresponsive a higher value might be worth using)
>=20
> It depends on the number of unresponsive nodes being same or higher
> than number of outstanding/parallel SMPs. In a sense, the number of
> outstanding SMPs is a measure of how many unresponsive nodes one is
> willing to tolerate before slowing down/waiting for timeouts. In some
> environments, unresponsive nodes are a normal case.

Agreed but where should we set the default?  I don't think 4 is a bad d=
efault.
I don't think it makes the diags overly aggressive, compared with OpenS=
M.
Sasha I guess this is your call.

Just tell me where to set it and I will make the patch.  Basically with=
 the
user option it can always be changed on a run by run basis.

Ira

>=20
> -- Hal
>=20
> > but as a
> > default compromise I think 4 is good.
> >
> > Ira
> >
> >> > >
> >> > > Also, I think you are correct that we should increase OpenSM's=
 default from 4
> >> > > to 8. =A0For the same reason as above. =A0Some of our clusters=
 have worked better
> >> > > with 8 when we are having issues. =A0But right now we are stil=
l running with 4.
> >> >
> >> > I'm concerned about just increasing ibnetdiscover to 4 rather th=
an 2.
> >> > I've seen a number of clusters with SMP dropping with the curren=
t
> >> > lower defaults.
> >>
> >> So OpenSM is seeing dropped packets? =A0With 4 SMP's on the wire? =
=A0I do see some
> >> VL15Dropped errors (maybe 2-3 a day) but I did not think that woul=
d be an
> >> issue. =A0What kind of rate are you seeing?
> >>
> >> The other question is; do people regularly run the tools which are=
 using
> >> libibnetdisc (ibqueryerrors, iblinkinfo, ibnetdiscover)? =A0We do.=
 =A0If others
> >> are not then I would say this change would have less impact as the=
y would want
> >> the diags to have some priority for debugging. =A0The other option=
 is to change
> >> the patch to be a default of 2 and allow user to change it dependi=
ng on what
> >> they are trying to do. =A0If you think that is best I will change =
the patch.
> >>
> >> Ira
> >>
> >> >
> >> > -- Hal
> >> >
> >> > > Ira
> >> > >
> >> > >>
> >> > >> -- Hal
> >> > >>
> >> > >> >
> >> > >> > The first patch converts the algorithm and the second adds =
the ibnd_set_max_smps_on_wire call.
> >> > >> >
> >> > >> > Let me know what you think. =A0Because the algorithm change=
d so much testing this is a bit difficult because the order of the node=
 discovery is different. =A0However, I have done some extensive diffing=
 of the output of ibnetdiscover and things look good.
> >> > >> >
> >> > >> > Ira
> >> > >> >
> >> > >> > --
> >> > >> > Ira Weiny
> >> > >> > Math Programmer/Computer Scientist
> >> > >> > Lawrence Livermore National Lab
> >> > >> > 925-423-8008
> >> > >> > weiny2-i2BcT+NCU+M@public.gmane.org
> >> > >> > --
> >> > >> > To unsubscribe from this list: send the line "unsubscribe l=
inux-rdma" in
> >> > >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > >> > More majordomo info at =A0http://***vger.kernel.org/majordo=
mo-info.html
> >> > >> >
> >> > >> --
> >> > >> To unsubscribe from this list: send the line "unsubscribe lin=
ux-rdma" in
> >> > >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > >> More majordomo info at =A0http://***vger.kernel.org/majordomo=
-info.html
> >> > >>
> >> > >
> >> > >
> >> > > --
> >> > > Ira Weiny
> >> > > Math Programmer/Computer Scientist
> >> > > Lawrence Livermore National Lab
> >> > > 925-423-8008
> >> > > weiny2-i2BcT+NCU+M@public.gmane.org
> >> > >
> >> >
> >>
> >>
> >> --
> >> Ira Weiny
> >> Math Programmer/Computer Scientist
> >> Lawrence Livermore National Lab
> >> 925-423-8008
> >> weiny2-i2BcT+NCU+M@public.gmane.org
> >
> >
> > --
> > Ira Weiny
> > Math Programmer/Computer Scientist
> > Lawrence Livermore National Lab
> > 925-423-8008
> > weiny2-i2BcT+NCU+M@public.gmane.org
> >
>=20


--=20
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
