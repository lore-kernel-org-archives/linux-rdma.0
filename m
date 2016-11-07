From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] build: Fix build script to use correct cmake cmd
Date: Mon, 7 Nov 2016 16:57:09 -0700
Message-ID: <20161107235709.GF7002@obsidianresearch.com>
References: <20161021172728.27367.86783.stgit@scvm10.sc.intel.com>
 <20161021180523.GA554@obsidianresearch.com>
 <9745f6c7-8d09-8bed-d04c-78f610330ead@redhat.com>
 <20161021193034.GA616@obsidianresearch.com>
 <20161025101200.GP25013@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161025101200.GP25013-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 25, 2016 at 01:12:00PM +0300, Leon Romanovsky wrote:
> > stuff I have - eg should I make it pushable? It is easy to use, but
> > you need to have docker installed.
> 
> I would be happy to get it and be more confident in my local tests.

You can test it out with this commit:

https://github.com/jgunthorpe/rdma-plumbing/commit/ef24b991c949ad4f50614bf6bf549e1cdf841358

It will need some tidying before it can merged, but let me know if it
is useful as-is.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
