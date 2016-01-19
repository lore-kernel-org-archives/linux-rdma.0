From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Three SRP driver patches for kernel 4.5
Date: Tue, 19 Jan 2016 15:43:21 -0500
Message-ID: <569E9FE9.8000505@redhat.com>
References: <5684ED4B.2010303@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3lLkwXuqhImDnkbmmdC6g0sINK9gl4JS8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5684ED4B.2010303-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3lLkwXuqhImDnkbmmdC6g0sINK9gl4JS8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/31/2015 03:54 AM, Bart Van Assche wrote:
> Hello Doug,
>=20
> This series of three patches fixes new issues that exist in the
> git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git/k.o/for=
-4.5
> branch. It would be appreciated if these patches could be included in
> the kernel 4.5 RDMA pull request.
>=20
> 0001-irq_poll-Fix-irq_poll_sched.patch
> 0002-IB-srpt-Fix-the-RDMA-completion-handlers.patch
> 0003-IB-srpt-Fix-a-race-condition-related-to-SRP-login.patch

Since you are still working on the last patch, I dropped it, but I've
picked up the first two.  Thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3lLkwXuqhImDnkbmmdC6g0sINK9gl4JS8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnp/pAAoJELgmozMOVy/dfz0P/0HMfFxDSEiT/phiyvjCU7TT
bvLzmh+SMaBH+eI6KjTO2vgMa0NkkcdGuj7/Q8A7SGra9C0Y3DAVELmE9nVlXPeH
lw23gwaDAq2vW7ShlKDPaboz+AThhAwu20MwZLyH/xzpRejutOw78F8F1kBaSy/s
5LhLTddsJIptZpENGLk5Fg/Lcg/9T1+6DNLzjYAKV0HzCCE3smwDDlVz2jFb3ppx
ub0bjgmHQHdVYk2uiBIpL6OpxPMydFBqdyqVoeakAqu6GYUZq8QXrmFCm1QL+9oO
mdcCQyoQP5Wqr8tLlnlVOEhZc+mm9CNffgbrgvT1QACKLHdb3BntMxXSed2Gl+d+
UOf8QiIN1FcH2CKLU1uu7JNN+9wrDTUmHVuAANUQAcMDLscleBYKnNcH7/I5gui0
S3KfUsZdBjtCo9/GREJOmbDfpP4ekC5KQ/e2v9mmuHL7IltaWgVQek1lT224p8bI
Xbny11zjqpgDyTxJc7nUTW+GxzmibhwC8S8JZNRQJIMeSHXibLOGH0A8l9vCmIJ1
HAUU5u99k1Ej4J2GV9eNZ8RNILv+eMNatuvE7ZXH06wl5xysyf3L8v7gsb0TGIT4
rZrP4lpClp+oiGJvZ9B35GVl2CsxP/TROHJW3Gtn6hMz/aYP73jCBqkhSaFlLcR7
1RnR1I1nY579qDv492vt
=2aSN
-----END PGP SIGNATURE-----

--3lLkwXuqhImDnkbmmdC6g0sINK9gl4JS8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
