From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 0/2] Using multi-smps on the wire in libibnetdisc
Date: Thu, 4 Feb 2010 16:13:25 -0800
Message-ID: <20100204161325.c4481bfe.weiny2@llnl.gov>
References: <20100202164514.bf2b152a.weiny2@llnl.gov>
	<f0e08f231002040619y34784bauec6a25d31e7d229b@mail.gmail.com>
	<20100204100045.4d2aa9aa.weiny2@llnl.gov>
	<f0e08f231002041201y2b48aa30nc33d2816ed11b1bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f231002041201y2b48aa30nc33d2816ed11b1bf-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 4 Feb 2010 15:01:32 -0500
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Feb 4, 2010 at 1:00 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> > On Thu, 4 Feb 2010 09:19:39 -0500
> > Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Tue, Feb 2, 2010 at 7:45 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> >> > Sasha,
> >> >

[snip]

> >> >
> >> > real =A0 =A00m2.249s
> >> > user =A0 =A00m1.244s
> >> > sys =A0 =A0 0m0.936s
> >> >
> >> > 14:40:59 > time ./ibnetdiscover -o 4 --node-name-map /etc/opensm=
/ib-node-name-map -g > new
> >> >
> >> > real =A0 =A00m2.170s
> >> > user =A0 =A00m1.160s
> >> > sys =A0 =A0 0m0.933s
> >> >
> >> > 14:41:10 > /usr/sbin/ibqueryerrors =A0-s RcvErrors,SymbolErrors,=
RcvSwRelayErrors,XmtWait -r --data
> >> > Suppressing: RcvErrors SymbolErrors RcvSwRelayErrors XmtWait
> >> > Errors for 0x66a00d90006fb "SW19"
> >> > =A0 GUID 0x66a00d90006fb port 9: [VL15Dropped =3D=3D 3] [XmtData=
 =3D=3D 25187379] [RcvData =3D=3D 25196688] [XmtPkts =3D=3D 349861] [Rc=
vPkts =3D=3D 349954]
> >> > =A0 =A0 =A0 Link info: =A0 =A0139 =A0 9[ =A0] =3D=3D( 4X 5.0 Gbp=
s Active/ =A0LinkUp)=3D=3D> =A00x0002c9030001d736 =A0 =A0864 =A0 =A01[ =
=A0] "hyperion1" ( )
> >> >
> >> > Note that there were no additional VL15Dropped packets on the fa=
bric. =A0I think 4 seems to be a good compromise. =A0I have not tested =
when there are errors on the fabric. =A0(Right now things seem to be go=
od!)
> >>
> >> Is this just with the SM doing light sweeping ?
> >
> > Yes.
>=20
> That's not a lot of SMP stress from the SM side. SMP consumers are SM=
,
> diags, and the unsolicited traps.

Agreed.  I hope to test this more next week.

>=20
> >
> >>
> >> Is there a speedup with 4 rather than 2 ?
> >
> > There is a bit of a speed up (~0.5 to 1.0 sec). =A0But my main reas=
on to want to
> > go to 4 is that if there are issues on the fabric, unresponsive nod=
es etc.; 4
> > will give us better parallelism to get around these issues. =A0I ha=
ve not had
> > the chance to test this condition with the new algorithm but the or=
iginal
> > ibnetdiscover would slow way down when there are nodes which have u=
nresponsive
> > SMA's. =A0If there are only 2 outstanding this will not give us muc=
h speed up.
> > This was the main motivation I had for improving the library in thi=
s way.
> >
> > Also, I think you are correct that we should increase OpenSM's defa=
ult from 4
> > to 8. =A0For the same reason as above. =A0Some of our clusters have=
 worked better
> > with 8 when we are having issues. =A0But right now we are still run=
ning with 4.
>=20
> I'm concerned about just increasing ibnetdiscover to 4 rather than 2.
> I've seen a number of clusters with SMP dropping with the current
> lower defaults.

So OpenSM is seeing dropped packets?  With 4 SMP's on the wire?  I do s=
ee some
VL15Dropped errors (maybe 2-3 a day) but I did not think that would be =
an
issue.  What kind of rate are you seeing?

The other question is; do people regularly run the tools which are usin=
g
libibnetdisc (ibqueryerrors, iblinkinfo, ibnetdiscover)?  We do.  If ot=
hers
are not then I would say this change would have less impact as they wou=
ld want
the diags to have some priority for debugging.  The other option is to =
change
the patch to be a default of 2 and allow user to change it depending on=
 what
they are trying to do.  If you think that is best I will change the pat=
ch.

Ira

>=20
> -- Hal
>=20
> > Ira
> >
> >>
> >> -- Hal
> >>
> >> >
> >> > The first patch converts the algorithm and the second adds the i=
bnd_set_max_smps_on_wire call.
> >> >
> >> > Let me know what you think. =A0Because the algorithm changed so =
much testing this is a bit difficult because the order of the node disc=
overy is different. =A0However, I have done some extensive diffing of t=
he output of ibnetdiscover and things look good.
> >> >
> >> > Ira
> >> >
> >> > --
> >> > Ira Weiny
> >> > Math Programmer/Computer Scientist
> >> > Lawrence Livermore National Lab
> >> > 925-423-8008
> >> > weiny2-i2BcT+NCU+M@public.gmane.org
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-=
rdma" in
> >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > More majordomo info at =A0http://**vger.kernel.org/majordomo-inf=
o.html
> >> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at =A0http://**vger.kernel.org/majordomo-info.=
html
> >>
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
