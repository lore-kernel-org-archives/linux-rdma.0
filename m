From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] i40iw: Set 128B as the only supported RQ WQE
 size
Date: Thu, 22 Dec 2016 11:53:20 -0500
Message-ID: <1a61e971-4944-b8db-0fd5-b73118b578db@redhat.com>
References: <1482179477-100780-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WKOUvWniAXQEVdI44HLagJHUKFjtuEauo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482179477-100780-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WKOUvWniAXQEVdI44HLagJHUKFjtuEauo
Content-Type: multipart/mixed; boundary="GMk1CWmJUNb36HKMDDOjA8O8joPNPWCIW";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <1a61e971-4944-b8db-0fd5-b73118b578db-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] i40iw: Set 128B as the only supported RQ WQE
 size
References: <1482179477-100780-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1482179477-100780-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--GMk1CWmJUNb36HKMDDOjA8O8joPNPWCIW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/19/2016 3:31 PM, Tatyana Nikolova wrote:
> RQ WQE size other than 128B is not supported.
> Correct RQ size calculation to use 128B only.
>=20
> Since this breaks ABI, add code to provide
> compatibility with V4 kernel driver, i40iw.
>=20
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--GMk1CWmJUNb36HKMDDOjA8O8joPNPWCIW--

--WKOUvWniAXQEVdI44HLagJHUKFjtuEauo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXAUAAAoJELgmozMOVy/d6JwP/2iAzn0nGnal11uK8YKS4AmV
elYg2f0imdAUJbSDAjq68CR6IUUWSoQYSlqUP6HES32nf/QO2fxeVN3DU2VJfzbm
TxR9FYUDihQ35Evs3i/a+wG00hbH10+pRNzVV9OBJbIwRV1GDCPTecV5jJLm7rRa
X0FjtTTFQ8tA7dUu/hd3GV4ANBuOYpuXE6Mv1d650BrpwmxlBLt1WIanJyh9QR89
ryF/VU3KKd7ipjApTZKWt398PCTEZ6d8lHv1tJGSUWjSKnkAzT5tKGEEKvGWvjKr
Exhfl8ZxeEngUCYqSjKHfYERAv4V516Xo7vzMETW4XNmE2Cwk2qRhDxqfS3NxioA
jf7x7Ig7mrCGMRr3eQSt1+b7UolSs0ONtkxxdyY8CcRwKlWYzUbM7+lrqkLiffc7
HTfS8SbjhqPrHWEZ27WdaegTp6umn5VQchRlM/YXKsQbX/S7ZMCKsfn2SiyjDYYd
O8p4oAMY+ZRXPKqC0zlzSRH3kams/UxBt6IlFmSSJBi/a/2QS5C/sKPwld0ywH5Y
TmRlg/gu2Bqu9vptUWZSWUcrUrXKivcixSAzm836/+iUBxnQTh/C9xkVHUhdRCGr
miv5nj5RA4HG6O05GnUEor7fVDxU6i9497v35JzzXLLqExCc7dUpXgAdcqT3FG0k
drKFmyP2TdBySazdAIYD
=Z+le
-----END PGP SIGNATURE-----

--WKOUvWniAXQEVdI44HLagJHUKFjtuEauo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
