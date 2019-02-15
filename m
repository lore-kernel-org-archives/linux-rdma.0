From: Christopher Lameter <cl@linux.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving longterm-GUP
 usage by RDMA
Date: Fri, 15 Feb 2019 15:42:02 +0000
Message-ID: <01000168f1d25e3a-2857236c-a7cc-44b8-a5f3-f51c2cfe6ce4-000000@email.amazonses.com>
References: <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com> <20190208044302.GA20493@dastard> <20190208111028.GD6353@quack2.suse.cz> <CAPcyv4iVtBfO8zWZU3LZXLqv-dha1NSG+2+7MvgNy9TibCy4Cw@mail.gmail.com> <20190211102402.GF19029@quack2.suse.cz>
 <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com> <20190211180654.GB24692@ziepe.ca> <20190214202622.GB3420@redhat.com> <20190214205049.GC12668@bombadil.infradead.org> <20190214213922.GD3420@redhat.com> <20190215011921.GS20493@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190215011921.GS20493@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jerome Glisse <jglisse@redhat.com>, Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 15 Feb 2019, Dave Chinner wrote:

> Which tells us filesystem people that the applications are doing
> something that _will_ cause data corruption and hence not to spend
> any time triaging data corruption reports because it's not a
> filesystem bug that caused it.
>
> See open(2):
>
> 	Applications should avoid mixing O_DIRECT and normal I/O to
> 	the same file, and especially to overlapping byte regions in
> 	the same file.  Even when the filesystem correctly handles
> 	the coherency issues in this situation, overall I/O
> 	throughput is likely to be slower than using either mode
> 	alone.  Likewise, applications should avoid mixing mmap(2)
> 	of files with direct I/O to the same files.

Since RDMA is something similar: Can we say that a file that is used for
RDMA should not use the page cache?

And can we enforce this in the future? I.e. have some file state that says
that this file is direct/RDMA or contains long term pinning and thus
allows only a certain type of operations to ensure data consistency?

If we cannot enforce it then we may want to spit out some warning?
