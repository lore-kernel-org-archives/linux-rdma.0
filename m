From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/11] IB/srp: Fix a NULL pointer dereference
Date: Wed, 27 Apr 2016 09:20:53 +0300
Message-ID: <20160427062053.GK7974@leon.nu>
References: <571A936F.7040409@sandisk.com>
 <571A9472.5050202@sandisk.com>
 <571FD7F4.4090006@grimberg.me>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OX2aLCKeO1apYW07"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571FD7F4.4090006-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--OX2aLCKeO1apYW07
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 27, 2016 at 12:04:52AM +0300, Sagi Grimberg wrote:
> >Avoid that running xfstests on top of the SRP initiator triggers
> >the call trace below. This patch has been tested by running the
> >following shell command on an initiator system that has access
> >to 3200 SRP LUNs:
>=20
> That's good to know, but the patch description needs to state where
> the NULL deref originates i.e. when can req be NULL and why it is
> OK to just assign to NULL and continue...
>=20
> >  		scmnd =3D scsi_host_find_tag(target->scsi_host, rsp->tag);
> >  		if (scmnd) {
> >  			req =3D (void *)scmnd->host_scribble;
> >-			scmnd =3D srp_claim_req(ch, req, NULL, scmnd);
> >+			scmnd =3D req ? srp_claim_req(ch, req, NULL, scmnd) :
> >+				NULL;
> >  		}
> >  		if (!scmnd) {
> >  			shost_printk(KERN_ERR, target->scsi_host,
> >

And if it is OK to assign NULL to scmd, will the error print above still
valid?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--OX2aLCKeO1apYW07
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIFpFAAoJEORje4g2clinXaMP/iAzAF+qua01OTDu3Xv+ExVz
3qM+yFooNehdZXlloQXA6RyWyWiwE7WsMZiJIZpcz2ft+Zh3xx3N5udHq+0sIkRp
Q6R3G1D++upKRIWZDk3a/XGtN5JsgQrVNwcojGVE9i7066xNat5fCe4EXUYcCTZV
49CBkWhFDNoUSAYYhOM59v7tU9oVmaMezfz+xDkfCdhQf5qtj/9dKtSrTi9LFZIW
xNGqjY6xnO7lkAuBrVrdYJLyS1QY+v/BpEkCfgBhu0OpePhtUHdbLwLDJhvCbpcb
kr+if8lHCM+mKv+soNCS2YSk32SPWFynMpq0A9u+WdzvAQYa0gdCt62ZeFxH5PD/
HdNLVBa3/JfMENObk8veyHm6dzY/ziH56Gw5yzsro36/UOcnymBrGcHa1enyBUVp
2NhX1cqX1FZi0XzpMe/GzZpug9MZaAp4yY8QJO56iT00I6Ey2c7iDc9cicpj2HFD
W5QcHNQ1urkt45M6TkCGDBzin5xKb/cXLc2/MWvjDOdn0UKtfefTZNaFxoS9JMIA
xQkI34P+foFJCNXCOw21oQbLHJZQ5Xs6DDE9VcaCF71EUb4faQjCkWut9Ifo5lU7
B4ElmAdd2VxR4ka/iLbS9vMMzwctaECzQjZxajkctjlYBIksOlFTTQOhOwnS6yP/
BljjEzUnNftJiQxNYD1o
=4KNW
-----END PGP SIGNATURE-----

--OX2aLCKeO1apYW07--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
