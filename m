From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core: =?utf-8?B?4oCLbGliaWJ1bWE=?= =?utf-8?Q?d?= symbols
 version downgrade
Date: Wed, 19 Apr 2017 09:36:56 -0600
Message-ID: <20170419153656.GB29293@obsidianresearch.com>
References: <1492538111.18372.1.camel@profitbricks.com>
 <20170419100430.GI14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170419100430.GI14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 19, 2017 at 01:04:30PM +0300, Leon Romanovsky wrote:
> On Tue, Apr 18, 2017 at 07:55:11PM +0200, Benjamin Drung wrote:
> > Hi,
> >
> > while reviewing the Debian packaging changes from libibumad
> > 1.3.10.2-2 to rdma-core, I stumbled over the symbols version.
> > libibumad 1.3.10.2 ships libibumad.so.3.1.0, but rdma-core
> > ships libibumad.so.3.0.14 which is lower. Is that intentional?

It was intentional:

commit 232796a623f28bd205d15acac44bb007b8fc64be
Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date:   Mon Jan 30 11:04:21 2017 -0700

    Fix shared library filenames
    
    We expect the filename to reflect the symbol versions in the file,
    this means, eg libibverbs1.3 should have the IBVERBS_1.3 as the newest
    symbol. The same applies to all libraries.
    
    verbs was not updated in commit 3ca7a103148 when new symbols were added
    
    umad/rdmacm probably legitimately had a '.1' someday, but failed to
    follow symver convention. Bump it back down.
    
    Since distros are not using it in packaging the shared library version
    and filename is no longer used by anything. We simply want it to follow
    our own internal conventions.
    
    Fixes: 3ca7a1031486 ("ibverbs: Add support for packet pacing")
    Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
