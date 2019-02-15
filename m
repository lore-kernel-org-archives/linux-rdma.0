From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Fri, 15 Feb 2019 10:08:52 -0800
Message-ID: <20190215180852.GJ12668@bombadil.infradead.org>
References: <20190208111028.GD6353@quack2.suse.cz>
 <CAPcyv4iVtBfO8zWZU3LZXLqv-dha1NSG+2+7MvgNy9TibCy4Cw@mail.gmail.com>
 <20190211102402.GF19029@quack2.suse.cz>
 <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com>
 <20190211180654.GB24692@ziepe.ca>
 <20190214202622.GB3420@redhat.com>
 <20190214205049.GC12668@bombadil.infradead.org>
 <20190214213922.GD3420@redhat.com>
 <20190215011921.GS20493@dastard>
 <01000168f1d25e3a-2857236c-a7cc-44b8-a5f3-f51c2cfe6ce4-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01000168f1d25e3a-2857236c-a7cc-44b8-a5f3-f51c2cfe6ce4-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Dave Chinner <david@fromorbit.com>, Jerome Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 15, 2019 at 03:42:02PM +0000, Christopher Lameter wrote:
> On Fri, 15 Feb 2019, Dave Chinner wrote:
> 
> > Which tells us filesystem people that the applications are doing
> > something that _will_ cause data corruption and hence not to spend
> > any time triaging data corruption reports because it's not a
> > filesystem bug that caused it.
> >
> > See open(2):
> >
> > 	Applications should avoid mixing O_DIRECT and normal I/O to
> > 	the same file, and especially to overlapping byte regions in
> > 	the same file.  Even when the filesystem correctly handles
> > 	the coherency issues in this situation, overall I/O
> > 	throughput is likely to be slower than using either mode
> > 	alone.  Likewise, applications should avoid mixing mmap(2)
> > 	of files with direct I/O to the same files.
> 
> Since RDMA is something similar: Can we say that a file that is used for
> RDMA should not use the page cache?

That makes no sense.  The page cache is the standard synchronisation point
for filesystems and processes.  The only problems come in for the things
which bypass the page cache like O_DIRECT and DAX.
