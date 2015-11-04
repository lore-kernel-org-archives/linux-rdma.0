From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Wed, 4 Nov 2015 12:40:27 -0500
Message-ID: <563A430B.70906@redhat.com>
References: <20151101180609.GC13943@kroah.com> <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com> <5637F97C.5090205@redhat.com>
 <20151103001845.GA24206@obsidianresearch.com> <56380535.5040101@redhat.com>
 <20151103012821.GA24650@obsidianresearch.com> <563815F7.2090003@redhat.com>
 <20151103041614.GA14023@kroah.com> <563A1D96.2050507@redhat.com>
 <20151104171620.GA8504@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VcmkQeIuKJWEVUA6Ld5mQEerLoHXm6csP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151104171620.GA8504-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VcmkQeIuKJWEVUA6Ld5mQEerLoHXm6csP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/04/2015 12:16 PM, Greg Kroah-Hartman wrote:
> On Wed, Nov 04, 2015 at 10:00:38AM -0500, Doug Ledford wrote:
>> On 11/02/2015 11:16 PM, Greg Kroah-Hartman wrote:
>>> This too was something we discussed at the kernel summit, it's
>>> recommended that you just delete the drivers from where they are now,=
 no
>>> need to move them to staging first.
>>
>> So, don't take any more patches against them then.  I'll delete them i=
n
>> a week or so when I send my pull request.  I have a few other things t=
o
>> touch up before then and I have patches that touch those drivers, so i=
n
>> order to avoid merge issues that would seem the best course at this po=
int.
>=20
> Which drivers specifically are you referring to?

All three of the drivers that are scheduled for deletion: ehca,
amso1100, ipath.

> And I'm not queueing up any new patches in my tree due to the merge
> window, so there's nothing for me to take right now :)
>=20
> thanks,
>=20
> greg k-h
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--VcmkQeIuKJWEVUA6Ld5mQEerLoHXm6csP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWOkMLAAoJELgmozMOVy/dWdAP/RQ7qFhtgEjQ7UJM8aQ89D2K
Cxhl88c28IQ50G63uJ3Ckc44q0jTS+FXl5TnACgQgAwpj4/AP4GyuamSdxEL7L8I
GtCCwKZDooam1AcJkhXZe2jEDpN+5gQ+e7lmKHwltzdVh+MVKgCTGjuZXAUsIkIX
88QcN+mz4Ja8UeOt3cmDnHMbWwsWfbsNoIdzWZ44ViI3vbBaHfFZs2N71EuDDPzM
T19pdysJKSqjf2OB/fvv1HJPgsYh1l7z84SQkbR2wqFbObCGyOvqoxQIbtv0OHqo
oA80sjrKuwO+SI0cgPZJQ+hLdJr2KVSd54f8L/SVTe6SmVDqbB7m4OHL4J/DX2BZ
q7pslFVcUfJ2bZPOLZ5S7b+HqTr9CdcDvVx1/6zP9DVO30PFqkpfqi61062Tc5Am
gJjHxnFGY22jpkrjwaIFlF37TwBbUnMxIO0M31RR0OS6VYmU7/s0EoQUoCzw8IR6
tJVbzVGth9w6f5TOnLtuyhEhji6Pd0gGGWLlAfaOPF43PmA8U4jXORWqqUc/BSYX
V6IvzFMY6gXxxTxskUpxdcMejmikb+b7eN70gJNXxm1vd2LKttqhMh2aCDab7NyO
E8JtM80VHyajxQ/Ted59bIK06FZ5+gJ8MEz0maLJe7PMdgdm2ukuHARUbzyu0Vq3
lKwWfGVxONRQzqmkBVwz
=Ok46
-----END PGP SIGNATURE-----

--VcmkQeIuKJWEVUA6Ld5mQEerLoHXm6csP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
