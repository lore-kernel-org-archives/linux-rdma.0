From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sun, 24 Jan 2016 09:40:28 -0500
Message-ID: <56A4E25C.20905@redhat.com>
References: <56A2727B.8040809@redhat.com>
 <CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
 <56A30910.9010002@redhat.com>
 <CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
 <56A3A777.3@redhat.com>
 <CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw@mail.gmail.com>
 <56A3FE6F.4000800@redhat.com>
 <CA+55aFz9Dnu7Ri8XA291VdSYZ5gqyt+cmaaRNULQ0hVetoAJZg@mail.gmail.com>
 <56A42829.90401@redhat.com>
 <CA+55aFy0OuZ+TOsNRkqyGbpJf1LvLAodO2DqUfpcrKsQHQWLxw@mail.gmail.com>
 <CA+55aFymjONiSk+gVRk8XaViw9BuG1A6KgGWHgq=kj+XZsEw8w@mail.gmail.com>
 <CA+55aFzh4_T6MUM7CQsBc5AVe5WhiG=SDkXpRH_eNOZKPMAZMA@mail.gmail.com>
 <CA+55aFxHrSB4cqs6Pzk3-AwJB17F2sTyunNGBjiCL0=Uijr-gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FjDfTNmeCKP7eQfKkN73luolvNkMwEWJ6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFxHrSB4cqs6Pzk3-AwJB17F2sTyunNGBjiCL0=Uijr-gg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FjDfTNmeCKP7eQfKkN73luolvNkMwEWJ6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/23/2016 10:13 PM, Linus Torvalds wrote:
> On Sat, Jan 23, 2016 at 7:05 PM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>>
>> rdma had better not be this kind of pain in the arse in the future,
>> because I really will just stop pulling if it is.
>=20
> Side note: I'd suggest you start using branches for rdma. Because I'm
> going to be very picky about my rdma pulls going forward, and if  you
> put everything in one big pile, the likelihood that it just gets
> rejected is now very very high.

Understood.  This release cycle was a bit of a flag day.  There were
early cleanups that the rest of the code depended on, hence the way it
was put together.  I tend to use branches if they can be merged easily
and don't have these sorts of early, intrusive dependencies.

> Using separate branches means that I can decide to merge the sane and
> easy stuff. The stuff that doesn't contain Mellanox shit, in other
> words. The stuff that isn't controversial.

Ok.

> At least that way you get *something* merged. Because right now I'm
> actually so fed up with this that if I hadn't already pushed it out, I
> would have decided to just undo the pull after all.

Or, can you please make sure that the right people inside Mellanox
review Linus tree for any merge issues ASAP.  Then let's have a separate
conversation about preventing this in the future?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--FjDfTNmeCKP7eQfKkN73luolvNkMwEWJ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWpOJcAAoJELgmozMOVy/d2LYQAMNvxPvJ3M7fSfSH8Q7YwQE9
6iSBs8PzsvLpRXJ2FklXOwxXP6C9LCtIMBG1+lMF3dzC4Y+Z6CnIu95DG0ED0O7w
P7UqroemY6BU6SNbJ5uS+BMoQd0nHw+VN87vCFg0YdHEwCSWd+PvXkXfekSVAQJJ
pL3K7YEWjiQf6m8Ldxw9kjoOjyXOlFBy77EQ8WoaGY2BzzLEa4DCymTe5HQo36dm
hPYIayp6GbOP9Bpn6+yOK60ecWd6EBIjkUTHt5vn9+SiwQXuo27L/5lYg56aUZvh
5M5wsNC/qMqj5VdwfLasWe3R3qIuhI9+l0xKD5sHYX8LadzX8gjXbZ5O3gjjSfj7
pN6zF/ohxih9zkKDikdKRxm3XH1lZi1mMeC/VN/aeckw5Lm5OULTnb29h8lwOS/E
DgVjps+YtpCXJ7ub30jXZxhUGN5HCCl1JNlBb1HlKpaaUwfSWb6NRaRuLRC1HSjX
aA5YEoFIOrWT6/y3cSVjmDx/k0LH65p4QTo8PaOerhqmwj9ZHGueD+ta6HMsGDlp
DWrJhcNPJgUdtMdhLj8Oc+X+zkJKGR0gLg7mGxjv3j7HN8bMecybv4s8HBtDXiaC
r6+XZmHu5c5YTnZ77qkmmCaxBhWJh1VgYQYmIwCpZ1HPvAU6RnYp2SfvFtneSt/7
c0UYPLfoTJOJacQ6bqdw
=2Q3j
-----END PGP SIGNATURE-----

--FjDfTNmeCKP7eQfKkN73luolvNkMwEWJ6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
