From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: small patches to librdmacm
Date: Wed, 23 Aug 2017 09:37:28 -0600
Message-ID: <20170823153728.GB22775@obsidianresearch.com>
References: <C50D9A8A-457A-4DA6-B727-43B77117ED15@lanl.gov>
 <20170823042927.GH1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170823042927.GH1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 23, 2017 at 07:29:27AM +0300, Leon Romanovsky wrote:
> On Tue, Aug 22, 2017 at 01:47:18PM -0600, Jeff Inman wrote:
> > Hi folks,
> >
> > I’m new to this.  Please let me know, if you need a different format, etc.
> 
> Yes,
> 
> 1. Please send them with git send-email command, so they will be
> threaded together.
> 
> 2. The commit messages should include description and you already have it
> here, just copy/paste to the commit message itself.
> 
> 3. Fixes lines should be in the kernel format and not hand-made as it is now.
> The following git alias in your .gitconfig can create the proper Fixes line for the
> specific hash.
> 
> [alias]
> 	fixes = log --abbrev=12 -1 --format='Fixes: %h (\"%s\")'
> 
> For example: git fixes ac3a949fb2f in the kernel will produce:
> Fixes: ac3a949fb2ff ("IB/CM: Set appropriate slid and dlid when handling CM request")
> 
> 4. No extra space between Fixes and your Signed-off-by signature.
> 
> 5. Don't forget to add Sean's acked-by.
> 
> Hope to see it merged.

Since we are so close to a release I made all the required changes and
sent a PR:

https://github.com/linux-rdma/rdma-core/pull/187

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
