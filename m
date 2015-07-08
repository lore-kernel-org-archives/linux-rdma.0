From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] update ocrdma to dual license
Date: Wed, 08 Jul 2015 15:53:13 -0400
Message-ID: <559D7FA9.1040200@redhat.com>
References: <1434127505-17739-1-git-send-email-devesh.sharma@avagotech.com> <20150630060631.GA21105@infradead.org> <CANjDDBh3pxLFe2o08KzAtw8dtVq94GK04x4YZ0nXA+YnVh5Bng@mail.gmail.com> <20150701072120.GB31381@infradead.org> <CANjDDBinTi43KTt14C7cJ0Uo=Do8Vt3G6bXutLbsViUFUG=jRg@mail.gmail.com> <2807E5FD2F6FDA4886F6618EAC48510E110A880D@CRSMSX101.amr.corp.intel.com> <20150703155234.GA6099@infradead.org> <CANjDDBh1C8Hh_MN9P1=N-g9tvwa-GF0h387_SHiE12cNVKfH2Q@mail.gmail.com> <20150708080108.GB5668@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wiIBhxlfDML0lhCjduJw9cEESoKJoe5ju"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150708080108.GB5668-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wiIBhxlfDML0lhCjduJw9cEESoKJoe5ju
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/08/2015 04:01 AM, Christoph Hellwig wrote:
> On Wed, Jul 08, 2015 at 12:26:56PM +0530, Devesh Sharma wrote:
>> We (Emulex/Avago) were lobbied by the Open-Fabrics Alliance (OFA) to
>> change the licensing from just GPLv2 to a dual GPLv2/BSD license.
>> They would prefer the elements in the OFED stack all be dual licensed.=

>> We're trying  to move to this position.
>=20
> And many kernel people would prefer to not have this.  Can you try to
> identify the persons who are doing this harmful lobbying on behalf of
> them?

If I recall correctly, it's in the OFA bylaws that everyone who is part
of the OFA agrees to publish their code under both GPL and BSD licenses.
 The OFA stack is used on more than just linux (there is a WinOFED for
example, although there is an entirely different kernel driver for all
of the hardware on Windows so this kernel code is not used there) and on
more than just client computers (think embedded OS on switches, but they
use the entire linux kernel, not just the drivers here, and so must
abide by the GPL).  In practice, I'm pretty sure the dual license of the
kernel code is more or less meaningless.  They need to comply with the
OFA bylaws, but because of the way GPL requirements play out and the
fact that this code only works as part of the linux kernel, it's only
ever in use in GPL situations.  It's really the user space code where
people wanted the BSD option.  I presume that makes distribution of
things like a binary WinOFED easier.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--wiIBhxlfDML0lhCjduJw9cEESoKJoe5ju
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnX+pAAoJELgmozMOVy/dfRwP/0T/SCPauyF/UsEoxRrPAPhP
xKD0/cAsCm9uWQqQe2K409CFK+R+oGe81i7djXjixUeE3qL+/kHSto1psIg4QtjK
rgOn4z3RImbrOgp6+J1paPrHfLrNtcHhn5i0nH7CA6l4fin+doQObm3X7Vki9aV6
heJ2xMj2FPUfmnHN/saGwQy0oyP6k47IuVSnC5gfEQvF41Kb4lHMZP+tyyWlsa7K
hdMCbjNjbciIYKMjLF5wTAFl5v/Z668xt6k0zM839ARQwBb9wAl35KiEQfe5o4Nd
R0JRslhzS3RlwoQpmSf1SdaSWCTo6WDwfOVCjkGwvJtcUJgJvLF4EUDCRb5p8H1G
pS4lOs8Mvgqn5LaJA38cY/EBDoiX9wPWGsF2EMVB1H3wcJtO8iTZQzgi6yyEZGn3
OjOX9mJBcJcCNHXQWImz/6aCyeUDKbKTdNTPW0dZ09ZrM76VhfvIWkeUeRkInXme
ZjPlEP7tiuOCf6JdV1gX97nzCrE3plAxcCYAkzNtAIoMaoasHAjdOGFXwPVGlGjT
04+wN7gW2igeLw4C7q0UGy+jCHP6kqaFtnLGeWG73DvtrO9fMDGNTRWitf44Ey0y
2WegWpkNavqr0zPrrPmJHY9TVqI+ZhRBkq9UV0okZoqvybhAgZcTOTk9E9STACv4
GAyAfIOmKJF5EDReSb+Q
=0LWp
-----END PGP SIGNATURE-----

--wiIBhxlfDML0lhCjduJw9cEESoKJoe5ju--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
