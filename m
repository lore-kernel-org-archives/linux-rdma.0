From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Thu, 06 Feb 2014 16:02:03 -0800
Message-ID: <1391731323.14985.56.camel@haakon3.risingtidesystems.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
	 <CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
	 <52CD1C68.4050406@mellanox.com>
	 <1389645171.5567.459.camel@haakon3.risingtidesystems.com>
	 <1389820541.5567.543.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
	 <1389906852.5567.668.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>
	 <1390102949.5567.749.camel@haakon3.risingtidesystems.com>
	 <52DBB4F1.4020400@mellanox.com>
	 <CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>
	 <CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>
	 <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
	 <1390375658.5567.917.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1390375658.5567.917.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Or Gerlitz <or.gerlitz@gmail.com>, Hefty Sean <sean.hefty@intel.com>, linux-rdma <linux-rdma@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, target-devel <target-devel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

On Tue, 2014-01-21 at 23:27 -0800, Nicholas A. Bellinger wrote:
> Roland & Co,
>=20
> On Tue, 2014-01-21 at 16:43 -0800, Roland Dreier wrote:
> > On Tue, Jan 21, 2014 at 2:00 PM, Or Gerlitz <or.gerlitz@gmail.com> =
wrote:
> > > Roland, ping! the signature patches were posted > three months ag=
o. We
> > > deserve a response from the maintainer that goes beyond "I need t=
o
> > > think on that".
> > >
> > > Responsiveness was stated by Linus to be the #1 requirement from
> > > kernel maintainers.
> >=20
> > Or, I'm not sure what response you're after from me.  Linus has als=
o
> > said that maintainers should say "no" a lot more
> > (http://lwn.net/Articles/571995/) so maybe you want me to say, "No,=
 I
> > won't merge this patch set, since it adds a bunch of complexity to
> > support a feature no one really cares about."  Is that it?=20
>=20
> The patch set proposed by Sagi + Or is modest in terms of LOC to core=
 IB
> code, and includes mostly mlx5 specific driver changes that enables H=
W
> offloads.
>=20
> > (And yes I
> > am skeptical about this stuff =E2=80=94 I work at an enterprise sto=
rage
> > company and even here it's hard to find anyone who cares about
> > DIF/DIX, especially offload features that stop it from being
> > end-to-end)
> >=20
>=20
> My understanding is most HBAs capable of T10 PI offload in DIX PASS +
> VERIFY mode are already implementing DIX INSERT + STRIP modes in vari=
ous
> capacities to support legacy environments.
>=20
> Beyond the DIX INSERT + STRIP case for enterprise storage, the amount=
 of
> FC + SAS HBAs that already support T10 PI metadata is substantial.
>=20
> > I'm sure you're not expecting me to say, "Sure, I'll merge it witho=
ut
> > understanding the problem it's solving or how it's doing that,"
> > especially given the your recent history of pushing me to merge stu=
ff
> > like the IP-RoCE patches back when they broke the userspace ABI.
>=20
> With the merge window now upon us, there is a understandable reluctan=
ce
> to merge new features.  Given the amount of time the series has spent=
 on
> the list, it is however a good candidate to consider for an exception=
=2E
>=20
> Short of that, are you planning to accept the series for the next rou=
nd
> once the current merge window closes..?
>=20
> We'd really like to start enabling fabrics with these types of offloa=
ds
> for v3.15.=20
>=20

Now with the initial DIF backend taraget support in place for v3.14-rc1
code, we'd like to move forward on iser-target related pieces for T10
PI.

Can you give us an estimate of when you'll have some time to give
feedback on the outstanding patches..?

--nab
