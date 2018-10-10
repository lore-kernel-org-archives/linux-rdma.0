From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 2/3] mm: introduce put_user_page*(), placeholder
 versions
Date: Wed, 10 Oct 2018 16:45:41 -0700
Message-ID: <20181010164541.ec4bf53f5a9e4ba6e5b52a21@linux-foundation.org>
References: <20181008211623.30796-1-jhubbard@nvidia.com>
        <20181008211623.30796-3-jhubbard@nvidia.com>
        <20181008171442.d3b3a1ea07d56c26d813a11e@linux-foundation.org>
        <5198a797-fa34-c859-ff9d-568834a85a83@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5198a797-fa34-c859-ff9d-568834a85a83@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ralph Campbell <rcampbell@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, 9 Oct 2018 17:42:09 -0700 John Hubbard <jhubbard@nvidia.com> wrote:

> > Also, maintainability.  What happens if someone now uses put_page() by
> > mistake?  Kernel fails in some mysterious fashion?  How can we prevent
> > this from occurring as code evolves?  Is there a cheap way of detecting
> > this bug at runtime?
> > 
> 
> It might be possible to do a few run-time checks, such as "does page that came 
> back to put_user_page() have the correct flags?", but it's harder (without 
> having a dedicated page flag) to detect the other direction: "did someone page 
> in a get_user_pages page, to put_page?"
> 
> As Jan said in his reply, converting get_user_pages (and put_user_page) to 
> work with a new data type that wraps struct pages, would solve it, but that's
> an awfully large change. Still...given how much of a mess this can turn into 
> if it's wrong, I wonder if it's worth it--maybe? 

This is a real worry.  If someone uses a mistaken put_page() then how
will that bug manifest at runtime?  Under what set of circumstances
will the kernel trigger the bug?

(btw, please cc me on all patches, not just [0/n]!)
