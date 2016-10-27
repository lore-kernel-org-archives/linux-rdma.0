From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] Avoid possible hang on device removal
Date: Thu, 27 Oct 2016 10:29:54 +0300
Message-ID: <20161027072954.GD3617@leon.nu>
References: <1477438557-15884-1-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477438557-15884-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 25, 2016 at 06:35:57PM -0500, Mustafa Ismail wrote:
> When we get an RDMA_CM_EVENT_DEVICE_REMOVAL the cm_thread will
> exit and because flush errors are ignored the cb->sem may not get signaled.
> So just signal on device removal event.
>
> v1 -> v2: Add Fixes tag
>
> Fixes: 612eae1f6fe3 ("rping: ignore flushed completions")
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  librdmacm/examples/rping.c | 2 ++
>  1 file changed, 2 insertions(+)

Mustafa,

For future submissions, please use rdma-core notation in [PATCH ..]
section, so we will be able to handle them faster.

Thanks

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYEazyAAoJEORje4g2clinICcQAIOu+60PGix23mPpo6RzTP8e
+WCj7kucwLP2P3xPTHBTDgxaC/bTTI5cSYLYBleTjDOihVqoFd5JCnTCjcptCg5e
lVhuzUHv7x9sNW59LDwxwIISMDvK5gKnXL6YI8ji9NOHQQoeo98Qkfnh+MQDxuPr
fsoU6PQ+h5r11SU3+CcTsV+7NmCk3MRjjNMro5+jPuF0JO0GPz3yYElhOSJ4Md+5
J0Z4HOlHNDmXasjYZMYOWrJhqsk+lNR7uMBS9BvCktJiTLSBa5nFXJXphyhYj7gt
2PZDjK+zNwXxWEPoTw7Dg3PaAzl1WX2bnLnAmrjKnoOXod4Be1soL6miitdYmbFv
GVe+gIulsUUR7zugoCMi6ulka8jOkUW50Ab/pG9btPJ4wchdEhut0CvYzaCFXjhj
UhS7eO/CXGLxkE/6HPjU7YEOS2Ju9ru55BfAOd9HMHfc4zjyc5eBoYJDFGkduepB
qlNRocjNIbQJfo3OoapN9C2Z84CVXyaQEm2I1bruvaEurKqC0ydRCs4JkAQGQD6/
+mojmvNlr2PM5VLVLnma+PovL8yZyAS+VvYakA9jNjKPO2k8SlMrumiYVJBTEKbz
GbRD/TWmL2MO+LKtFTkvl6ms/7mRhmBFBS7LYhYREFOFdJtiWMTSdf0kbeufrzMZ
7D7G0GJ/RM2MSP7RfKD0
=rRbu
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
