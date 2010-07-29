From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 2/4] uverbs: Add common ib_iomem_get service
Date: Thu, 29 Jul 2010 14:13:17 -0600
Message-ID: <20100729201317.GA7920@obsidianresearch.com>
References: <20100729162339.14674.15788.stgit@build.ogc.int> <20100729162509.14674.34237.stgit@build.ogc.int> <1280427723.6820.56.camel@chromite.mv.qlogic.com> <4C51D15F.8060708@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C51D15F.8060708-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>, "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org" <brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, "swise-/Yg/VP3ZvrM@public.gmane.org" <swise-/Yg/VP3ZvrM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 29, 2010 at 02:07:11PM -0500, Tom Tucker wrote:
>>> Add an ib_iomem_get service that converts a vma to an array of
>>> physical addresses. This makes it easier for each device driver to
>>> add support for the reg_io_mr provider method.

Tom, could you say a few words on what this is for?

Also, I'd like to see a strong defence of this new user space API
particularly:
 1) Why can't this be done with the existing ibv_reg_mr, like huge
    pages are.
 2) How is it possible for userspace to know when it should use
    ibv_reg_mr vs ibv_reg_io_mr?
 3) Why can't ibv_dereg_io_mr be entirely handled by ibv_dereg_mr?

On first glance, this seems like a hugely bad API to me :)

Also, if new user space APIs are really needed, they do need man pages
too ...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
