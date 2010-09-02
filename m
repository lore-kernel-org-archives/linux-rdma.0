From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: OFED 1.5.2: libibumad.so version bump
Date: Thu, 2 Sep 2010 14:05:02 -0700
Message-ID: <20100902140502.62489af7.weiny2@llnl.gov>
References: <4C7CCB01.909@dev.mellanox.co.il>
	<20100831124915.ac4dc1bd.weiny2@llnl.gov>
	<AANLkTim1_D5+GMWX80X0afu8A8_kizbQUq1KUhxxSLpz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <AANLkTim1_D5+GMWX80X0afu8A8_kizbQUq1KUhxxSLpz-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Mark A. Grondona" <mgrondona-i2BcT+NCU+M@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabricsEWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Yevgeny-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, "Moody,  Adam T." <moody20-i2BcT+NCU+M@public.gmane.org>, Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2 Sep 2010 13:35:44 -0700
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi Ira,
> =

> On Tue, Aug 31, 2010 at 3:49 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> > On Tue, 31 Aug 2010 02:27:29 -0700
> > Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Hi all,
> >>
> >> In order to support RoCEE, a while ago I've added
> >> a new field to umad, thus introduced an ABI change.
> >>
> >> There already was a discussion on the linux-rdma list,
> >> but due to the proximity of the upcoming OFED 1.5.2
> >> release these concerns were raised again.
> >>
> >> So my question is, other that *general* concerns about
> >> changing ABI, is anybody aware of the *actual* problem
> >> that will be caused by this? Any customer/3rd party
> >> solution that would be affected by this?
> >
> > Because our MVAPICH depends on umad, libibumad.so.1 to be exact.[*] =A0=
These ABI
> > changes (to v2 and v3) would have forced our users to recompile their c=
odes.
> > We are maintaining the old ABI here until our next major release of CHA=
OS[#]
> > to prevent this.
> >
> > I think the thing to remember is that many people are using Open Fabrics
> > software, but are _not_ using "OFED". =A0What is tested with OFED is no=
t the
> > only thing which might be using these libraries. =A0Our version of MVAP=
ICH is a
> > good example.
> >
> > I am certainly not the expert in this area and I know that many people =
have
> > tried to make this point in the past, but I will say it here again. =A0=
Each of
> > these Open Fabrics packages _must_ be maintained to stand on their own.
> > Roland did this a long time ago with ibverbs.
> >
> > I think now is a good time to start discussing breaking up the "managem=
ent" git
> > tree so that these libraries can live on their own.
> =

> How does breaking up the "management" git tree help with this issue ?

Creating and tracking of branches to maintain ABI would be easier with
separate git trees.  Furthermore, separate trees will help "force" the use =
of
consistent ABI's and interfaces.

For example, if I currently want OpenSM version 3.3.6 I get a management tr=
ee
with version libibumad 1.3.5.  But this last ABI change to umad was only
required for the latest infiniband-diags (ibstat utility).  Why do I get all
this "cruft" when pulling the latest OpenSM?

> To me, that's the admin part and is separate from the ABI issue
> raised.

Yes it is separate.  That is why I created another thread to discuss those
issues.

>
> The ABI compatibility is not achieved by administrative means
> (separate repos, etc.) but rather than review and discipline to
> achieve this as a unmutable goal.

I agree that ABI compatibility will require more discipline.  That is what
made me think of the separate git trees.  I feel it will be _easier_ to
maintain this discipline when the trees are separate.

Ira

> =

> -- Hal
> =

> > I will write a separate email regarding this.
> >
> > Ira
> >
> > [*] We are looking into removing the dependency.
> > [#] Shameless plug: http://*code.google.com/p/chaos-release/wiki/CHAOS_=
Description
> >
> >>
> >> -- Yevgeny
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at =A0http://**vger.kernel.org/majordomo-info.html
> >>
> >
> >
> > --
> > Ira Weiny
> > Math Programmer/Computer Scientist
> > Lawrence Livermore National Lab
> > 925-423-8008
> > weiny2-i2BcT+NCU+M@public.gmane.org
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://*vger.kernel.org/majordomo-info.html
> >
> =



-- =

Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
