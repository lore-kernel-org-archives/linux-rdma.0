From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Wed, 4 Nov 2015 10:00:38 -0500
Message-ID: <563A1D96.2050507@redhat.com>
References: <20151029115114.GA18466@lst.de> <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com> <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com> <5637F97C.5090205@redhat.com>
 <20151103001845.GA24206@obsidianresearch.com> <56380535.5040101@redhat.com>
 <20151103012821.GA24650@obsidianresearch.com> <563815F7.2090003@redhat.com>
 <20151103041614.GA14023@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CfuA1UgF4NEHr6wc39N4uVlaH2dJ95rUb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151103041614.GA14023-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CfuA1UgF4NEHr6wc39N4uVlaH2dJ95rUb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/02/2015 11:16 PM, Greg Kroah-Hartman wrote:
> This too was something we discussed at the kernel summit, it's
> recommended that you just delete the drivers from where they are now, n=
o
> need to move them to staging first.

So, don't take any more patches against them then.  I'll delete them in
a week or so when I send my pull request.  I have a few other things to
touch up before then and I have patches that touch those drivers, so in
order to avoid merge issues that would seem the best course at this point=
=2E


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--CfuA1UgF4NEHr6wc39N4uVlaH2dJ95rUb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWOh2WAAoJELgmozMOVy/dDjYQAMSWaGi0R6Qrmtadol7IVOyF
psVP8f5tNk8LYc5/rtNpKjXv4ZG+tLndFcInnCaQzSZzlC3Ph1uyvFhlHr8DvGE7
MvTj3GDIBqd1VWOARLwzDfJg0QZsYzAqd5iJDPoWGR8FAPKoJou/A0KHY+K7XLCl
Bn2omBE5A5sEc1Zz02FPebAKZruQ8ElccXb2d2ZjMX2vIHFG87K4XIZngv75MZjB
39k4wiwXaf+oSRbmnqEAzaeZ0B0oGZeGtNAyPOYfIJo5IIBXTebAjVxCE5rk0mtR
ixMB+MWqVldpvwkJm54Yz0bGjW9V0DWZfJVNVe7a1Q18foTLbQWAmMrlET67kNoT
Kk7IfRQStAsmpPoyhZOvuNdOebyrauCQ8XVMmbZwshLL9Am19ZpKi/SiAMUj7vv1
Id11Ki9AFNT796ApgPGeoluBa4uN8vK/lQ0NOuH12bTbCByQB9UEFmjt9goQlSa6
m+e08fUoM2qs0fD5wynJvugFLQSdVyHdziECCdR1gNSx9tBYytqHlE7rcJrEdlOZ
rUXayj6OTjYzDDdC3k+8Khk03Wz40OvAcbUGIIW3hkOETRK7NQSnBXzqlwcOUD1g
xE7N/Ml9Nam/HD8b7AtWld+iyeuqtkgxzyvxW4pnlxOiTW2XjHBI3oLhDviWwkQ+
NbGmVCCxUzKkGsNaWFmV
=RbwW
-----END PGP SIGNATURE-----

--CfuA1UgF4NEHr6wc39N4uVlaH2dJ95rUb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
