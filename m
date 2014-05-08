From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V3 3/3] Add ibv_query_port_ex support
Date: Thu, 8 May 2014 13:47:48 -0600
Message-ID: <20140508194748.GA31389@obsidianresearch.com>
References: <1399531883-30599-1-git-send-email-ogerlitz@mellanox.com>
 <1399531883-30599-4-git-send-email-ogerlitz@mellanox.com>
 <20140508190951.GB25849@obsidianresearch.com>
 <alpine.DEB.2.10.1405081439370.26267@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405081439370.26267-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 08, 2014 at 02:40:44PM -0500, Christoph Lameter wrote:
> On Thu, 8 May 2014, Jason Gunthorpe wrote:
> 
> > Anonymous struct/union is a C11 feature and GNU extension. I don't
> > think is appropriate for a user library to rely on. We cannot assume
> > the user is has a compiler in C11 mode.
> 
> Anonymous structs/union are used in the kernel already. See
> include/linux/mm_types.h f.e.

Re-read: This is a userspace header.

mm_types.h is never included by a userspace program, so it doesn't
matter.

Find something in include/uapi and we'll talk :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
