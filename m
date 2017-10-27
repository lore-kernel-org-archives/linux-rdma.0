From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Fri, 27 Oct 2017 22:36:01 +0300
Message-ID: <20171027193601.GI16127@mtr-leonro.local>
References: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
 <70843f43-03c5-8295-643a-4f228ff2e907@intel.com>
 <0c92fc8e-ecb8-c7ed-0b4c-721752297222@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vDpvzslK0qRw06MN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0c92fc8e-ecb8-c7ed-0b4c-721752297222-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vDpvzslK0qRw06MN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 27, 2017 at 09:34:18AM +0200, SF Markus Elfring wrote:
> >> Add a jump target so that a bit of exception handling can be better reused
> >> at the end of this function.
> >
> > I'm not sure this is that big of a win.
>
> Such a view is appropriate because I proposed just another small adjustment
> for this source code place.
>
>
> > I mean you aren't really making the code any smaller
>
> Would anybody like to check corresponding effects in more detail
> after a specific function call was replaced by a goto statement?

You are supposed to do it and not "anybody".

>
>
> > and it's not making it any easier to read really.
>
> Is the code readability still good enough there?
>
> Regards,
> Markus

--vDpvzslK0qRw06MN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnziqEACgkQ5GN7iDZy
WKdWTA/+MMsKqNd77Wykm8CMkNYUVweMSGCNOvJV1p32uNEbDBzb70kydAgqeHjn
/v+J/7Z1C81Du6KxmHAgdeUrH8D7fU0rG56Re1dY8YstC+NJ3nYPpRN4/frByirx
60NCZN3JmeiVw4T5FftNGPYI27kSS0s2rF49wzP9zvM/4151DmL4xffMffw6rIsH
dHhx3BPBCLvNUGPnXTQLUQpfTsFREfBMnCKPi0ivc1iaSKI8MZz9eHfdJ2W2EpEH
w3Yb+qrGHmTb+xuMPiammJnqSa4K8zFr5M8dAhHQ3bJSZ3/b7r0QvAuuy3YsCBa7
Zx5Igi8EAuYRhTDZMzhKlat2ujITzEgQK+9FAyNyyemUch3Z20TZZkLS86/5JCaX
McwPW0Wj0yCr4yywQBPOOnUJs6CQIRv31jOr+fMIVXeVVSc5U0f148z4c643sgrF
xCdDZuwzcsL56ruaHcdrsxiYQmxku+MxRq6rFtPKIpnobXyzePz94Ns98bbME1WP
cHqGzWuT9AohpBe1DnVkuBoPkUcfcaN9xIpqbAZ8r8ockE9da/qC9iLmk/BcV2Co
4AzAW+9YMCvxaHzqTUeaS1JxmuV7pTNdUFTlS3a5JHixzcq7vgH7nqzPtbUZOI7J
c7IwpL2KpMcnFFlWwhFEhCb+9yHvkZXE3ieLX2w/Pb/TL2Pd1+M=
=kX59
-----END PGP SIGNATURE-----

--vDpvzslK0qRw06MN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
