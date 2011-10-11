From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Building 3.1-rc9 in kernel infiniband support with OFED
 libraries
Date: Tue, 11 Oct 2011 11:39:29 -0600
Message-ID: <20111011173929.GH26965@obsidianresearch.com>
References: <alpine.DEB.2.00.1110110900290.3388@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110110900290.3388-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 11, 2011 at 09:02:41AM -0500, Christoph Lameter wrote:

> Has XRC support not been merged? How can I build the OFED libraries
> against Linux 3.1? I'd really like to get rid of the OFED kernel tree
> nightmare.

You have to use upstream libraries with upstream kernels. Be warned
that the OFED libraries of the same SONAME are not ABI compatible with
upstream libraries.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
