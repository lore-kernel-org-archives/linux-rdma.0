From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 4/6] RDMA/hns: Filter for zero length of sge in
 hip08 kernel mode
Date: Mon, 25 Dec 2017 12:20:45 +0200
Message-ID: <20171225102045.GC2942@mtr-leonro.local>
References: <1514017342-91468-1-git-send-email-oulijun@huawei.com>
 <1514017342-91468-5-git-send-email-oulijun@huawei.com>
 <20171225090028.GY2942@mtr-leonro.local>
 <42e22cc6-f385-b6f4-bd14-1450ae19519a@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1xJJiECQTZ8+YlWm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <42e22cc6-f385-b6f4-bd14-1450ae19519a-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--1xJJiECQTZ8+YlWm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 25, 2017 at 06:08:08PM +0800, oulijun wrote:
> =E5=9C=A8 2017/12/25 17:00, Leon Romanovsky =E5=86=99=E9=81=93:
> > On Sat, Dec 23, 2017 at 04:22:20PM +0800, Lijun Ou wrote:
> >> When the length of sge is zero, the driver need to filter it
> >>
> >> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> ---
> >>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 29 ++++++++++++++++++++-=
--------
> >>  1 file changed, 20 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infi=
niband/hw/hns/hns_roce_hw_v2.c
> >> index 869e36f..a1d8ca0 100644
> >> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> >> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> >> @@ -230,26 +230,37 @@ static int hns_roce_v2_post_send(struct ib_qp *i=
bqp, struct ib_send_wr *wr,
> >>  				     V2_RC_SEND_WQE_BYTE_4_INLINE_S, 1);
> >>  		} else {
> >>  			if (wr->num_sge <=3D 2) {
> >> -				for (i =3D 0; i < wr->num_sge; i++)
> >> -					set_data_seg_v2(dseg + i,
> >> -							wr->sg_list + i);
> >> +				for (i =3D 0; i < wr->num_sge; i++) {
> >> +					if (likely(wr->sg_list[i].length)) {
> >> +						set_data_seg_v2(dseg,
> >> +							       wr->sg_list + i);
> >> +						dseg++;
> >
> > Actually, you don't need to advance desg and keep your "desg + i" code =
as before.
> >
> > I have a more general question, is this scenario (having length =3D=3D =
0) real?
> >
> > Thanks
> >
> Yes, The origin plan for processing the length of sge is zero is that the=
 hardware recognizes
> and filter it. but the final plan is that the software filter it and have=
 an improved performance.
>

My question was an attempt to understand if kernel can create sg_list with =
length equal to zero.

Thanks

--1xJJiECQTZ8+YlWm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpA0PwACgkQ5GN7iDZy
WKeuIQ//b0tAGYalLMZ2R27XCX4zpobarizrxTc9T6xgD5Vv+0pjJhLLu/yVEY95
xyLlOo3BIzjNOiIVD9YzMrCjdJvwUr+SiTF1zffysEAEMLK577AROVWRceX7DzaT
VMVvJECo9DvNNsd4lbVjL1c84fBd4J+4YK/S825qNhIVbucrOSx26NdZGVyrBiJ4
tmfhJhP3pQ5/U6Xb7Vn+F1XT0bXiGEDz3qmjlD4j8pGvJ2Gk+3e6tR2DsHEHYXTD
wxqmiykGcwA4qtDdvyD8nBpsg0hUj5snoNVSpobnL3pUDw5dmFHVYe6BccUIX1iJ
CaqJ9E7Ad7yaO3k3A227Cb9oCF/Oee8E1bEk1xIqYt27oOy0eveNuWLlc3K6Ykij
+GFHtRhl24mEipsteoiFg8WW+ILPr+WfMGfVI7hWAFYQD21+pm3JtRJEl1Q2NrMF
GbE7pGyZoWL8niVS+hAlIslsJd5hP+Y3BSgaJoj+5XqRBYHbRI6+xdrouRy5WzSA
jp47P7V0bA0PqYyrqnxdA/AuZWtSSh4c/g/9ueyaA1//v0jWDy/wGHocotyhEejU
wyRigHGIXqC/3WBSLgsM/qOKIo7kwJYqXEKWGiRC7ogY/TPrwIZ41MGYYYe0jcyd
WQCCLp1FTWvNq+bTWGam+HT3HmY6AO/zqMD7yMZPuurPJosBl0w=
=TjTy
-----END PGP SIGNATURE-----

--1xJJiECQTZ8+YlWm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
