From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.7] i40iw: Enable remote access rights for stag
 allocation
Date: Tue, 12 Jul 2016 10:59:21 -0400
Message-ID: <a0331cbe-759d-a4dc-4cad-1624ef503c62@redhat.com>
References: <1467064334-12064-1-git-send-email-shiraz.saleem@intel.com>
 <20160706173256.GB37468@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="V1v21dJ1B2v8tLcLnsdntUS4MknKtOIXs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160706173256.GB37468-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--V1v21dJ1B2v8tLcLnsdntUS4MknKtOIXs
Content-Type: multipart/mixed; boundary="idVisos9gTooXXFeW82E0Hr4H5dc8Cqqp"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Message-ID: <a0331cbe-759d-a4dc-4cad-1624ef503c62-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.7] i40iw: Enable remote access rights for stag
 allocation
References: <1467064334-12064-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20160706173256.GB37468-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
In-Reply-To: <20160706173256.GB37468-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>

--idVisos9gTooXXFeW82E0Hr4H5dc8Cqqp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 7/6/2016 1:32 PM, Shiraz Saleem wrote:
> Doug -- This patch fixes a regression. Can you please include=20
> it in the next-rc for 4.7?=20

Applied, thanks.

> On Mon, Jun 27, 2016 at 03:52:14PM -0600, Saleem, Shiraz wrote:
>> Fix to enable remote access rights when allocating stag.
>>
>> Fixes: b7aee855d3b9 ("RDMA/i40iw: Add base memory management extension=
s")
>> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/i40iw/i40iw_verbs.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infin=
iband/hw/i40iw/i40iw_verbs.c
>> index 33959ed..283b64c 100644
>> --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
>> +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
>> @@ -1474,6 +1474,7 @@ static int i40iw_hw_alloc_stag(struct i40iw_devi=
ce *iwdev, struct i40iw_mr *iwmr
>>  	info->stag_idx =3D iwmr->stag >> I40IW_CQPSQ_STAG_IDX_SHIFT;
>>  	info->pd_id =3D iwpd->sc_pd.pd_id;
>>  	info->total_len =3D iwmr->length;
>> +	info->remote_access =3D true;
>>  	cqp_info->cqp_cmd =3D OP_ALLOC_STAG;
>>  	cqp_info->post_sq =3D 1;
>>  	cqp_info->in.u.alloc_stag.dev =3D &iwdev->sc_dev;
>> --=20
>> 2.8.0
>>


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--idVisos9gTooXXFeW82E0Hr4H5dc8Cqqp--

--V1v21dJ1B2v8tLcLnsdntUS4MknKtOIXs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXhQXJAAoJELgmozMOVy/dtd0QAJB3R5h9h9QvvYQoBkzesbJV
t96E2WFzQl7jN8HkQ4mpune2rdSQgvsF1Oj/6G/Jnr570jRUKKMeoUToTTG0GzDG
LxRaF2ND1Sl6cJyNA0ybJ+KOAyqnbR/cKY/9jml7W1y8rsPlr0JgqzLfla+fvf1y
PNcaGOhcYTMOwUxKvqv9ZKxt1B32aRghDY0zUikmFwApNZJ8RKFnNCzVqAh6L74B
TG5Qf8UqRkYCwJ//DsfsiWTjkBXUJoBAeKZxRZRsnmx7vJR2SLLWnNqplViaKN1X
O5Sfpi+jIfEcbJ2eDIA0Wad0s64i/cQj5Uy2q/LAsVo0NROvesYLqzLjofwrRz/n
RRdtKK2RoC+9DjmotahlfVviA2Hk39finZAKbrPf1ouqBMeo4fh9sUdnWOwaUHS2
pt0xftrNuKBHAfV4qgYL/Z0q6JEaOJDVoJYD+7WfA2u+UZhdDzHB9H7PPtfw7NC9
Wy7EpFB27WOP+c74OWltqRd3wKn7DwNSCtT3IPWLQfIVPkwApUZ8JPvj5fTn+H6C
XTeVPRrypXrX6rrJdlY1E5MaGFwwKPr8eu6ZvG8+MkuPXKbwrMD4r0sUSg9Dz1uF
6PQgN8MCcPm92E8d4/uwv5nK50eMY6E99hza2r33PIK+ZUx37pg58+3VRUIXOpV1
IPCOQiufl/VvdDUzufKa
=z56o
-----END PGP SIGNATURE-----

--V1v21dJ1B2v8tLcLnsdntUS4MknKtOIXs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
