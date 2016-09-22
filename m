From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 0/9] Export vendors specific ABIs
Date: Thu, 22 Sep 2016 19:09:24 +0300
Message-ID: <20160922160924.GI4088@leon.nu>
References: <1474554679-21953-1-git-send-email-leon@kernel.org>
 <20160922144716.GA10032@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LYw3s/afESlflPpp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160922144716.GA10032-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--LYw3s/afESlflPpp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 22, 2016 at 07:47:16AM -0700, Christoph Hellwig wrote:
> Hi Leon,
>
> this series look good to me:
>
> Acked-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Thanks, I'm going to pick up your old UAPI redesign series and will
start from there.

>
> Although I would have removed patch 8

I'm not sure about it, but anyway it is separate patch which can be
easily dropped by Doug when he will apply it.

> and add the Kconfig changes to
> each individual driver change instead.

I want logically separate move part and export part of this patch
series.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--LYw3s/afESlflPpp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX5AI0AAoJEORje4g2clind/MP/RqArklyG4OAWkqCfz4cEIrJ
vyNFaVb1fgLQ3CFnCvFeaTxVb5YAUnJpX8XCnheGTHSMNanzTwmE6nwTEQdH6BVQ
ZUwL5MuoVo/VL0Vl42Cp+DfOhOfY8Rxi1yhq3zSM98Fzug7O8/fK9q0B5riF/JG8
s9Q7KwcWRO1f/sDvl9wXPqhr6aRSgbeo5VPuIKnYHvSTeP6uHzFrJoJIC+1u9OqC
+1SCCZXcraCQw21bEyJcI4XLtYumQk4+4OaoeJ7TpVMy7brlFVoOtCMSx7QqocZ3
AaFznGQTCKUa0MWsYGzX5lBOymy7fgHB0Uf6AKuYGrtLPmljrPOIBP9jsCAeDyNp
r3YNWFHPPjB07auojKDXCG9AlVJ57m7B0obqyABltnXc7kIBiLDDvAg68la2SFqp
nV+5obs+wHqSHJ53lm9FiN6ri11rxmumV6q4K9zN53tYcHUD8uFLt0vHPC+fbmAe
v0Bk/CDc47Ii+Gf3E+kN7xyTt3Ee9cVVE0+xvDHu+z6qr3Bw5qyvhMVODuNk0HXf
w/pseNGJ9yZhDhJ9he3OiZLmycOwNCQmiUeTlN3sg30Qm6vLLfC0WS+gtWF79bKn
fnOcIHo4lrpsJsItkSnkKE5KRhBzb6GBsG2jqRPnRG+mp0+pgYkxKKV4Z0+sEq+1
DLjTzszOVyOPjop9kf/v
=Ypn4
-----END PGP SIGNATURE-----

--LYw3s/afESlflPpp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
