From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: Fix the max_sge reported from FW
Date: Wed, 24 Aug 2016 11:35:01 -0400
Message-ID: <017edd91-95d9-b2e2-08ad-e6145c9590c6@redhat.com>
References: <1472015861-10312-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a0koUtMH972URmkSQqQ7kbRBLNGLmheCw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472015861-10312-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a0koUtMH972URmkSQqQ7kbRBLNGLmheCw
Content-Type: multipart/mixed; boundary="Pi6qFIrLtVkFjWudfcvq65RS6DjDKPdVH"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Message-ID: <017edd91-95d9-b2e2-08ad-e6145c9590c6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: Fix the max_sge reported from FW
References: <1472015861-10312-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1472015861-10312-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

--Pi6qFIrLtVkFjWudfcvq65RS6DjDKPdVH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/24/2016 1:17 AM, Devesh Sharma wrote:
> From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>=20
> Current driver is reporting wrong values for max_sge and
> max_sge_rd in query_device. This breaks the nfs rdma and iser
> in some device profiles. Fixing the driver to report
> correct values from FW.
>=20
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--Pi6qFIrLtVkFjWudfcvq65RS6DjDKPdVH--

--a0koUtMH972URmkSQqQ7kbRBLNGLmheCw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvb6lAAoJELgmozMOVy/d1owQAK0EbfvK/54I5Tpi0wc6Kcsc
KOxNZSvo/7m2icdkEKj9D7BJqKn9D4l8egHgI+M+e4vHbwop5/gSaJ3S42zCFwQV
8E1NiJQWrbIfVZHalTbifsjI09FdKAn1+5IBG30i3MZbmF6t6qmEYGDlIVZ8KrBm
DQ0mE02dmFqQoS3cWwN/EFxZ1b/iaH63oRPayt6iWdDgsKMKFbHN3GIpiQMmGJmG
y/g1/yOBlUSSZAP/4qWFhbu3zI5Ek0Hj4eDbqM/PWgFsfu5z181ppKC5X1GlonfF
b5n2oJel15tf+dTHwvkcsGmflDdC6zNB9aOyHEskik7gSmI24wmCjJttyHww9uGS
VnhJ3Ipd6RiPhgypAqtqKNEWW3DyEGQeg3rNlGjByR9H5DtNiprEZBBu/j/RdvId
SV7FliwPf5uq7dvsWL6iKUk4+EbulTLpbq4PmePB2BmnnY74DP+Afd/UMebGTZTU
crxZ308Xd5M7KnjIVXcJhX7zDd0oLKTKOeo2WLW0eIg0gfkeHHZuPBcFZv8zVhI/
4kBnV7NUnjeE7OH3VqdP+14QsQ+hVvysUUqj51hwNkDocR1UHcQBeEM1AcRYBM01
PyvfJFKdntZp61RXtJhB9IG9t7I59eJyLQBrn/SVl6j8VEy/7rAs0X/qnhdtvPNk
UrIAI3ejkZ4GmFLKAX5z
=MLR3
-----END PGP SIGNATURE-----

--a0koUtMH972URmkSQqQ7kbRBLNGLmheCw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
