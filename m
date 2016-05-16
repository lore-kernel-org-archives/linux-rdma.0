From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Mon, 16 May 2016 14:01:04 -0400
Message-ID: <102cd100-55f7-fa85-cd75-ba0db5b9fa34@redhat.com>
References: <20160315155441.222586021@linux.com>
 <20160315155455.173645653@linux.com>
 <057c8ac8-1d34-e7b9-c0ad-91d805c81139@redhat.com>
 <alpine.DEB.2.20.1605160851370.23895@east.gentwo.org>
 <041c6da0-e022-2bd1-5f00-e569c077e154@redhat.com>
 <alpine.DEB.2.20.1605161203010.26453@east.gentwo.org>
 <db1bf3dd-20b1-3f2f-eaa3-25e5e8aff35b@redhat.com>
 <alpine.DEB.2.20.1605161238560.10085@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QDHsapdVfJAR2PVpjcf6uj7qvfiLnPbwj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605161238560.10085-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QDHsapdVfJAR2PVpjcf6uj7qvfiLnPbwj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 01:49 PM, Christoph Lameter wrote:
>=20
> Ok patch with the changes requested. Check in core/sysfs.c removed.
>=20
>=20
>=20
> Subject: ib core: Make device counter infrastructure dynamic V3
>=20
> V1->V2:
>  - Use enums for counters for cxgb3/cxgb4
>  - Use BUILD_BUG_ON instead of BUG_ON
>=20
> V2->v3
>  - Change the way to check for MAX_NR_PROTOCOL_STATS
>  - Fix typo
>=20
> The current approach in ib_verbs.h is to define a struct with
> statistics fields. ib_verbs is an abstraction layer for
> device drivers and the protocol_stats should be abstract. However,
> in practice these are actually device specific counters (also used
> in such a way in Mellanox OFED). The device stats are a union
> and in practice evolve to a union of device specific stats.
>=20
> ARGH!!!
>=20
> This should not be defined in a concrete way in ib_verbs.h since the
> API definition needs to be device neutral.
>=20
> What we need is an API that can return an arbitrary number
> of counters that may be general or device specific.
>=20
> Here we simply define an array of strings that describe the
> counters and an array of 64 bit counters that are
> displayed through sysfs. This makes ib_verbs API appropriately
> abstract and device drivers do not need to update ib_verbs.h
> (and thus break the API) to add more counters,.
>=20
> This patch is groundwork to later define the protocol stats for
> Mellanox devices.
>=20
> The strings being used in the device drives should only be present
> if the driver actually supports those counters. If there is
> a standardized name then devices should use the same name
> as in other infiniband device drivers.
>=20
> Note on cxgb3/4 portions:
> - I was unable to test because of the lack of hardware
> - The counters that are never incremented were omitted. There may be th=
e
>   impression that less counter are supported. But the other counters
>   have never been supported.
>=20
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, this looks good now.  When the other two patches come through
I'll apply the group.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--QDHsapdVfJAR2PVpjcf6uj7qvfiLnPbwj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOgrgAAoJELgmozMOVy/d38oQALdW7V822tzSI2Ysfy+7MtYn
5bWaGiEaLsRKsi9X+QpIrJ/n0CNm8hawJVrOfypmadb2reX76f8bsFRRJJECemJZ
shN6+Ga38HSUuOJdzJbtndumIzW9YZ8T9xTNU6pgqJBcukXHDo29JcxzVvN2T79H
FVCvfhT0mPelV5ZYxS39qD2DSSesNQ++Ll0eDJ++nVkPVZupFCR31U2YjGQRrv2Y
iECEyLG1Fz9rNzyiPxzgXY8Hzti5cyoIF6oggxAdx8Wu9axaJW1AjMJa4TLV1qqw
DLnziv7a8mAPF9QXFcEBerMkOX3cXgNhyI7gMoLMnjA9jUcCOPQZD5RWDBWH7kDX
cQLHEXap0ySToXYVLGAMvZfeO+J0CEzigSTfUGqdLtECSrVtHFbzn3apas5CHevm
MLjw9ZkuiSOvLyBLeeRRd7o8GZDme13LfFADFUp5YDujGVAJlZuwFKzTr5GrRoIM
OwTqAnsUHtwBXIxn93MKWJu3lEIfvrzhKitmntWhI25Zv58YXY5XCv+fayXEIKVp
EyI2Zsa+SYgdh/V3D1rADesh8YSgLR7Ch44Kux9XPDvXQZkNIl3FcTmyyPu+zAe3
TNiaxathJQeyd8ECHtqQZt2DB7XaHSQ/o2/2e2SaUIhUcoh+D/4gLT2fednrxl6O
xS9a5TZ5tMe6xwXjxkgt
=PJfB
-----END PGP SIGNATURE-----

--QDHsapdVfJAR2PVpjcf6uj7qvfiLnPbwj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
