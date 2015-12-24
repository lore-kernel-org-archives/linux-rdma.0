From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 1/3] IB/core: Align coding style of ib_device_cap_flags
 structure
Date: Wed, 23 Dec 2015 22:31:20 -0500
Message-ID: <567B6708.1080307@redhat.com>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
 <1450606571-15877-2-git-send-email-leon@leon.nu>
 <20151221062252.GE3860@phlsvsds.ph.intel.com>
 <CALq1K=J2e=aw1QuJHGhFFcKkY391myz11r7tG-H+fYbQEyr+Gw@mail.gmail.com>
 <20151221080346.GA21779@infradead.org>
 <20151221163603.GF3860@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="V2Q0rbUUcKMPLk6Bvjdg2lKcHVhBwc03r"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151221163603.GF3860-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--V2Q0rbUUcKMPLk6Bvjdg2lKcHVhBwc03r
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/21/2015 11:36 AM, ira.weiny wrote:
> On Mon, Dec 21, 2015 at 12:03:46AM -0800, Christoph Hellwig wrote:
>> On Mon, Dec 21, 2015 at 08:37:26AM +0200, Leon Romanovsky wrote:
>>> You are right and it is a preferred way for me too, however the
>>> downside of such change will be one of two:
>>> 1. Change this structure only =3D> we will have style mix of BITs and=

>>> shifts in the same file. IMHO it looks awful.
>>> 2. Change the whole file =3D> the work with "git blame" will be less
>>> straightforward.
>>
>> Honestly, the BIT macros are horribly, and anyone who thinks it's usef=
ul
>> really should read a book on computer architectured and one on C.
>=20
> It would be nice if we were not having to do this for staging then.  Al=
so
> perhaps it should be removed from checkpatch --strict?
>
> I'm not a big fan of everything checkpatch does, this being one of them=
, but
> Leon was trying to do the right thing here.
>=20
> Where are the guidelines for when one can ignore checkpatch and when th=
ey can
> not?  It would be nice to know when we can "be developers" vs "being ro=
bots to
> some tool".
>=20
> I await Dougs guidance.

Checkpatch?  What is this thing you speak of?  ;-)

I use it, but not even all the time, and certainly not religiously.  And
I've never used strict mode.  Even in non-strict mode it flags stuff
that I ignore.

As for the BIT macros, I haven't looked at their implementation.  If
Christoph thinks they are crap, then absent my own opinion on the issue,
which I'm not inclined to go form at 10:30pm on Dec. 23rd, I'll trust
his judgment ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--V2Q0rbUUcKMPLk6Bvjdg2lKcHVhBwc03r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWe2cIAAoJELgmozMOVy/dCBcP/2X+0+yM3RIF5nbNw6WhxNXm
62+8EsStHHmTjJo8dYUfo4Py4GfSOTp4JBMKtGef3LYAT++BPjO5sw6Cnx7CsJps
J940/fBpcImTI9MeHNPATUSO5ngpkOHfk2xnjAvdzQkEHGYqykhTBp2KU+RxWyDt
sSPBsJIt6FsPmWOtD7GiT0UlH71Uvrq99NsU1S6SHmLoDpVvJG5ETrHxpGXueFkC
tK0C4c2JZtHuugNcIUi3ga4LdLs/abkXv4QrNA4l1b7aW5lm1A1mUidKI/yatm/4
lnaTsUi7KHmQtx8hgH9wbevNqG7uMzzkjVLcICe4iQrQOr+vDQYlzfwFqvGAy2WC
+ztBaHuv6vC/IOgtTctOhzTf0LdIG92p26KaPvVycClBIbeWCdWshVYRpquAZqky
x2Od8giQp4zqW03agu0oeHF9D3cFrQi7kW83c9EtCRSqkod06ooTiERi4ZNUIX4A
Bv/nLm+oJGrJFlpfEpfVCaevIbuXxe5DHh7eQnQnQo3uTzqxNFN8cuCFvK950VRt
1Hjvd1D/zL26o1+52768+xAxmHF3fYgf92nz37NB1Gf0PwJJWjmjP9M4j7mBklNA
WEdVQwjs7LdXMRR9mJbyQCpKrx4JCQJLClikRhj6rDRIxvMAVB+iNa0XJ98SprjC
ilXwXxB7ACW5hJC4/6pS
=vOl+
-----END PGP SIGNATURE-----

--V2Q0rbUUcKMPLk6Bvjdg2lKcHVhBwc03r--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
