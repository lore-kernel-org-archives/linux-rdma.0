From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] add a build.sh helper to allow for a one-stop build
Date: Wed, 12 Oct 2016 15:18:45 +0300
Message-ID: <20161012121845.GT9282@leon.nu>
References: <1476113282-19194-1-git-send-email-hch@lst.de>
 <c2d80cd4-74b8-8391-1855-3c666f611d91@acm.org>
 <20161010155949.GA20091@lst.de>
 <ec4f3158-a25d-7cd8-216c-fbec52577e75@acm.org>
 <20161010164758.GB1796@obsidianresearch.com>
 <20161012093015.GS9282@leon.nu>
 <20161012105208.GA9491@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FxsMg9mYBDvYslEH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161012105208.GA9491-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--FxsMg9mYBDvYslEH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 12, 2016 at 12:52:08PM +0200, Christoph Hellwig wrote:
> [full quote deleted, sigh..]
>
> > What do you think about following code, instead of 3 lines above?
> >
> > + mkdir -p "$BUILDDIR"
>
> Fine with me.  Feel free to send an incremental patch.

https://github.com/linux-rdma/rdma-core/pull/17

I'll apply it once travis will finish.

Thanks

--FxsMg9mYBDvYslEH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/iolAAoJEORje4g2clin3BQP/jDh82DGrkp62BxeZt2/TJSv
6AF0adPmDGExkhySeA83Br2kuKK6XxAFmgrxUAttGqeSGOCdxl7LTVOrSwO2V+rs
qHtGl398EDcPltAs1i91sTbyJc/jFV56hCp5BM0ff2LShOgYTgXTqVTyCP+5eshH
OWLFX/Ooud4bv/aP1yGRbsd/a6p6DyDldVRBIcbMmrsWIZY1kn1OYWovyw/rXmyJ
FpnDfHDkg5eSDK+FvXme0O/0BXuqWrOKRKVTzgKAoHctvaFuD2GCwi1ZeIX/Jofk
LbO0cXE7N87AAt/SYm97Linwg75w6ptRtCESMdM5cDewERxULG/NJKQeNTHUH3Mk
yzqQFPO7iDcoqP3yzlwjfohcUom+dagjnbQeiqmqFHXT3UGy9TNW86dP+VD5QvCs
FqXFiA3LY/yOyWRlWPTvKQy4lln5BVEAJffTsxsrU0YxY4OqjlABbyil3CkN8tU3
9KSn02oq1CGCBoLzRRhlpE8ivHOrI5uzFw1HCV7gwfrI2DiNz7n3U8DgZTmEV73J
9G7s5gj4ZSXht73ibICPbB67a4KKc1G5WGx6i4YF+4iSiTFTEe1OQqboKIbELMkD
j7+iWbn2WkvCoXUnCv4NNuZOs0kAbFs1wB9blzT8F9tGOHBwFYVC/ZT28w8ODXBm
KOmZppeznjH5IBYrfyGr
=+MAp
-----END PGP SIGNATURE-----

--FxsMg9mYBDvYslEH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
