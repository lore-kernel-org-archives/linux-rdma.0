From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 2/2] IB/core: Move SM class defines from ib_mad.h to
 ib_smi.h
Date: Thu, 3 Sep 2015 15:52:11 -0400
Message-ID: <55E8A4EB.5070500@redhat.com>
References: <1441304190-29212-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FcOEp1pQqdOkBEhIXUdRaPDOLwXWIQPQl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441304190-29212-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FcOEp1pQqdOkBEhIXUdRaPDOLwXWIQPQl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/03/2015 02:16 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> When the hfi1 driver was added these definitions were moved from the qi=
b driver
> to ib_mad.h to be used by both qib and hfi1.  They should have been mov=
ed to
> ib_smi.h instead.
>=20
> Fixes: d4ab347005fb ("IB/core: Add core header changes needed for OPA")=

> Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> ---
> Changes from V1:
> 	Fix Nits from Hal

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--FcOEp1pQqdOkBEhIXUdRaPDOLwXWIQPQl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6KTrAAoJELgmozMOVy/dvH0P/07m3P7bF0M8QaJrXW/mZkAq
SAJUfyeHjdd9z+BC+fc0CBEfSvy8tSVQMk6uoguyzm26ZKeLpNv55TbSk9cTYcfR
tODkZiXKJ51w9l9jgOVHQKKfXHNBZdek7tw3AZ8cfFc/Z9n8bv0IrQgE7fBykXvr
vtujF089LsKIFj8Vc1fDTmn1A9wrSr3qfuhUNOZaVIs+/BnS7rK75Bh3DcyyUT1Q
++zlcdlu+DuqmKgvfh9jiWRSeHFYinxwQekUlhzbLoAy0KgRcTeBVmi/REdkBGcD
c8URULRBFp2kJ8A7iWiLOnrqhc3G/bRvClXtWxSW6gwD7/FGOhcJmNCCfZt6q/U8
wc9Yw+KHgt92ni7UmLGJX3jqk0I6MAOInQW4Odd+zRHbwx7vis4xCz4sdgG/xkPh
A8jL2sNqxTM/gspr7XTD3wnAoQynJiCbWA8xvqh2XueqnYR7yEdTyZc3jnxCzsMP
C+BigafAhRVURj0ALeNJxe9MpySp2BG/ZK+njOFIWcunm/vwAn8j5Nw1Ul2Kzfo6
pu5JLfw2ZmasQYvs/R33aaMsD1KTcYAvkvwOPNvScS5GTYBvsRh4VXaw3S9aeEFr
ddX2OmFSqblno8AM/fuxLm9BGNfbO5yilN3nXnAJwP2aQOmdD5FHMq2yxV+ahJTf
x+9/+ngHOF/WJn1wxWjI
=PoWn
-----END PGP SIGNATURE-----

--FcOEp1pQqdOkBEhIXUdRaPDOLwXWIQPQl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
