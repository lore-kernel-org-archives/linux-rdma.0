From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/6] IB/uverbs: Enable QP creation which is
 associated to underlay QP
Date: Wed, 31 May 2017 11:39:55 +0300
Message-ID: <20170531083955.GJ5406@mtr-leonro.local>
References: <20170530071602.8139-1-leon@kernel.org>
 <20170530071602.8139-3-leon@kernel.org>
 <20170530073352.GA1838@nanopsycho>
 <20170530075845.GA5406@mtr-leonro.local>
 <20170530081514.GB1838@nanopsycho>
 <20170530172259.GD5406@mtr-leonro.local>
 <20170530180357.GB24898@nanopsycho>
 <20170531042031.GG5406@mtr-leonro.local>
 <20170531053711.GA1882@nanopsycho>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3CAnR4CLEnEWqRMR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170531053711.GA1882@nanopsycho>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3CAnR4CLEnEWqRMR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 31, 2017 at 07:37:11AM +0200, Jiri Pirko wrote:
> Wed, May 31, 2017 at 06:20:31AM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> >On Tue, May 30, 2017 at 08:03:58PM +0200, Jiri Pirko wrote:
> >> Tue, May 30, 2017 at 07:22:59PM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> >> >On Tue, May 30, 2017 at 10:15:14AM +0200, Jiri Pirko wrote:
> >> >> Tue, May 30, 2017 at 09:58:45AM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> >> >> >On Tue, May 30, 2017 at 09:33:52AM +0200, Jiri Pirko wrote:
> >> >> >> Tue, May 30, 2017 at 09:15:58AM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> >> >> >> >From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> >> >> >
> >> >> >> >Enable QP creation which is associated to underlay QP. This comes as a
> >> >> >> >pre-patch for downstream patches in this series to enable flow steering
> >> >> >> >from user space application on the underlay IPoIB QP.
> >> >> >> >
> >> >> >> >Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> >> >> >Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> >> >> >> >Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> >> >> >---
> >> >> >>
> >> >> >> [...]
> >> >> >>
> >> >> >>
> >> >> >> >diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> >> >> >> >index 477d629f539d..422b20456975 100644
> >> >> >> >--- a/include/uapi/rdma/ib_user_verbs.h
> >> >> >> >+++ b/include/uapi/rdma/ib_user_verbs.h
> >> >> >> >@@ -578,7 +578,7 @@ struct ib_uverbs_ex_create_qp {
> >> >> >> > 	__u32 comp_mask;
> >> >> >> > 	__u32 create_flags;
> >> >> >> > 	__u32 rwq_ind_tbl_handle;
> >> >> >> >-	__u32  reserved1;
> >> >> >> >+	__u32  associated_qpn;
> >> >> >>
> >> >> >> This breaks uapi...
> >> >> >
> >> >> >Not really, we are using comp_mask scheme to signal changes/predecessor
> >> >> >of these structs. Users of this file and structs check comp_mask and
> >> >> >access new fields only if they are exposed there.
> >> >> >
> >> >> >In this case, there are no users of reserved1 and hence it can be
> >> >> >replace to the new field with corresponding comp_mask flag (IB_QP_CREATE_ASSOC_QPN)
> >> >> >without worry of breakage.
> >> >>
> >> >> I, as an app could include ib_user_verbs.h and do:
> >> >>
> >> >> struct ib_uverbs_ex_create_qp something;
> >> >>
> >> >> something.reserved1 = 0;
> >> >>
> >> >> Than I won't compile, would I?
> >> >
> >> >You are right, the good thing that in IB world, there is no direct usage
> >> >of these files and they are needed for rdma-core (libibverbs) library.
> >>
> >> Unfortunatelly, that does not make any difference. UAPI is UAPI...
> >
> >Yes, it makes. Changes in UAPI are allowed as long they don't break user
> >space applications. In this case, there are no applications which uses
> >this reserved fields directly.
>
> How do you know? I might have one in my drawer :)

Because, we had this brave man [1] who wanted to implement libibverbs by
himself in GO language and Jason gave a very good explanation [2, 3] why it
is not likely to happen in near future.

[1] http://marc.info/?l=linux-rdma&m=149302796407374&w=2
[2] http://marc.info/?l=linux-rdma&m=149305872017354&w=2
[3] http://marc.info/?l=linux-rdma&m=149314196207011&w=2

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--3CAnR4CLEnEWqRMR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkugVsACgkQ5GN7iDZy
WKf30g//Wq7vv1mQvlPP6aawybtruVQJBBLP6fiBRN3H77356/cXCM2XGgc5AvgO
uAf1IiUoCyNCS+4ZjaE0TngnD7UWsoYQ31fSXXVH1WoANKEqfFgMm6TuazvlAsel
SgYcW31f6LjovEFu6H9bs2hmPn+8JdqwfZCseNAa6YI9Nppd8JNJrn/Q/T8Cza3D
u29fThTMKl1R4RqLrUtydU6vNWgcAO1Fojaas0Q+kvg/bAbrKuFplpfNvFRHAIrf
bRmGwXS3/cPzuzI/mVVtlQ4qDECEjs7EwFekq4QkTPeTn9tmk5rrAkvvL3xVSRi2
/e6gDK18FHoJpQ5UAHhvgMnCWBpr2zCPZII1ldwqcOt2Ld9jxrks5YhXr08ep1Dg
3ZNYOqog1+GHfiE4khggk6sSsNZ/xDb5jiaE1Ua7nUu6hHDlsrxbF6bS79fBOyaA
bUI/ijy6o2qRLpNZ7BMa7C6gQm+6RCw1qR0BdermZyUkgSpTpgHbY9f5NKge6A2G
0eD0zuwGkAaXi1QLSo6VkNuUvo4gV357gvircg2lsBwxNxqGazyH3xwv8jpGm0ot
tzVBFHN38gWprkFvETz+7hs5cSOo1sXMduXeFBH81BSs0Q0sGVCKSufmPYmbWBvT
sLRoZHVD7KLMiyz5t/TIw04BzdqLt3oxaqhAmU/dMncd3pe6JVA=
=OXP+
-----END PGP SIGNATURE-----

--3CAnR4CLEnEWqRMR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
