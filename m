From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/7] IB/core: Fix typo in the name of the
 tag-matching cap struct
Date: Mon, 25 Sep 2017 06:45:38 +0300
Message-ID: <20170925034538.GK25094@mtr-leonro.local>
References: <20170924184635.31948-1-leon@kernel.org>
 <20170924184635.31948-2-leon@kernel.org>
 <20170924201848.GB2029@nanopsycho>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5mZBmBd1ZkdwT1ny"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170924201848.GB2029@nanopsycho>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5mZBmBd1ZkdwT1ny
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 24, 2017 at 10:18:48PM +0200, Jiri Pirko wrote:
> Sun, Sep 24, 2017 at 08:46:29PM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> >From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> >The tag matching functionality is implemented by mlx5 driver
> >by extending XRQ, however this internal kernel information was
> >exposed to user space applications with *xrq* name instead of *tm*.
> >
> >This patch renames *xrq* to *tm* to handle that.
> >
> >Fixes: 8d50505ada72 ("IB/uverbs: Expose XRQ capabilities")
> >Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> [...]
>
> >diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> >index 9a0b6479fe0c..d4e0b53bfc75 100644
> >--- a/include/uapi/rdma/ib_user_verbs.h
> >+++ b/include/uapi/rdma/ib_user_verbs.h
> >@@ -261,7 +261,7 @@ struct ib_uverbs_ex_query_device_resp {
> > 	struct ib_uverbs_rss_caps rss_caps;
> > 	__u32  max_wq_type_rq;
> > 	__u32 raw_packet_caps;
> >-	struct ib_uverbs_tm_caps xrq_caps;
> >+	struct ib_uverbs_tm_caps tm_caps;
>
> Breaks UAPI?

Not really, this UAPI was introduced in latest merge window and
wasn't exposed to users yet. The -rcX rally is the time where such
fixes are supposed to happen.

Thanks

>

--5mZBmBd1ZkdwT1ny
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnIe+EACgkQ5GN7iDZy
WKevnhAAxOvx8ptOj6VF+h1ysiV8t7MFLODiWfDdgnAETpslt//UaWSsXBl+24Lz
gqEWgAqBh8/awhkGkSo9OrlvJKoLvTXH59XFoctstmzruQenwWlRGNZLN/ZG6/nE
qy/xhO7oj41wU8T05tVrl4esQszzSuHtk1HYq+3zqpZH2vNg/RnF5QvWYVGSDamB
fZLlMKI7DNZMPeaPJZC+IT0uP1WkqJWHftcpulNEk3JVyMgXQAXFAmzzA0ZFPfrQ
0ksLpUrlGpZAa2psSi0ZS/gr7fTcdfQP6oMbj1z9cGgfCkQ7dnCcKhVFb+WUJ7P8
Rz8NoinyrVCilB+PAq8B1I4jkAWtikS9nqJT5qo2mE3oGAroIlnmF6O0WYYdLp/L
bwLWlD5gLnUknVYjDP3gX4D4IBgrrTNmc7lbL8Q9zEuXobeeAsVSgPwPAE5PwH2Y
/1ErITclBBrUGdQhUMnsijeqARvu0qaUqPBbPpGDdq/wYOILQJyOAeK4l3AIO2iu
RSCd+ttarz64oaI7zqlurH6dDt10WRzAt+s5VleQkNEeZ0jPxJvwbkSX8+2AZpD8
Fjt66VIcGMDctNcdmfBJWY/pSFRfRCdPzyhQNZDcECsrlO1sYqrw/4G2ln5URZT5
zYrM1E5BqC5+FtmOd/kI9giB1E4VeXmM4KnFE5U5ADYXJqhjaFE=
=yngD
-----END PGP SIGNATURE-----

--5mZBmBd1ZkdwT1ny--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
