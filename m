From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Change To max_cm_mtu when changing mode to
 connected
Date: Tue, 09 Jun 2015 09:36:12 -0400
Message-ID: <1433856972.90034.10.camel@redhat.com>
References: <1433673371-5355-1-git-send-email-erezsh@mellanox.com>
	 <20150608164224.GA2499@obsidianresearch.com>
	 <1433797482.90034.2.camel@redhat.com>
	 <CAAk-MO-Bc8tL0Gnv2+WK6ScwrPEz_d5C5B98wNp48upH1TpaaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-UMxZLrwYy830GfXuGxih"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO-Bc8tL0Gnv2+WK6ScwrPEz_d5C5B98wNp48upH1TpaaQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ELi Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-UMxZLrwYy830GfXuGxih
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-06-09 at 14:17 +0300, Erez Shitrit wrote:
> On Tue, Jun 9, 2015 at 12:04 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > On Mon, 2015-06-08 at 10:42 -0600, Jason Gunthorpe wrote:
> >> On Sun, Jun 07, 2015 at 01:36:11PM +0300, Erez Shitrit wrote:
> >> >
> >> > When switching between modes (datagram / connected) change the MTU
> >> > accordingly.
> >> > datagram mode up to 4K, connected mode up to (64K - 0x10).
> >>
> >> Is this a bug fix (describe the user visible impact)? Should it go to
> >> -stable? Add a Fixes: line?
> >
> > I'm not sure I would call it a bug.  Setting the MTU to max
> > automatically is a policy decision more than anything else.  Currently,
> > you have to enable connected mode, then set the MTU.  Both initscripts
> > and NetworkManager do this for you on Red Hat, so the user sees no
> > difference here.  I can't speak to other OSes.  I'm OK with setting
> > connected mode MTU to max by default once we get the scatter/gather
> > support for IPoIB added.
>=20
> Hi Doug,
> There is no connection to the scatter/gather patch in that fix.

Yes, I'm well aware of that.  However, 64k MTU in connected mode does
order 5 page allocations.  That has been the source of a number of bugs
in our bug tracking system in the past.  I wouldn't make it default to
turning on 64k MTU without user intervention for that reason.  Once the
SG patch for IPoIB is included, that problem goes away and I'm OK making
IPoIB turn on the large MTU by default.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-UMxZLrwYy830GfXuGxih
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVduvMAAoJELgmozMOVy/d+30P/ii5HUPmtnyzjAaqUim27BtD
XgYQEXSPYesFQ1AVMMIp3HUtP05o9J2kYOHF/uKspbKlZyx48e5pVqkZkCppm7vD
RBXZqTkRgR+9At3ox4/HSMqfqQLzpnx0Rq8ItCXbYPYG+0ovRK/cDNHQdQWWIOgm
ciXcq8MhxUuTcVi3YOpHfL0pTzEC1roNJgXDmwMxUiadsjRNlixSuJYum4dHmZaC
0SEly+ZIsmo1rBFOC8woTHhtjAUByvvIyvn4sOIcc93tLZMxQSUxQxwCQ4b7577O
ol0bTEN0ftLuhmLzXpDgBDSII9fKUuQ97YmkhqAB4OyU7zdb8Q8yUbmMK0tkUVRq
MsZXgPvS82WHHvarKAb5UHC6NNCE/POJoiD1+4NArezdiZRCRRYK8WzxlVneyF5V
z3Fnap71qeHDuNmoQzOzu61THIPpxLP9bpEBF7Si4Ke9vqDtn8QGyrs52IvldA0a
G3NmckELY7kLskZsRZ76VxJr70TBkThRZ0jWoPRf7l2KWGbFtr9feOfUomziWgsp
EQOD4wfO4kdLCc4DtA/s46sZdNVrPROm+4x/y9t/kkUmzhPc1cif131xtMXk9OvU
145KN/laQRBDfzNrbdYve6XUg0wBWHGuYt41hN7xqMpxUer+qd7MG3sG+35z+fTc
//y1gs4/ivRZ1Z5z8/kw
=cgDC
-----END PGP SIGNATURE-----

--=-UMxZLrwYy830GfXuGxih--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
