From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/6] IB/uverbs: Enable QP creation which is
 associated to underlay QP
Date: Tue, 30 May 2017 11:00:06 +0300
Message-ID: <20170530080006.GB5406@mtr-leonro.local>
References: <20170530071602.8139-1-leon@kernel.org>
 <20170530071602.8139-3-leon@kernel.org>
 <20170530073352.GA1838@nanopsycho>
 <20170530075845.GA5406@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530075845.GA5406-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 30, 2017 at 10:58:45AM +0300, Leon Romanovsky wrote:
> On Tue, May 30, 2017 at 09:33:52AM +0200, Jiri Pirko wrote:
> > Tue, May 30, 2017 at 09:15:58AM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> > >From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > >Enable QP creation which is associated to underlay QP. This comes as a
> > >pre-patch for downstream patches in this series to enable flow steering
> > >from user space application on the underlay IPoIB QP.
> > >
> > >Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> > >Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > >---
> >
> > [...]
> >
> >
> > >diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> > >index 477d629f539d..422b20456975 100644
> > >--- a/include/uapi/rdma/ib_user_verbs.h
> > >+++ b/include/uapi/rdma/ib_user_verbs.h
> > >@@ -578,7 +578,7 @@ struct ib_uverbs_ex_create_qp {
> > > 	__u32 comp_mask;
> > > 	__u32 create_flags;
> > > 	__u32 rwq_ind_tbl_handle;
> > >-	__u32  reserved1;
> > >+	__u32  associated_qpn;
> >
> > This breaks uapi...
>
> Not really, we are using comp_mask scheme to signal changes/predecessor

s/predecessor/enhancement

> of these structs. Users of this file and structs check comp_mask and
> access new fields only if they are exposed there.
>
> In this case, there are no users of reserved1 and hence it can be
> replace to the new field with corresponding comp_mask flag (IB_QP_CREATE_ASSOC_QPN)
> without worry of breakage.
>
> Thanks



--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlktJoYACgkQ5GN7iDZy
WKew/g//bQjMSIN6nHwanPDbYf64ZSwUSrN1gSallP5BcOFOXjXDW6V7DHPPRb7B
Yvxwc7w2ICr4fV5bvHR9xh9T2W3r5aU88oQnYhaOx7SpS7EACbEtRYTHMfGAzG5D
RMnDLSv6gLmfSCMb2aX9Uv1oucR67JRyPHSy7fp+bCiEIVznvfZX38M5qsxyxIQr
yQv1Q5/RgnbOChh5UshzHmFeDJlmUpvIzWiwAJteSt5usng+7vTF8g1NJYexVKxd
QE9+tbUGk5BuQd+GNHQNrAcXq8rCJza58t+fjDXnkGBROezvvT475i+63LYNkmoU
GByRiARf6JxX1Y/oC3Mw3rg90zUcwn67s++xLttFvc20ZpKdxVJ6e97NC2f/i7M7
9Zzzz8AkkWJtpOemm5tazN3HGU8HstP8n7wysn8xzyOQNZbEemH0XjV8g+dtOYi7
SPAVzuzS1xkmt4yb8KyTp2GxZ1n7G37qFzXzlivQybOcJMvvmSr33KYd4uBw0ktp
QC2iL2cO1WYFN0+1a8Cb04eu8XbCbD5hAJvTf3Wq3I6uBTYjUa8nM8rmMbB92cWs
z2lw6Nzd8P4kld6Mj7JOZPk7G/8WPt2ATg8Jspw5rdsokGss1l3JTkST2V7DcQiJ
e+vZajv88iRduB273jBphFjHFX8H8j/BZVvzOPcNyGLLD02HSsg=
=H5BQ
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
