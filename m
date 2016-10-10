From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Add Quality of Service support
Date: Mon, 10 Oct 2016 07:27:10 +0300
Message-ID: <20161010042710.GH9282@leon.nu>
References: <20161007204747.6420-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jOtImjXIA9XXnHrK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161007204747.6420-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--jOtImjXIA9XXnHrK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 07, 2016 at 03:47:47PM -0500, Henry Orosco wrote:

<...>

>
>  	switch (iwdev->init_state) {
>  	case RDMA_DEV_REGISTERED:
> @@ -1628,6 +1642,7 @@ static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
>  		iwdev->init_state = RDMA_DEV_REGISTERED;
>  		iwdev->iw_status = 1;
>  		i40iw_port_ibevent(iwdev);
> +		iwdev->param_wq = create_singlethread_workqueue("l2params");
>  		i40iw_pr_info("i40iw_open completed\n");

No, please don't use this interface, For reference, see latest work from Bhaktipriya
Shridhar to eliminate this call. Doug and Dave sent a pull request with it to Linus in
last merge cycle.

Also, 1) you should check if this call succeeded and 2) ask yourself if
special workqueue is needed.

>  		return 0;
>  	} while (0);

Thanks.

--jOtImjXIA9XXnHrK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+xieAAoJEORje4g2clin+9YP/ijOEgIkdmxVJT/XEjmBDXEO
c7LIf5OdT3s6dVzKwnMU+/omMNny/j2x/Knjk/DdWqa2jW/HCMBHEQsymQYoHOK8
XZuskIOe8+H2ywZ1mgWunGNIM0QpcRB6QfacXCe+5qdbRqV8oyMdI8iGK0NgbGb2
w54EkDlK/z9Qpzzn2qmpZHdvULbmZDoEJ9vL2+zT3B6UNXR65T6xFFJlGKsX3YGx
bKuxkdz/hGNaQe7c0wR8dA4I0C/PkspfyIDFuv+tx1i7KcLx499Rc9Dk3HMJRCMq
GURWTokWU+CKwyT2Wt0itZT53z/NEmYl33kAKwRsfsFZ824+QueajstOmviu0FbW
T9XkL5naytYtOFG6f2EYCljggTehlh5swUxzPPaG/p3epmpL9iax7UX5qy5DsmAY
0Sx5U/LsNp0xfLETTtb7ls+EzTudopfs4CNSSoVG0tbJAgu85fNo/51ouXmt8y5t
hHxvT4a5eyy6nQen5ikv61yzPizupiNv2c44PkTGsnns825j8BK+r2Z4C0Gt+0GH
wzAVkTPjvtt1aeMFW2WCGsMCsYdKX+OLzG4nEL+C5cF8rlM0BCYdeGpa9yfrjQSl
IBdt3A9ADNFXEsJMTE/xG6rHsJoM8UEEOxBM7/3LiyDUKvY0Ofuolp/kF7dxu3zZ
LUfTMK2mKyxc/n+x1alw
=yLqj
-----END PGP SIGNATURE-----

--jOtImjXIA9XXnHrK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
