From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 00/13] dax: fix dma vs truncate and remove
	'page-less' support
Date: Fri, 20 Oct 2017 09:47:50 +0200
Message-ID: <20171020074750.GA13568@lst.de>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Paul Mackerras <paulus@samba.org>, Sean Hefty <sean.hefty@intel.com>, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Jeff Moyer <jmoyer@redhat.com>, hch@lst.de, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Darri
List-Id: linux-rdma@vger.kernel.org

> The solution presented is not pretty. It creates a stream of leases, one
> for each get_user_pages() invocation, and polls page reference counts
> until DMA stops. We're missing a reliable way to not only trap the
> DMA-idle event, but also block new references being taken on pages while
> truncate is allowed to progress. "[PATCH v3 12/13] dax: handle truncate of
> dma-busy pages" presents other options considered, and notes that this
> solution can only be viewed as a stop-gap.

I'd like to brainstorm how we can do something better.

How about:

If we hit a page with an elevated refcount in truncate / hole puch
etc for a DAX file system we do not free the blocks in the file system,
but add it to the extent busy list.  We mark the page as delayed
free (e.g. page flag?) so that when it finally hits refcount zero we
call back into the file system to remove it from the busy list.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
