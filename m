From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: small patches to librdmacm
Date: Wed, 23 Aug 2017 10:45:33 -0600
Message-ID: <20170823164533.GA23928@obsidianresearch.com>
References: <C50D9A8A-457A-4DA6-B727-43B77117ED15@lanl.gov>
 <20170823042927.GH1724@mtr-leonro.local>
 <20170823153728.GB22775@obsidianresearch.com>
 <20170823163217.GU1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170823163217.GU1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 23, 2017 at 07:32:17PM +0300, Leon Romanovsky wrote:

> The commit sha1 should be 12 digits and not 7 digits.

The github gui truncates to 7 digits when it detects a hash, the
commit message has 12.

commit 39a612257aacd77ed5bdd506968cf4e54bbe63b3
Author: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
Date:   Tue Aug 22 15:59:42 2017 -0600

    rsockets: Fix segfaults when rs is not found in the index
    
    Check for null each time the rs is accessed and return an error code.
    
    Fixes: 0b6aff48ce31 ("librdmacm: Define streaming over RDMA interface (rsockets)")
    Fixes: bb9fcba81acd ("rsocket: Add APIs for direct data placement")
    Signed-off-by: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
    Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

commit 5ac0576d51ddfb9207e5632c71d27d14b3368143
Author: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
Date:   Tue Aug 22 15:59:18 2017 -0600

    rsockets: Fix a race-condition in rs_free()
    
    If rs_free() releases the fd before calling rs_remove(), a second thread in
    rsocket() may acquire the same fd and store its own rs in the corresponding
    index-element.  When the first thread then gets around to calling
    rs_remove() it ends up removing the rs of the second thread, and storing a
    NULL there.
    
    Several functions still do not check for NULL after retrieving an rs from
    the index for an open rsocket.  Thus, the second thread would get a
    segfault in any of the following functions: rrecv, rrecvfrom, rsend,
    rsendto, rsendv, riomap, riounmap, riowrite.
    
    Fixes: cf7aae3d0cc4 ("rsocket: Index map item is cleaned before it is used in iomapping cleanup")
    Signed-off-by: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
    Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
