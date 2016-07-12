From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V1 2/8] RDMA/core: Move uobject code to separate files
Date: Tue, 12 Jul 2016 22:38:07 +0300
Message-ID: <20160712193807.GA10079@leon.nu>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-3-git-send-email-matanb@mellanox.com>
 <20160712191507.GB8206@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160712191507.GB8206-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12, 2016 at 01:15:07PM -0600, Jason Gunthorpe wrote:
> On Thu, Jun 30, 2016 at 04:39:25PM +0300, Matan Barak wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > The new proposed infrastructure allows driver's to declare new object
> > types. Furthermore, uobject management code will be used from both
> > the old legacy code and the new ioctl infrastructure.
>=20
> Seems reasonable.
>=20
> > +static inline void put_pd_read(struct ib_pd *pd)
> > +{
> > +	put_uobj_read(pd->uobject);
> > +}
>=20
> Ultimately I think we should get rid of these sorts of wrappers and
> just open code it - especailly as we are talking about growing the
> number of uboject types.

Yes, we are doing it in next version.

>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXhUcfAAoJEORje4g2clinau8QALWUtEBAU1TQFA3FW/bF+pd+
gSkCkP/CupqEQnMyELI8Eck9gr/bRpntfnmlSc9R/uf+lm2gizMnYD7hqFr5uB49
eZBiiPy8mmwCKQgav/EIbCvbwtI+ZLI/tt4QmjiyUmm2mSzuUxWtI1e0w1GGGuc1
y212W2pyuTRzmz/lZlxny2cFptw/aeu4ETJT6Mx1j9uIlzHgUXC03yKatzkWUK/X
J2QxQScJ8Bi8wkGMPxCkijwyCTkthTcsJfT/yDcOl8w/mdlNszf339fOlqflpDWW
dXNRUfME0KUb6PWxDOgLNBjndDh38nJUimN04uV8iaU+l/qbvNlk/hvUZFYHUcwj
JXp6+nRvu1RH3+0un1nC/wichtox2FUDIGnY++TCMmyFKzJcr1MhSlQCtd0bwyYa
aPmbsycvWvxwNEjkMMth4JlKQPNTjktrLWcr1ufMqhoo/91+tcEe7NQ0TRiwvJOa
A5NYSHR9T53M4FsN86lLP3rXNppZs5R0HWHcFoN23XmyagjGnLdUY/YkJLBCBUs/
ox9kiXGO16qkujI0zbnFq2+3LEPGd2w5bn7pZLpXH9GB7y+j/kk2IT+LzH4xDQel
P0RSEmz0nW3fGfHQju4o69Kv7yEYIAJjM8jiPzxxBMwPN417wwNTLK6fclqRz/iq
eO/fqV8tzqOTsqOD8YhA
=Z2KN
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
