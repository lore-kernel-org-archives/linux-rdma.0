From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Mon, 01 Jun 2015 13:00:57 -0400
Message-ID: <1433178057.114391.208.camel@redhat.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	 <1433098827.114391.179.camel@redhat.com>
	 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
	 <1433157904.114391.188.camel@redhat.com>
	 <20150601164322.GA14391@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ttGeZwMuxA8mrzUtWHhk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150601164322.GA14391-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-ttGeZwMuxA8mrzUtWHhk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-06-01 at 10:43 -0600, Jason Gunthorpe wrote:
> On Mon, Jun 01, 2015 at 07:25:04AM -0400, Doug Ledford wrote:
>=20
> > attempted abstraction of ibverbs.  Passing in the wc struct allows the
> > driver to internally allocate a wc struct with extra private elements
> > and pass that back to the user, when the user passes it back to
> > ibv_get_timestamp the elements are there in the private portion of the
> > struct.
>=20
> wc structures are allocated by the caller, there is no option for the
> driver to create private elements.

You're right, the data would have to be housed somewhere in the driver
private completion structs (for example, in the CQE the card posts to
memory that the driver then massages into a WC).

> AFAIK, Christoph's use case is essentially the only meaningful use
> case for this feature, generalizing too much may destroy the
> performance that is valuable here.

I'm not convinced of that.  Steve has already spoke up about the
timestamps available in cxgb4.  Those are very different and yet still
highly valuable to someone investigating performance of their RDMA
application.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-ttGeZwMuxA8mrzUtWHhk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVbI/JAAoJELgmozMOVy/dX74P/2P1uhZwSm9ixc21u26oNBdw
XF2e9xFAgiyveHoKsiHW/p+33h3WF/0BCCSpVTRQdXbWgtqRpsdPH1XgOr1i4yjy
/YLl+fLkvCTJEF7fpRz9uE3oVqwAq/mHC/GDNGvbHi3hXJ7WYzD06mDQRZPIJOW3
9GZEgsJj3jkSvMjV6XZlVbXPJhlcKqxv1woR14JjOOfk7bRTs64XYzICYHWfsNwW
brOpSw2pBWagxo9JWqc188cAumaQZ/p0MzYBngjrDkDRT9UDaMHCC7VL+auFrkbB
3N6pL6bPacPDsXv8o3hIn7WliR6676/bzfC+jhqFlsS9O1K7wkNJGb2uu8giYxEn
YJ7UPfjj3WTI75xyLye5nSfNj+4nALj6zqzuIo1n6VCLFQbUF+262+0TujcL6oRk
01DR0Z0V+ryYJ1/+BHWt2lKyhsscsU0e/QB1fa62v4kD3ECHDZ0Ltu0T3NsLhAMH
YsH+4SdA7uxM9YoQqyh1KGEW5zHkJAHnXD6fT2o+rhTgZO8hmZTWdWAWxj1ms5sF
KA4zTjUx6ss97dKBdGj/KASL/YcpM22R4RsgXjlxJs0vPlvJw3zsnsf3pXKM0TWz
mZuzud6W547KUx9vgPGbc6DcfYcg5CKokJnytpQbjidngqvndp3kQYxtSDi5nwNJ
orkOWiquLdIZVUNwTIl3
=mLPB
-----END PGP SIGNATURE-----

--=-ttGeZwMuxA8mrzUtWHhk--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
