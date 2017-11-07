From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: daily Ubuntu PPA builds for rdma-core
Date: Tue, 07 Nov 2017 14:00:50 +0100
Message-ID: <1510059650.32330.2.camel@profitbricks.com>
References: <1510052419.25086.12.camel@profitbricks.com>
         <20171107113857.GG18825@mtr-leonro.local>
         <1510056129.25086.14.camel@profitbricks.com>
         <20171107125659.GH18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-/k8gTmHQtuCT5spzFgez"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107125659.GH18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-/k8gTmHQtuCT5spzFgez
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 07.11.2017, 14:56 +0200 schrieb Leon Romanovsky:
> On Tue, Nov 07, 2017 at 01:02:09PM +0100, Benjamin Drung wrote:
> > Am Dienstag, den 07.11.2017, 13:38 +0200 schrieb Leon Romanovsky:
> > > On Tue, Nov 07, 2017 at 12:00:19PM +0100, Benjamin Drung wrote:
> > > > Hi,
> > > >=20
> > > > are you interested in having daily Ubuntu PPA [1] builds for
> > > > the
> > > > rdma-
> > > > core master branch on Launchpad? I could set them up easily and
> > > > they
> > > > would produce usable .deb packages for all Ubuntu
> > > > distributions.
> > >=20
> > > Yes, together with Nicholas's openbuild setup, it saves from me
> > > to
> > > setup packagecloud.io.
> >=20
> > Okay. I will do the setup. Following steps are needed:
> >=20
> > 1) Convert https://launchpad.net/~linux-rdma into a Launchpad group
> > 2) Setup a git import of the rdma-core github repository
> > 3) Write a build recipe (very simple)
> >=20
> > If you have Launchpad account, you can join the linux-rdma group
> > (once
> > created).
>=20
> Once, you will finish the step (1), please drop the note here and
> people will join.

I will. Currently I am waiting for getting the 'linux-rdma' name back.
See https://answers.launchpad.net/launchpad/+question/660443

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg
--=-/k8gTmHQtuCT5spzFgez
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJaAa6CAAoJEN2M1aXejH56efIP+wRHzOePFVv7XXMHh6u5I8KN
UQLRk0pJaghPm8/x5PDiVFp6uZ+o6BjB7GnffJDB11JEFHWbGAMR5GkEIKv7jfTa
aZAWxSgHye36xK0sm86x7Pwyk4I74PfjNVQfxP6UJARGlDXOCqIjUTvAfCEqIZvH
8Cvl30h16k5xc6d9uGu+ZXSq56FomXpiOE5jebONIfWLreQJovxuYxHCtW9J38Oa
pwHJYuPMi/dUmRegSxgHfSaP+64tfHx+xJf+IFGsjUAIju0rYRzVU/7dLBP8IGm/
vHHA44Q7chZRIb6dtmGFnrQV+H82E/HHdkkYBKuaAvgzCtvxke+1Iv0nmBo4ecZa
yWitrlr1u6Uea8nh5QnmzDL/mUKVTFQH20CExehrVvDtcGtcatwFXlBS5AaIwv5M
HYDx2jHMI49HSSzCUMusZDRbSBuQl7p4J5EBehqDTz6q6dOVOYbaOadLi6LaJ3c8
RZlHS9rKoIdU6YB37IyrpkU31sW8zQaQvJnUyVDk3wwUSi8OVEYeNADHtCmcndrC
e8cBppt0J5jLTaawrpdJbPXXJtdpTvoBtQ/QrHS/treU+8kfxHpGuJxJ3fpMqVgr
50uzriJHOPK6UdRlssj8WYzMkKfu0woMWsiUH6iX81qtmQITPqPyRPNXTJOO0IPT
etSDtSd9rkl8dCMDAhG3
=JpT9
-----END PGP SIGNATURE-----

--=-/k8gTmHQtuCT5spzFgez--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
