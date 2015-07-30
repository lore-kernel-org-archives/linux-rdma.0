From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V6 0/5] HW Device hot-removal support
Date: Thu, 30 Jul 2015 12:59:30 -0400
Message-ID: <55BA57F2.5040207@redhat.com>
References: <1435659967-27173-1-git-send-email-yishaih@mellanox.com>
 <55BA54FC.8060905@redhat.com> <20150730165014.GD16659@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QgpUetsMv0sSWGpObdnl2we1GHXlac7rX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730165014.GD16659-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QgpUetsMv0sSWGpObdnl2we1GHXlac7rX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/30/2015 12:50 PM, Jason Gunthorpe wrote:
> On Thu, Jul 30, 2015 at 12:46:52PM -0400, Doug Ledford wrote:
>=20
>> I've pulled this series in for 4.3.  There were some additional items =
in
>> some of Jason's comments that ought to be looked into, but I think thi=
s
>> patch set has reached the point where it's no worse than existing in
>> terms of locking, there were just some existing issues that should be
>> addressed too.
>=20
> Eh? V6 corrupts random kernel memory if you use the hot-removal.

I didn't see that in there.  Did I read through the discussion too fast?
 I'll go recheck...


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--QgpUetsMv0sSWGpObdnl2we1GHXlac7rX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVulfyAAoJELgmozMOVy/d72AP/R4wexhWvobn+ChX8yJVnVha
kfNX28yhp8fHuQFJtFGhXrbtNYxb2n9J4RUMPaX5Vb7SGWX5z3VR8Jtm73aKKpqE
Ub7vEe3OFaDQKZWBT6SAl3INOIFnY8PL8UnFofMRxpq4zKId1uu1Et47cDmb6lHt
Tf8KjqQ5PmcwmFPJM/AOUBs3Gvl1SXL4QgQWzrJWnKLzyUsjurai/yxeu4qcPrhq
vE1ax995/LiJ87ZeaT/RpQWTnb7aXqExMP7+NsmJMJDF2PgdGMHctU/pV304NrR2
jrLt7lsJ3rEDE3LYs8aJ9hGAQMyRVUny2khTJ6vzSbFOVGT5FGvOsX59xPRS6rp5
AvOMT0Bk9qTuDjJCajrTkZHnj7ULidKvr+r4i33k6+PJH4M9Z4LSfFzX+1Nf8FY5
gUeyNa5KBci5K+jR6qk4d/fef1GVN0qlQI+M1VB10TnRTipgqDdB0FYeCOG1EX14
ezz/F/FFKhGbFl6Lj+QMfMvKomICv6Z+02zNGKqbe2RF/2lhs1TR/A1oXfnKK7gz
yhAXjTJa25BHsADHwkONZZpkxewriXdi1dLgZxENU/Mn4RfaAqITtuVHauIGzTvX
8NWD22lxCTD+V9RqfBjfm51DeRngfWNHu1p3BjSnrac8E/Yclvgr+33sfH738kvN
3YgDeQZ1sUqAf/m4vZPT
=DjMi
-----END PGP SIGNATURE-----

--QgpUetsMv0sSWGpObdnl2we1GHXlac7rX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
