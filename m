From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [ANNOUNCE] rdma-core-15-rc1 has been tagged/released
Date: Thu, 17 Aug 2017 12:27:12 +0200
Message-ID: <1502965632.3554.5.camel@profitbricks.com>
References: <1501590709.2725.10.camel@redhat.com>
         <20170802054512.GW13672@mtr-leonro.local>
         <1501761459.117042.5.camel@redhat.com>
         <20170816080523.GG24282@mtr-leonro.local>
         <1502902372.33760.17.camel@redhat.com>
         <20170816175144.GX24282@mtr-leonro.local>
         <1502961063.3554.3.camel@profitbricks.com>
         <20170817093648.GD23648@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-B0Ot3cE8i32UdZgc+gvZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817093648.GD23648-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-B0Ot3cE8i32UdZgc+gvZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 17.08.2017, 12:36 +0300 schrieb Leon Romanovsky:
> On Thu, Aug 17, 2017 at 11:11:03AM +0200, Benjamin Drung wrote:
> > Am Mittwoch, den 16.08.2017, 20:51 +0300 schrieb Leon Romanovsky:
> > > On Wed, Aug 16, 2017 at 12:52:52PM -0400, Doug Ledford wrote:
> > > > And I know this particular thread is in reference to the rdma-
> > > > core
> > > > package, I haven't forgotten it, I just haven't had a chance to
> > > > test it
> > > > yet :-/.
> > > >=20
> > >=20
> > > Thanks for the update, I asked it in context of rdma-core,
> > > because
> > > Yishai stopped submissions of all our user space patches till the
> > > official release and it included my one-liner fix to
> > > ibv_xsrq_pinpong
> > > :)
> >=20
> > As Debian maintainer, I am waiting for the rdma-core release to
> > finally
> > upload that version to Debian unstable. There is no required
> > improvement from my side any more.
>=20
> This is excellent news, so the rdma-core will be part of Ubuntu 17.10
> too.

I just checked https://wiki.ubuntu.com/ArtfulAardvark/ReleaseSchedule
and saw that the feature freeze will be in one week. So I have to
create a rdma-core snapshot now and upload that to Ubuntu.

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web:=C2=A0https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss.

--=-B0Ot3cE8i32UdZgc+gvZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJZlW+BAAoJEN2M1aXejH566rMP/1H86JStel9p2fz+Izb7Wyxx
mwICAa9LOv4BAWNdpMX292bjS2HqSubHhZOqwG62+yOERy7JRt6fJjckEHZ4eOns
onIJgdcw3xOd0g2pQjiHUJHVpPdRGksfkk0aq5HRVNu/8ixsjIh5oCUzbxAWfq5y
OsrbhEdCN/IaGssjDPnjXRXwOEZy3VlPwo7xrAEE9LjGdYiii55usit2vyy96mDH
kJS6XYa+JcSMNMFlJc7SLGaZfh5KWiaOZUlpfGoJT6MuO83Al1KRiiWNTlieJVwW
K81Yx6vQTVX9aAlW1Lhp6HDDbyjMs485eX3l65GynoXMonF+xrSkagT32CEaf5fy
s/LOCdGlkIh77mQeuewdre/J5za7HSWon6v68MiARaEHUfVaJzyflXOlwe2xR4/2
DTRHX/QUCqDD39OZaCfk0VtLt80HYQF7uNIHK/RTbjyZdYrBcWdYRv9kCKVhGaXe
lWEN5wzCGpm5peIl+GaForKcoVVMoZ57TMIlp11reOfhs57baPfuiPFffy0JMZDM
Ws5tUX1TQag/Kh0gNAZHKhxmtLpwgkjppOvWBcPdpIdPZC1slNBYoIIP3CwyC2YT
x6FKf04ZDssGAgabPSfg8I6D2Z/kwk1WzJNZWt/8ttC7538Xgx41UZVC9P/gUZkg
aunKK1CyTMcq57glc4Bw
=CysK
-----END PGP SIGNATURE-----

--=-B0Ot3cE8i32UdZgc+gvZ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
