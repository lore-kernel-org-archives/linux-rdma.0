From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
Date: Fri, 23 Sep 2016 09:24:12 -0600
Message-ID: <20160923152412.GB11269@obsidianresearch.com>
References: <20160923041340.GA11269@obsidianresearch.com>
 <20160923080655.GM4088@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160923080655.GM4088-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 23, 2016 at 11:06:55AM +0300, Leon Romanovsky wrote:
> On Thu, Sep 22, 2016 at 10:13:40PM -0600, Jason Gunthorpe wrote:
> > Upon deeper analysis it seems there are two variations of the 'OpenIB.org BSD
> > license', I am calling them the MIT and FreeBSD variants. They differ only in
> > the text of the disclaimer. The MIT version is used widely as the source
> > license so that version should be the 'default' in the source tree, not the
> > FreeBSD version I had selected initially.
> >
> > Retain the FreeBSD version as we will refer to it in future commits.
> >
> > Elaborate the COPYING file to discuss the license situation in
> > more depth.
> 
> I doubt that we have appropriate knowledge to come into meaningful
> conclusion after "discussion". It is legal issue which should be
> handled by relevant legal departments.

Hi Leon,

I think the commit message was not clear, let me try again:

[PATCH] Document copyright situation and select default license

This patch is not intended to change the copyright or license
situation of any of the original code.

Documentation is provided that identifies the various licenses we
have in the source tree.

The default license for new items after the 'Initial commit' merge is
corrected to match the majority license already in use. This is the
license we recommend all new code use. This corrects a mistake I made
in the 'Unified CMake build system' patch which selected the wrong
license file.

Also provide specific guidance on how the 18 different COPYING files
and per-file copyright headers are intended to be interpreted
within the merged tree.

=======

As you know I've sent emails to various parties on licensing issues,
as those issues are corrected we can update the tree and the copying
summary.

We've already had success correcting one mistake from Intel and
Chelsio, thank you very much to those companies.

It is important we clearly document the current situation so our
downstreams can properly distribute this code.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
