From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Change To max_cm_mtu when changing mode to
 connected
Date: Mon, 08 Jun 2015 17:27:45 -0400
Message-ID: <1433798865.90034.5.camel@redhat.com>
References: <1433673371-5355-1-git-send-email-erezsh@mellanox.com>
	 <20150608164224.GA2499@obsidianresearch.com>
	 <1433797482.90034.2.camel@redhat.com>
	 <20150608210751.GA13388@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-0QOxsIgxeTYWN3mGZFwF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150608210751.GA13388-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ELi Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-0QOxsIgxeTYWN3mGZFwF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-06-08 at 15:07 -0600, Jason Gunthorpe wrote:
> On Mon, Jun 08, 2015 at 05:04:42PM -0400, Doug Ledford wrote:
> > On Mon, 2015-06-08 at 10:42 -0600, Jason Gunthorpe wrote:
> > > On Sun, Jun 07, 2015 at 01:36:11PM +0300, Erez Shitrit wrote:
> > > >=20
> > > > When switching between modes (datagram / connected) change the MTU
> > > > accordingly.
> > > > datagram mode up to 4K, connected mode up to (64K - 0x10).
> > >=20
> > > Is this a bug fix (describe the user visible impact)? Should it go to
> > > -stable? Add a Fixes: line?
> >=20
> > I'm not sure I would call it a bug.  Setting the MTU to max
> > automatically is a policy decision more than anything else.  Currently,
> > you have to enable connected mode, then set the MTU.  Both initscripts
> > and NetworkManager do this for you on Red Hat, so the user sees no
> > difference here.  I can't speak to other OSes.  I'm OK with setting
> > connected mode MTU to max by default once we get the scatter/gather
> > support for IPoIB added.
>=20
> I was thinking about the other direction, what happens when you turn
> connected mode off?

It drops back down to IB MTU - 4.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-0QOxsIgxeTYWN3mGZFwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVdgjRAAoJELgmozMOVy/dN/gP/Ayng5CYE/Ch2YuxPpr9zYzt
ffUxeiTgitwPnKrkNtH8rMRCMl/satd94ZsnOVcKNJ50n9uJp+/5Bm/qZLFUBOMK
X/OrDeTaAjJnJ4nKtEGGgbQUxbT10n8HJdCB8SVwx6c8xrz9eiThXE37VwUctQUG
vA/WSLZ04BPzFsiJKg+sMCeivUNUZrFP8RoVSjof7lrCRLq03DU+eZyDh+O0iC82
oOCd3VZWIUJjdZcyjc68ZXnsPOvJzygdWSsBrn9n20LP2iiE6QcNjanbmazCNaOh
7SJCg9Hpf8RaqkDV0eodlkaZY7ZJzr42uwnwGoIyUw8gxa+fqY7tR4HeWRDGmYL9
D+AEw6VcpUp4L3HvuidCrV1MNh98LwvtYCcljj5huMhmifKkGH3n4egz/riijS/C
Ewrt/ZsdqiZofSnhLTayqfakGiLEQBFP9LwdpFAAWY5tx+992xlDhGQLqu9o9inE
PDzXW5otxeT+OIO4l4sf2NeMF9E793mKPFif8r7CsxXGo0oN8GGsOO0TARtZqCCZ
ocIf7TKCTH4J7ePviSLkNb3Vox4MCQoqo7M1iQxq3hJNnvFqkgeT6jrhXlQ8mZO3
2zgChAI/AadmRh6tj5AmgzttiTRRdef6aU/tm2G5OokfUXVRT+ASeM3KdLhG2ZaC
j9zVZvAEnC/nWjth6HRk
=BtLE
-----END PGP SIGNATURE-----

--=-0QOxsIgxeTYWN3mGZFwF--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
