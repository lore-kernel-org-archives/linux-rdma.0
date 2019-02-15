From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Fri, 15 Feb 2019 15:00:31 -0700
Message-ID: <20190215220031.GB8001@ziepe.ca>
References: <20190211102402.GF19029@quack2.suse.cz>
 <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com>
 <20190211180654.GB24692@ziepe.ca>
 <20190214202622.GB3420@redhat.com>
 <20190214205049.GC12668@bombadil.infradead.org>
 <20190214213922.GD3420@redhat.com>
 <20190215011921.GS20493@dastard>
 <01000168f1d25e3a-2857236c-a7cc-44b8-a5f3-f51c2cfe6ce4-000000@email.amazonses.com>
 <20190215180852.GJ12668@bombadil.infradead.org>
 <01000168f26d9e0c-aef3255a-5059-4657-b241-dae66663bbea-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01000168f26d9e0c-aef3255a-5059-4657-b241-dae66663bbea-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 15, 2019 at 06:31:36PM +0000, Christopher Lameter wrote:
> On Fri, 15 Feb 2019, Matthew Wilcox wrote:
> 
> > > Since RDMA is something similar: Can we say that a file that is used for
> > > RDMA should not use the page cache?
> >
> > That makes no sense.  The page cache is the standard synchronisation point
> > for filesystems and processes.  The only problems come in for the things
> > which bypass the page cache like O_DIRECT and DAX.
> 
> It makes a lot of sense since the filesystems play COW etc games with the
> pages and RDMA is very much like O_DIRECT in that the pages are modified
> directly under I/O. It also bypasses the page cache in case you have
> not noticed yet.

It is quite different, O_DIRECT modifies the physical blocks on the
storage, bypassing the memory copy. RDMA modifies the memory copy.

pages are necessary to do RDMA, and those pages have to be flushed to
disk.. So I'm not seeing how it can be disconnected from the page
cache?

Jason
