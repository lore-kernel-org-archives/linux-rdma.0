From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V2 2/8] RDMA/core: Refactor IDR to be per-device
Date: Wed, 20 Jul 2016 06:20:37 +0300
Message-ID: <20160720032037.GR20674@leon.nu>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-3-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1607192014010.5828@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VmyrZ50r30oK77nV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1607192014010.5828-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--VmyrZ50r30oK77nV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 19, 2016 at 08:15:41PM -0500, Christoph Lameter wrote:
> On Tue, 19 Jul 2016, Matan Barak wrote:
>=20
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 432bed5..14bfe3b 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -1706,6 +1706,10 @@ struct ib_device {
> >
> >  	struct iw_cm_verbs	     *iwcm;
> >
> > +	struct idr		idr;
> > +	/* Global lock in use to safely release device IDR */
> > +	spinlock_t		idr_lock;
>=20
> Global? In what sense? This is a lock for the idrs for the particular
> device right? The comment is a bit confusing. Maybe better remove it?

I'll fix it and will remove "global" word from the comment.
It should be /* Lock in use to safety release device IDR */. I prefer to
add comment to spinlock to pass checkpatch without errors/warnings about
missing comment for the spinlock.

Thanks.

>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--VmyrZ50r30oK77nV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXju4FAAoJEORje4g2clin+J8QAJOOIbyDOkw9TGmZbz3oAg/g
HXbKuZNLoP0mMc1aEapHzIRa+tHxLz5gOmT/IWk6S8SbDZF0rq2oCKhZLu0dikGi
P6Z9A4mlVp4n0v4A0BMCLbB5ExGsIHFwdEXuYjThD3PuatOZw7PanbS29OBmxLzs
vcNyZKrm1EGnqh8oivBpOVrC6kZ09ULrkmqD4aJVOjppyx6vneZ6wzs4xqH+L6XR
Al4k516LcQzYWmlXQDwmZXB8mN6eB/QW4lxYXw2gT+WjzqMatDM4jARA3JV3CGFw
N42o3xkoMz7/v3oQvaxheS/1G1IUcpxPz3bshhOdIVhhuZZVEEWz7WLIZZW7nvwJ
wNg9NGp7dmdl1LUX43tIASqXMyJdF94WYioiS20txJWUbZ9DXNBYXPkAndwDwTBn
FMnamSxIt+owzKpuj+Z0hc1obbLU1bYUG0tBMXJeH2Nq0a6hJbb7tYQK1JY5D8Gg
Yy4k0W0htJ72CKhQqdhvG+gw8CPA2EUO367qrfzUC9DZVUKiuWjuDXNjitin24F/
sP3Rmz++UE90flLR+v+Xwz+bD0YjIYz0bQAFhmOd+O7JZXvDUXKWpgyvBMQ98iii
dznLjyE1yZ4XHfhOnNCVPfALJncxr6D6LmmdFsOu8xtBfXKibGWnaeDyQqLEU+tD
eA0XulhwWS0loUObRH/c
=rpMy
-----END PGP SIGNATURE-----

--VmyrZ50r30oK77nV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
