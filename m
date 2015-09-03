From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Thu, 3 Sep 2015 17:17:31 -0400
Message-ID: <55E8B8EB.7000009@redhat.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DCAACD.3000307@redhat.com> <20150825182233.GA20744@obsidianresearch.com>
 <55DCB56F.5000001@redhat.com> <20150825194945.GA22335@obsidianresearch.com>
 <55DDC12E.6030705@redhat.com> <20150826161829.GA27407@obsidianresearch.com>
 <55DDECA3.4010207@redhat.com> <20150827233322.GA29724@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="K8cuiCenwA315CTkgHjXCVIE5WfEtQIUn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150827233322.GA29724-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K8cuiCenwA315CTkgHjXCVIE5WfEtQIUn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/27/2015 07:33 PM, Jason Gunthorpe wrote:
> On Wed, Aug 26, 2015 at 12:43:15PM -0400, Doug Ledford wrote:
>=20
>> That still takes us back to the fact that the locking changes are
>> unneeded.  I'm not opposed to them, but as you mentioned in your first=

>> email, they should go with the changes that require them, and none of
>> the changes in the first patch require them.  Which means that if we
>> want to keep them, it might be worth splitting them out and giving the=
m
>> their own patch with an explanation of why they are a benefit (lightly=

>> contended code, saves a release/reacquire on the failure path).
>=20
> Lets just drop them, the cost for restructing was an added empty lock
> grab on a non-error path.

I've reworked the patch to not perform any locking changes and applied
the result.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--K8cuiCenwA315CTkgHjXCVIE5WfEtQIUn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6LjrAAoJELgmozMOVy/dvYYP/2e6uGd8oTc96XuCm9gRDlpZ
eehDaM78sN/JX9PdaQnS8wkLs3CafjREyed3lsxmvzDfJ99LkPtfle0RBh1FDSf8
KFwwC4DfU5yolk4t+02Q10/+jnU8ee8mgLWvUeMJeCBBqapH2lsCeihRc59SsXuP
X+I/5UI7Euh5Md8J2sV3MTk4t1oZM5oxhL+g3Fmhc+vatjeuS8OLYmba/VKitgML
ILwCPS0ZImcPnA9poPr30Ed922NhKcqilF5dPFpvAdj5tkoOjbhV+UlHpAni079m
f5I91/WX0WN8VxnOTf1yHkDuX0p9Ui5zRP8+0uEZYp25/fMQqII2uYVqSq9Q80bi
b2Iz4BOFYbvb8MYbMEVi0ULB02xCrl9DzC3fU44OeJ1h7ZjBLpBtzqDFrIuULr9Z
QjAdNR8qz3jOyx47RVpK6AZMFt8/Ym8Wgi3k6saZkDFsn6wbpMbUs/DIQ2uiTEtJ
oo0QElRcELlUyY+iUEf2iIfFnO16UkJAzreqnSHErcubMG+9KfUVu+50UQpHy3l+
I0acUs2UKrPSyk4c3j+YBTK3ll94RIVhIuMlhJS2n12T2UL+NnK10QTQp14cVTWO
9fjG9YYcOCM+cwZKJspXvawuoUOwI8Xzh/JI9uu/dPx1ucROFiDCtZOsjDiJu7/j
z9P1Xl98bwiV7c5dczNG
=HJEf
-----END PGP SIGNATURE-----

--K8cuiCenwA315CTkgHjXCVIE5WfEtQIUn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
