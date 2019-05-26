From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] infiniband/mm: convert put_page() to put_user_page*()
Date: Sun, 26 May 2019 04:30:43 -0700
Message-ID: <20190526113043.GA3518@infradead.org>
References: <20190525014522.8042-1-jhubbard@nvidia.com>
 <20190525014522.8042-2-jhubbard@nvidia.com>
 <20190526110631.GD1075@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190526110631.GD1075@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 26, 2019 at 04:06:31AM -0700, Matthew Wilcox wrote:
> I thought we agreed at LSFMM that the future is a new get_user_bvec()
> / put_user_bvec().  This is largely going to touch the same places as
> step 2 in your list above.  Is it worth doing step 2?
> 
> One of the advantages of put_user_bvec() is that it would be quite easy
> to miss a conversion from put_page() to put_user_page(), but it'll be
> a type error to miss a conversion from put_page() to put_user_bvec().

FYI, I've got a prototype for get_user_pages_bvec.  I'll post a RFC
series in a few days.
