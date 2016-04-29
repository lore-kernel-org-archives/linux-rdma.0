From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/12] IB/srpt: convert to the generic RDMA READ/WRITE API
Date: Fri, 29 Apr 2016 10:44:51 -0400
Message-ID: <4836d671-0cfa-6e4c-d129-c539e381ee6c@redhat.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-11-git-send-email-hch@lst.de>
 <570E96B5.5030002@sandisk.com> <20160414133255.GA22523@lst.de>
 <57227A6D.4000802@redhat.com> <20160429063443.GA18893@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6Mppi8BxhlKs430ETm9tCCiHlq6tnLJs2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160429063443.GA18893-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6Mppi8BxhlKs430ETm9tCCiHlq6tnLJs2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/29/2016 02:34 AM, Christoph Hellwig wrote:
> On Thu, Apr 28, 2016 at 05:02:37PM -0400, Doug Ledford wrote:
>> I see you responded to Bart's comment above, but in the same email he
>> had a second comment on this patch (that the logic was incorrect in pa=
rt
>> of it), and I've not seen a response to that.  Here's the comment I'm
>> referring to:
>=20
> That one has also been addressed in the latest repost.  Bart has report=
ed
> another issue with the current version, which I plan to look into by
> the weekend or early next week.
>=20

OK, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--6Mppi8BxhlKs430ETm9tCCiHlq6tnLJs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXI3NpAAoJELgmozMOVy/dOGIQALpOU1ccFKxCeh1qFtv5hfAx
gqdnOw0K/jeZ4U2rCDppnvasy6L7MY5VtUHRWY79i7DBIFX8Fx3gSSJ2xKo4RdGJ
7hqMxFHKv5HwJqFPmOR8H8jweHCEk8321z93BPH5tH6W/c05vcFC2uM7ZBo22v5/
LIiZEWO9FuylKQxnBs7bSf2OF2Xrd/OBn8A6YhCYM6i/dbmo9CiOw7qWlyoMabqD
/F14PnBJRsvUVysnjksix8gJhTtWi8WVp8IbqyfoXTSQ4eZZoUyneJ/FVVRIJ/l3
EoA0DsTzOTwp8/bCeEpqa8xW1IJnBwqUEQeNQvPoN3ljiwEMdGA7Aw/6rFZfs8E9
ASEkXHUAbBVmglP9ZP0QlP/roITxlNir+lCLm5E5jjiDfsFEfTh2KlA+kBjbO/u4
HNGjSW8j/pmqJrb8U02+9xQ+T79hhvtvM78mrsnC1RSXkZdMEfOWxr19mu5VKSKA
U8j3Xz0F8fCDpexYANTIG6yP0YYdJP6oHl6Pp9iCYpcRQ9RX9+1xbSzy3GkQgSv5
S2GJRNSa/hDhqVCtzkZsmqAdLg+Ep5YI4QQoVx3NGLFKkBKoiC4n/hXsLtpAmtGv
jkJyv987ujfXe/zCgp0s+/0NWXtqAzohSaOy8JDkXU1uydJ6wS6bZT7cjTIdXN2M
BL7HtJG9y+iW4grSh2hB
=evoS
-----END PGP SIGNATURE-----

--6Mppi8BxhlKs430ETm9tCCiHlq6tnLJs2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
