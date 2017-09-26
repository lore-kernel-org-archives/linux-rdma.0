From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Tue, 26 Sep 2017 20:49:46 +0300
Message-ID: <20170926174946.GA1218@mtr-leonro.local>
References: <20170926140714.18110.74689.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170926140714.18110.74689.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Scott Franco <safranco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Niranjana Vishwanathapura <Niranjana.Vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 07:08:37AM -0700, Dennis Dalessandro wrote:
> Hi Doug,
>
> Here are the other two patches for opa_vnic. This adds a debugfs interface and
> that is why I'm sending it as a separate series apart from the rest of our
> submissions. The goal is to support view/modify of the VESW port config.
>
> Patches can can also be found in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.15
>
> ---

Can you elaborate more on the reasons why debugfs was chosen over more
generic configuration tool?

+DEBUGFS_FILE_OPS(vport_state);

Maybe, I'm too biased with rdmatool, but I don't see many reasons to
introduce debugfs for the ULP.

Thanks

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnKkxUACgkQ5GN7iDZy
WKeDxRAAnQlvFZEmaRNgoyEELItXo6D45DR084v+3UE8YpPa/Lvu2W2vrz+nsoqT
P27NHYSQKcfg/mM6h5IqO64nxc8OpRlWA8dQCz+E4JbuBzzb47EJSIlwqX+689OS
WDJRIhyO6cWrs3zMfTQ4u5lcRNTNI+NSKq/Ka0tAWikW3JzFLJYrOCS2CDPuCmkr
Y4ZQroJsxtWDzoB89I9x1H95/WtqTr699sL3W65PN6IcL6Ctl0mTIRCj5vaXStvu
xqgaydk5R32hP4Rt3h3DYidrDrcjQfABXMFv9eEpfLiY/TF2+jqKIEnoePbpkTfl
lfBwBeM2JNZIAEi64C0LvUkWPb2Z8SICoedTIE6rELqZGzu5Nffli99HERRtNpag
LVn+MLS/xl++boODe3rEFyqnRyzqbWq/S4h1bMOz6GwdmBLsYqEoiOIUMIdoudFq
xONaqGt7wfBrKGDp5T5y3v08evKTbhIp1icA18XonQqNCQG51fFGDT8YyrjNUTXZ
mG6WWyTH+nM6nBjG0CPGDUQfWQPBzUI2MWi6MCLJVvwAeZcUQFol0f6qGLzkJuo4
+6fXRgY3DKCSjVQBCYrh/BZ/rFDD4ozvwMft8io15zezGLdTJrcFTRnuvBOaC+hs
Lnk1RST5xiaeyP6yOnPQ1pQ844QdzPFcgVYamPJGuBWCi91suio=
=RHmj
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
