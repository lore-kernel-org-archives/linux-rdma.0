From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 00/12] Fold status in error code
Date: Thu, 7 Jul 2011 12:20:18 -0500
Message-ID: <20110707172018.GA10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The firmware command handling in mthca looks like
	err = mthca_FOO(..., &status);
	if (err) ...
	if (status) ...

Most of the time where status matters, a non-OK status message translates to
-EINVAL err.

This patchset folds the status in error code, so that we don't need to repeat
error handling code, and yet the type of error is communicated to the calling
functions.

This is in parallel to mlx4 code by Roland. The patches were broken per-file
basis, and all 12 patches are required before you can compile the module.


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
