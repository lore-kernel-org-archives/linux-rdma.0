From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RDMA PATCH 01/16] i40iw: Fix overflow of region length
Date: Mon, 11 Apr 2016 12:23:24 +0300
Message-ID: <20160411092324.GG20252@leon.nu>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
 <1460046664-552-2-git-send-email-mustafa.ismail@intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gm5TwAJMO0F2iVRz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460046664-552-2-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--gm5TwAJMO0F2iVRz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 07, 2016 at 11:30:49AM -0500, Mustafa Ismail wrote:
> Change region_length to u64 as a region can be > 4GB.

I suppose that you will have a casting warning while setting u64 variable to u32 variable.
$grep -r pbl_depth drivers/infiniband/hw/i40iw/*
drivers/infiniband/hw/i40iw/i40iw_verbs.c:      u32 pbl_depth = 0;
drivers/infiniband/hw/i40iw/i40iw_verbs.c:      pbl_depth = region_length >> 12;

--gm5TwAJMO0F2iVRz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXC20MAAoJEORje4g2clin3XQP/REMxME47AVyk8yS/JUzRxfj
qA7cSch6QFAr36WnnhL72Dsv59eS0/N46QLESjr0RBUWQKNaHwHUqsjpoNrrTv9Q
9AjyMabwLEuMffCb35aXl9HO5/ci4FH+f+qm/3z/ek+0TXF+iwlZnmKaSe1IFUIb
UhncqWfc30Brkqa6fgn+urJOVDxjUXn2tRZgv1MsRDQx+FwnKcj7kzd2ruRYkr6V
q7Mtci/ZsQ3g4h5d7kmHgu9jabahHJzIC65JIR+CHt0yGRc2lLpKZdyuHQvhfq1Z
u8akwMpWyiTlIwZzfwie8wOK9osC0BA17sYx7amYgGSCsKf9KFWEWoDtQtS9Jh+l
9lATi6D71BmIAI78ImRQ9lm5c0hlhrmqEKV8J7KZUdBQtvyuJP9IhPJTyQqXrw9n
/C9+f+H6nOFb+1jbRjynZEHPhNkaxGKd2LvF9CgyrBoBWZspkZ4UC8gs1OaVZkKC
C4mYxtVcBB86Hekf7QrxK3oyrMArbZPIVA0n3YKeiTpTvGeu5W7RIghzBRxb4PmH
iKprq92UE6v31be7nztBLVf2oo+3RG78NRk/3X50BR8IPF+VURIu26krbqG+MvAo
+XlwqjY9qS8fnYgDRVAOiQmI4bj8Zl4E79RzRBRZntpA68b6s/ttAKpBvNheYYhV
+lquaeoNIB+q+3GN0gyT
=8DKu
-----END PGP SIGNATURE-----

--gm5TwAJMO0F2iVRz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
