From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Thu, 19 May 2016 15:24:16 -0400
Message-ID: <2b0ccdf6-7687-8897-b605-5e3262e05bfd@redhat.com>
References: <alpine.DEB.2.20.1605160851370.23895@east.gentwo.org>
 <041c6da0-e022-2bd1-5f00-e569c077e154@redhat.com>
 <alpine.DEB.2.20.1605161203010.26453@east.gentwo.org>
 <db1bf3dd-20b1-3f2f-eaa3-25e5e8aff35b@redhat.com>
 <alpine.DEB.2.20.1605161238560.10085@east.gentwo.org>
 <102cd100-55f7-fa85-cd75-ba0db5b9fa34@redhat.com>
 <alpine.DEB.2.20.1605170918080.9956@east.gentwo.org>
 <3e9a3e19-58cb-c25f-89a1-f0e51df562d8@redhat.com>
 <20160517170027.GC19976@obsidianresearch.com>
 <bc83cc75-aa2e-6fc6-e1c6-a0190b972013@redhat.com>
 <20160518172542.GA15516@obsidianresearch.com>
 <12e991bc-aa9b-a8b0-3cd4-b56d58a44d60@redhat.com>
 <alpine.DEB.2.20.1605181401030.29313@east.gentwo.org>
 <038401d1b143$b68b6950$23a23bf0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nne7mHRH2OLlPtAbQPC14GsIV1oQVOdEC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <038401d1b143$b68b6950$23a23bf0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Lameter' <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nne7mHRH2OLlPtAbQPC14GsIV1oQVOdEC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 04:27 PM, Steve Wise wrote:
>=20
>=20
>> -----Original Message-----
>> From: Christoph Lameter [mailto:cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org]
>> Sent: Wednesday, May 18, 2016 2:02 PM
>> To: Doug Ledford
>> Cc: Jason Gunthorpe; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Mark Bloch; Steve Wis=
e; Majd
>> Dibbiny; alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
>> Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure d=
ynamic
>>
>> Attached a revision of the patch that only fetches one value. Simplifi=
es
>> things too.
>>
>>
>=20
> What if you enhance cxgb3 to allow fetching one MIB at a time?  Maybe a=
dd a new
> RDMA_GET_MIB_ONE (or something similar) command that takes an offset?

I have a version that does caching compiling now.  I'm getting ready to
test it.  All in all, there were significant re-writes from Christoph's
patch.  But the caching is flexible enough that it supports the i40iw
driver's needs out of the box (namely, typical cache age on parent
devices, but make vfs have a 1 second delay between updates because of
the expense of getting the stats).  It also works out nicely in that in
the i40iw driver, I'm pretty sure you can safely just pass the core
value[] array to the get_hw_stats function and it would all work, but
for now I left it using its own struct and doing a memcpy before it
passes the struct back to the core.  Other drivers might be able to do
the same thing.

And I thought about making the get_stats function pass in the specific
stat, and then leaving it up to the driver whether or not to update the
lot of just one, depending on the cost of getting stats.  That would be
an easy change from what I have now.

Once I have a successful test on cxgb4 I'll post the updated patch.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nne7mHRH2OLlPtAbQPC14GsIV1oQVOdEC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPhLgAAoJELgmozMOVy/dzAkP/j1fgFJKfE2vPY6YVJRz7eQK
ej16Hot435MPANvuVn8kiY8s5D5IOPq8LApYGxHKb1ql91K9dluvX0eEIm62UVef
E3byZ6D9SItc9drNeFB1hS0B4pxdjYntBF1V2nCTMKIooR7RlmfvgGLB/qY44BOm
xY1JBEvp/mXcYLWVrxnN9htsVEIRuDrdJd7VBiGdnGu9nM/dvvC6aiC5aa9eKkqG
439q6w/xRU5aQn3Nqq2jb8KdpvFQzjlvuTt2ZSQxuBWyV8plb+iGNcZro/Jk7kgB
kiIEfxuLVAKgGf9WPVZCiY11GrRbm1OLQHRp78ll9gHq/HUR9X3DcP0rFEpBBZTY
6rO5Tb/zWLAJAEhGSJtc0QRPqN8D5NsLbXmjxCUj6TTRT85iITcOXg5B6+a2Ayqi
UV+FwTQOu0KfiQLL37PuKhd0qHSMgB/sJzqM4+wAfuK7ZkGOcdVONhMetYRdwbTd
+WeBcd5S/rv8Yz8cm+yopJ3uCB7ZWEiDGIrZtpZbbzAaMlXnr0INew6eRRWG/oEA
SFG7zV/g3SDgXGUpGmbka6sO1/L9k+KQcd4rif6yYliRgux3kNA/5mYfKzrnKcnm
+IKyQjRCIdDhXRAs8f/dOjKjJgMOM6zQDrip5ZhqIbaV6JAmmzCzGJWJoa+Mhmn1
AcCiTY9Tei/Adm+ZLjnW
=s0AK
-----END PGP SIGNATURE-----

--nne7mHRH2OLlPtAbQPC14GsIV1oQVOdEC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
