From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] bnxt_re/lib: increament psn in case of 0
 length packets
Date: Thu, 9 Nov 2017 11:51:38 +0200
Message-ID: <20171109095138.GE18825@mtr-leonro.local>
References: <1510218658-16710-1-git-send-email-devesh.sharma@broadcom.com>
 <1510218658-16710-3-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bE2XbrxqIoa/xW9+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510218658-16710-3-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bE2XbrxqIoa/xW9+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 09, 2017 at 04:10:58AM -0500, Devesh Sharma wrote:
> If application posts a 0 length packte, post send routine
> is skipping to increament the psn number. This will cause
> PSN number to go out of sync and evantually connection would
> terminate due to sequence error.
>
> post_send routine must increament the psn number by 1 even
> for zero length packets.

s/increament/increment in all places.

Thanks

>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  providers/bnxt_re/verbs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
> index 4d9b044..9d4e02b 100644
> --- a/providers/bnxt_re/verbs.c
> +++ b/providers/bnxt_re/verbs.c
> @@ -1048,6 +1048,8 @@ static void bnxt_re_fill_psns(struct bnxt_re_qp *qp, struct bnxt_re_psns *psns,
>  		pkt_cnt = (len / qp->mtu);
>  		if (len % qp->mtu)
>  			pkt_cnt++;
> +		if (len == 0)
> +			pkt_cnt = 1;
>  		nxt_psn = ((qp->sq_psn + pkt_cnt) & BNXT_RE_PSNS_NPSN_MASK);
>  		psns->flg_npsn = htole32(nxt_psn);
>  		qp->sq_psn = nxt_psn;
> --
> 1.8.3.1
>

--bE2XbrxqIoa/xW9+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloEJSoACgkQ5GN7iDZy
WKdi/xAAzOR3v2N+Fdd2qu3MLt7TufFd7jYW2/TsEjiqRz7yzY+xzexZpTAUpu8z
43rLOy/kLtMvB1PCF4vljeBC1jTD/PRXBzcbLTnS9SUeoV4fpq9wtM+7juZbcxwQ
h5sy5d5i7lB90OycRysZ6ymsZvUz5aixACsEXpswbb7q1Joh8jtOvSdQ2KXXZoXa
WMnQseyMDbxCv0Rhy2SCPyD22elIYhLccmHsg8vk7+Xo/7pOVroK3aM41VxGCvqh
+vQR8jBtTKNVgLufiRB4DAqb5Gc0XuFSVeEiB30EzRfe3J0fxXZqOJIdK546M83V
l8L/F6get8JcMpxn6jnCFkmVnnYnsPPeqng1trKffbAsSuMsd/LL57+CNFqZCDb2
ryHy16dj03Ui+8+x4GqnRfqgs1CCNsLfX/WrcvrnzZ2HulI/DJzYSWcejF3Y1W5+
V28U2iX7SF4Kh5edWZTxs3vtHcRqHaNU1sDHQo0WJ0RjUuDptQO2+b2X/USqjfAH
on5TvQqtM5Yofd/+Uapeq1NXoY281Js7P3/V1pbokVhrBe2WOfknssU5eMQuSS+L
CmQd/Z9ACSP72Iqi6rcV6AUXRZyB2Y7ckM2diScV+bX+cSdX/GR2OBSW3haNwtUA
NvlG+tEOr273wQa9W/OiTit7O1lI8CsLgHgNMCxmHlkBIle15bs=
=U/bP
-----END PGP SIGNATURE-----

--bE2XbrxqIoa/xW9+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
