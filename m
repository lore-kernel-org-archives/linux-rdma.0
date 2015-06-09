From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Change To max_cm_mtu when changing mode to
 connected
Date: Tue, 09 Jun 2015 09:38:55 -0400
Message-ID: <1433857135.90034.13.camel@redhat.com>
References: <1433673371-5355-1-git-send-email-erezsh@mellanox.com>
	 <20150608164224.GA2499@obsidianresearch.com>
	 <1433797482.90034.2.camel@redhat.com>
	 <CAAk-MO_=-C2JqoTsHFoVZZSHP5YU2g7AMwkQc6Vup3Ubf5Pv=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-MCfQb6fOegXSm7zPuT0O"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO_=-C2JqoTsHFoVZZSHP5YU2g7AMwkQc6Vup3Ubf5Pv=A@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ELi Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-MCfQb6fOegXSm7zPuT0O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-06-09 at 09:06 +0300, Erez Shitrit wrote:
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
>=20
> The only real reason for a user to switch to CM mode is for the
> performance he can get, and this is only by the huge MTU the CM gives,
> so it somehow should be part of the "mode setting".
> As you said RH does it (in the new versions of its OS's only)

No, we do it in all versions of our OS, but you have to set the MTU
parameter, we don't default it to anything for you (but this is no
different than setting CM).  This is normal device setup.  Just like we
don't default Ethernet interfaces to jumbo frames, the user needs to set
the MTU on that interface.  And the user gets benefit at MTUs less than
jumbo size.

>  via
> scripting outside of the driver code, other vendor doesn't.
>=20
> > connected mode MTU to max by default once we get the scatter/gather
> > support for IPoIB added.
>=20
> OK, great. Thanks.
>=20
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >               GPG KeyID: 0E572FDD
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-MCfQb6fOegXSm7zPuT0O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVduxvAAoJELgmozMOVy/d5pQQAIwMJh0U4p5ZsPdeWZpyKMEA
wDZVMqz9oDaV7PfZMBBlKgSvJz4JLcdS98/KOtTC5Q2EIhXJnELfAQF+Jf1WnQnb
sKhVHRAijduIHGOXbk8ALMREjhhYrIOMZprhV03pBxlsYPxau3TXXA6Eolj5K5pp
80xhi/E8VJVIuwu6yAyNRsGq/VISoZ8I6MJ2CNbeeVsatY1pB2T4ZNa/s1UaEyTX
hbNQbm+fX7KsDGB/txLKElgS8Ku855jV4rxykHKmv0/cE+GicUIgLfehi4KVrb5G
Bvia25CsbHvbi5F3XlZRsVW3MMOBzhumnULdNDOuxLUnGwPXgWDZyYq6lJfykV9d
v5JnyCh+CC3U7MfK/pZUPjiZ1lqp1gc13qAEsoGrbIyZMiLtPbCnuGc1IrByiDfx
Z0/N41oQxwvTUDClghMPySWKk1Ygrpk1fo19s98OZVtNSZESIyMPp7LQunOeO6/I
X7DzjOBRwjydeXYAGQOp3WXn4QUzurfqPNnqS+IUKZPFqz0IwLqltLp8YVPnxele
FGATCfBHtnAkjIymcDNCa6Gr+RywwrCgvN00dtN+hT0S7J8Q10/B3nteEhRueynL
CkRYIK7FQ7n2C+zO1hJfEdWqpe8NwQ09viUiVK798YfzsEcFzbbidBGopAxqsQZD
kEi/CXYNLdje0bmrkgeo
=CcCy
-----END PGP SIGNATURE-----

--=-MCfQb6fOegXSm7zPuT0O--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
