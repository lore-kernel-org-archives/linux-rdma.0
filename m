From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/6] IB/uverbs: Enable QP creation which is
 associated to underlay QP
Date: Tue, 30 May 2017 10:58:45 +0300
Message-ID: <20170530075845.GA5406@mtr-leonro.local>
References: <20170530071602.8139-1-leon@kernel.org>
 <20170530071602.8139-3-leon@kernel.org>
 <20170530073352.GA1838@nanopsycho>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530073352.GA1838@nanopsycho>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 30, 2017 at 09:33:52AM +0200, Jiri Pirko wrote:
> Tue, May 30, 2017 at 09:15:58AM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> >From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> >Enable QP creation which is associated to underlay QP. This comes as a
> >pre-patch for downstream patches in this series to enable flow steering
> >from user space application on the underlay IPoIB QP.
> >
> >Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> >Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >---
>
> [...]
>
>
> >diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> >index 477d629f539d..422b20456975 100644
> >--- a/include/uapi/rdma/ib_user_verbs.h
> >+++ b/include/uapi/rdma/ib_user_verbs.h
> >@@ -578,7 +578,7 @@ struct ib_uverbs_ex_create_qp {
> > 	__u32 comp_mask;
> > 	__u32 create_flags;
> > 	__u32 rwq_ind_tbl_handle;
> >-	__u32  reserved1;
> >+	__u32  associated_qpn;
>
> This breaks uapi...

Not really, we are using comp_mask scheme to signal changes/predecessor
of these structs. Users of this file and structs check comp_mask and
access new fields only if they are exposed there.

In this case, there are no users of reserved1 and hence it can be
replace to the new field with corresponding comp_mask flag (IB_QP_CREATE_ASSOC_QPN)
without worry of breakage.

Thanks

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlktJjUACgkQ5GN7iDZy
WKfEQA/+Kz1CU7eL2pesDVEeWI4zYxcfixViAlTG7el46M//QitvZUl9g4F7+Bzb
ZiATPUapajqtj4q0UxL61c0RrAmgCpsLaek0vkb1y/7ELfSz7FRLkCqTSaclQclC
qZT4aKyE2QijY5qL9ZMW5XBfJiE0QqzSlk3E3RTNuNa7P5XcPbcIO6RaYirrfbKH
k6Bw5X13DeOcWQCSzj7hMD/8tH1j0bTHRdmtpOSBw14szS+ahFpQgVZ8x2/rjsuh
CLvwpsOKsRL5V14ho3KQV+M8Ji/Fa821w/IbaC4CoBRI3N2GTBD/dbYRd0UX5agP
CL0tkPN7K6DwUI1Yd8Zqqaw9N4T9xi1R8OJEIKv+ERIrn16x7w0gqZVdk1iZ6BVG
a2VFDLGuFinxmk2gWYU/oxAPaI+137r0rARz7HISA3nWaXaMawxzTuwSzZLlB8Wq
q4Rgls6/FgBe79SHsRj1zWCvcq9QtpmDJLhtbD0NkWL1vsht3UoVYTDUnIHYO7Vh
3lTDoAozM1N2EFUQJv4DWrHTQSyHbdrwawn1RNumdWXMeGoEPDsXmPEzdOSkzgud
rNXeyesuRIG5Zer1tvQ0Z1W1TYw1sIpReGrLU3cvnWcVOWN/lRKP/yr/bIRccYiY
4x0/wbR3wGl1MN544IEI0INGjnK8C3UXJrfgONCats8ST1iYjtE=
=30BB
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
