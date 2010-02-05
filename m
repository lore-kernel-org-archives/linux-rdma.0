From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 0/2] Using multi-smps on the wire in libibnetdisc
Date: Thu, 4 Feb 2010 18:18:52 -0800
Message-ID: <20100204181852.f175d968.weiny2@llnl.gov>
References: <20100202164514.bf2b152a.weiny2@llnl.gov>
	<f0e08f231002040619y34784bauec6a25d31e7d229b@mail.gmail.com>
	<20100204100045.4d2aa9aa.weiny2@llnl.gov>
	<f0e08f231002041201y2b48aa30nc33d2816ed11b1bf@mail.gmail.com>
	<20100204161325.c4481bfe.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100204161325.c4481bfe.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 4 Feb 2010 16:13:25 -0800
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> On Thu, 4 Feb 2010 15:01:32 -0500
> Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > On Thu, Feb 4, 2010 at 1:00 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> > > On Thu, 4 Feb 2010 09:19:39 -0500
> > > Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > >> On Tue, Feb 2, 2010 at 7:45 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrot=
e:
> > >> > Sasha,
> > >> >
>=20
> [snip]

[snip]

> > >>
> > >> Is there a speedup with 4 rather than 2 ?
> > >
> > > There is a bit of a speed up (~0.5 to 1.0 sec). =A0But my main re=
ason to want to
> > > go to 4 is that if there are issues on the fabric, unresponsive n=
odes etc.; 4
> > > will give us better parallelism to get around these issues. =A0I =
have not had
> > > the chance to test this condition with the new algorithm but the =
original
> > > ibnetdiscover would slow way down when there are nodes which have=
 unresponsive
> > > SMA's. =A0If there are only 2 outstanding this will not give us m=
uch speed up.
> > > This was the main motivation I had for improving the library in t=
his way.

Ok, I found a fabric with just 2 nodes which were unresponsive...  A qu=
ick
test shows...

Original ibnetdiscover:

18:12:29 > time ./ibnetdiscover > foo
ibwarn: [26993] mad_rpc: _do_madrpc failed; dport (DR path slid 0; dlid=
 0; 0,1,24,11,9)
src/ibnetdisc.c:457; Query remote node (DR path slid 0; dlid 0; 0,1,24,=
11,9) failed, skipping port
ibwarn: [26993] mad_rpc: _do_madrpc failed; dport (DR path slid 0; dlid=
 0; 0,1,24,24,18,7,6)
src/ibnetdisc.c:457; Query remote node (DR path slid 0; dlid 0; 0,1,24,=
24,18,7,6) failed, skipping port

real    0m9.073s
user    0m0.137s
sys     0m0.172s

18:12:43 > time ./ibnetdiscover > foo
ibwarn: [31111] mad_rpc: _do_madrpc failed; dport (DR path slid 0; dlid=
 0; 0,1,24,11,9)
src/ibnetdisc.c:457; Query remote node (DR path slid 0; dlid 0; 0,1,24,=
11,9) failed, skipping port
ibwarn: [31111] mad_rpc: _do_madrpc failed; dport (DR path slid 0; dlid=
 0; 0,1,24,24,18,7,6)
src/ibnetdisc.c:457; Query remote node (DR path slid 0; dlid 0; 0,1,24,=
24,18,7,6) failed, skipping port

real    0m9.103s
user    0m0.046s
sys     0m0.046s


*New* ibnetdiscover with different outstanding SMP's.

18:12:14 > time ./ibnetdiscover -o 2 > foo
src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,11,9 Attr 0x1=
1:0) bad status 110; Connection timed out
src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,13,7,7,6 Attr=
 0x11:0) bad status 110; Connection timed out

real    0m9.746s
user    0m6.559s
sys     0m3.156s

18:13:00 > time ./ibnetdiscover -o 4 > foo
src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,11,9 Attr 0x1=
1:0) bad status 110; Connection timed out
src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,13,7,7,6 Attr=
 0x11:0) bad status 110; Connection timed out

real    0m4.668s
user    0m3.043s
sys     0m1.601s

18:13:10 > time ./ibnetdiscover -o 8 > foo
src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,11,9 Attr 0x1=
1:0) bad status 110; Connection timed out
src/query_smp.c:185; umad (DR path slid 0; dlid 0; 0,1,13,13,7,7,6 Attr=
 0x11:0) bad status 110; Connection timed out

real    0m4.360s
user    0m2.891s
sys     0m1.451s


Note that 2 does not give much speed up, where 4 does.  Obviously this =
could
have to do with the fact there were 2 nodes which were bad (so if you h=
ad
100's of nodes unresponsive a higher value might be worth using) but as=
 a
default compromise I think 4 is good.

Ira

> > >
> > > Also, I think you are correct that we should increase OpenSM's de=
fault from 4
> > > to 8. =A0For the same reason as above. =A0Some of our clusters ha=
ve worked better
> > > with 8 when we are having issues. =A0But right now we are still r=
unning with 4.
> >=20
> > I'm concerned about just increasing ibnetdiscover to 4 rather than =
2.
> > I've seen a number of clusters with SMP dropping with the current
> > lower defaults.
>=20
> So OpenSM is seeing dropped packets?  With 4 SMP's on the wire?  I do=
 see some
> VL15Dropped errors (maybe 2-3 a day) but I did not think that would b=
e an
> issue.  What kind of rate are you seeing?
>=20
> The other question is; do people regularly run the tools which are us=
ing
> libibnetdisc (ibqueryerrors, iblinkinfo, ibnetdiscover)?  We do.  If =
others
> are not then I would say this change would have less impact as they w=
ould want
> the diags to have some priority for debugging.  The other option is t=
o change
> the patch to be a default of 2 and allow user to change it depending =
on what
> they are trying to do.  If you think that is best I will change the p=
atch.
>=20
> Ira
>=20
> >=20
> > -- Hal
> >=20
> > > Ira
> > >
> > >>
> > >> -- Hal
> > >>
> > >> >
> > >> > The first patch converts the algorithm and the second adds the=
 ibnd_set_max_smps_on_wire call.
> > >> >
> > >> > Let me know what you think. =A0Because the algorithm changed s=
o much testing this is a bit difficult because the order of the node di=
scovery is different. =A0However, I have done some extensive diffing of=
 the output of ibnetdiscover and things look good.
> > >> >
> > >> > Ira
> > >> >
> > >> > --
> > >> > Ira Weiny
> > >> > Math Programmer/Computer Scientist
> > >> > Lawrence Livermore National Lab
> > >> > 925-423-8008
> > >> > weiny2-i2BcT+NCU+M@public.gmane.org
> > >> > --
> > >> > To unsubscribe from this list: send the line "unsubscribe linu=
x-rdma" in
> > >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > >> > More majordomo info at =A0http://**vger.kernel.org/majordomo-i=
nfo.html
> > >> >
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-=
rdma" in
> > >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > >> More majordomo info at =A0http://**vger.kernel.org/majordomo-inf=
o.html
> > >>
> > >
> > >
> > > --
> > > Ira Weiny
> > > Math Programmer/Computer Scientist
> > > Lawrence Livermore National Lab
> > > 925-423-8008
> > > weiny2-i2BcT+NCU+M@public.gmane.org
> > >
> >=20
>=20
>=20
> --=20
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org


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
