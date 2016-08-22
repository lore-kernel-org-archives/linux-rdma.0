From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fetch monitor values on-demand for CableInfo
 query
Date: Mon, 22 Aug 2016 14:22:02 -0400
Message-ID: <bbd4a0f4-cbf4-c75e-9d32-623aa5fbdaa9@redhat.com>
References: <1470755838-14117-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UpV5l8ieTEsAvFp03upW8piEAJ4VklbAq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470755838-14117-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UpV5l8ieTEsAvFp03upW8piEAJ4VklbAq
Content-Type: multipart/mixed; boundary="O4Wmsu9ckVTcd6OvSBhLpf0gKp7W291g5"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <bbd4a0f4-cbf4-c75e-9d32-623aa5fbdaa9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fetch monitor values on-demand for CableInfo
 query
References: <1470755838-14117-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1470755838-14117-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--O4Wmsu9ckVTcd6OvSBhLpf0gKp7W291g5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/9/2016 11:17 AM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> The monitor values from bytes 22 through 81 of the QSFP memory space
> (SFF 8636) are dynamic and serving them out of the QSFP memory cache
> maintained by the driver provides stale data to the CableInfo SMA query=
=2E
> This patch refreshes the dynamic values from the QSFP memory on request=

> and overwrites the stale data from the cache for the overlap between th=
e
> requested range and the monitor range.
>=20
>=20
> Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--O4Wmsu9ckVTcd6OvSBhLpf0gKp7W291g5--

--UpV5l8ieTEsAvFp03upW8piEAJ4VklbAq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0LKAAoJELgmozMOVy/d05wP/1oWAjPeVzD4gyCN2WLB9osU
RR/QmJmVP+BbS9N/ywys7c2UcEuesrm7hudLsMybLomuiwpG1HHEfvOVC5WSD4xX
/wDYEAZP/foMQI7rIFkNrcvLa81UOwRMOAtrUXkXMdbpjuX8l8bbkObDde+NqoxQ
yGTI1m6cgrsfq7NGYsl+8E3NkCqVGrTCtPC3us8jFPmI+rwHNeunXhhO3C5g0DcP
tc2QRanr9XptIHLY/cZuQV/uU7wredsQH11lscK8oAesx0HVWh0GHrTy/7akBNkj
JYhZUJQ+kBj91hbWe4MraMOrlBDf056f3E1CflM07LIGKv1UEcEyfAPBWT6vf1mM
zR8yN3e20SdsGTaQwZhwRmWC63gjmqL17/a2n7oc0sQmxhpgKkem8+e4FTkCUNWV
o6OkNVE8UhtkBzLtzWHBZ42HMjRaygpe08J0w8zS3JtsWLEykPsl+hedQDaEdTis
a8FIGRycLcw/ddCrfesvpOTIp5q/ExKwsf2zoFunJuzZ0r/nDZdVeuHJE4lDiEGz
vI8YYHSGiHPEcq6IbokClLKK3TaqOJFSkFNrNXCkdgD27bOylebZHxjvfBmWaTow
AH+LomFRJS9jE09jqEMCOSym/KTvSp2+I3iZROuQwQX4JSoyPG4p3eqz3wPPs0Mr
Prfaq5O3BcqWFu92vbyI
=EpeE
-----END PGP SIGNATURE-----

--UpV5l8ieTEsAvFp03upW8piEAJ4VklbAq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
