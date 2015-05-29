From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 03/11] IB/core: Add CQ creation
 time-stamping flag
Date: Fri, 29 May 2015 12:47:02 -0400
Message-ID: <1432918022.114391.102.camel@redhat.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>
	 <1432220202-9834-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-hOJ4uG5+oCKXXSQmh9n+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432220202-9834-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-hOJ4uG5+oCKXXSQmh9n+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-21 at 17:56 +0300, Or Gerlitz wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Add CQ creation flag which dictates that the created CQ will report
> completion time-stamp value in the WC.
>=20
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 4f6b397..28ec073 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -166,6 +166,10 @@ struct ib_odp_caps {
>  	} per_transport_caps;
>  };


This needs documentation, and quite possibly a different flag name.  In
this case, you are timestamping the completion events.  That's fine, but
that's not the only thing that would be a reasonable timestamp event in
a complete API.  Maybe someone wants to timestamp the start of the
transfer instead, so they can order packets not on who finished first,
but who had their first byte arrive first.  A note detailing this
possibility, and then stating that this particular option is for
completion timestamping, and maybe change the name to
TIMESTAMP_COMPLETION.
=20
> +enum ib_cq_creation_flags {
> +	IB_CQ_FLAGS_TIMESTAMP   =3D 1 << 0,
> +};
> +
>  struct ib_cq_init_attr {
>  	unsigned int	cqe;
>  	int		comp_vector;


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-hOJ4uG5+oCKXXSQmh9n+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVaJgGAAoJELgmozMOVy/dJpMP/RGeVn4+ZtW/Tqa7LVSsxTbp
dJ9BPu09RMCEpEit6UQaIsf/WN5+SPQqaj21n91RSmhCF9BrmpRoRm35DeHSlv0z
5gGq7muHgMFetcD+1QHpxMWZ9yy0AFKi7jznF37BpBCXPbqx0Xd77DCHMIeDFmF9
EoQSvSaMrHR7C4hz2wjvfvvUiPBQdk7i4vMbTw45bdY13gJ708WOjWmhEju8EiFf
n1Ua1a4jHaSCbwN55xreUPo+bePYCEcw4ku/P23JrmRTggl8lykwI/TKsS+ye2Wq
paHdrXfcuheAXRYC520iRiXeD9ZR3apiFUZIyRCElWN5z8wsnr1e7r0CZKHBRpEt
aXdnByCyfV7T2kO7hey2IAjaQN/NPxTWSEHgv/I3bZ5UMZp2+E9NpxUX4pohxGVT
B+yhYdBgSCt4AXVJ0ah3WBjYCgkjXdVdENV9GJ6skWB5XB1XaVLV+NHlwVqSJQoj
DX7If2uuJT7hSGlcSljEttth8EkriGZ4I+OaB5xD36hDzceC88m6Fc7jWCODlZhx
ZFA1cTxpAxlYE5Qbd/DtPhQ2oIaOOC2SWd2W6lQHAvp7VbWZ+z/ABDaSp2p50xNF
pqBJO4Y/pNXb/S2flyh9fe4X89AIvsYsdPXvtAS6K0Gf2hkcmSiXnYApm5y1T0wL
Zo4BkkA6p9QJe9BAknf+
=k3Mf
-----END PGP SIGNATURE-----

--=-hOJ4uG5+oCKXXSQmh9n+--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
