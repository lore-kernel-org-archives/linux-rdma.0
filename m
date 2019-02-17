From: Christopher Lameter <cl@linux.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving longterm-GUP
 usage by RDMA
Date: Sun, 17 Feb 2019 02:54:31 +0000
Message-ID: <01000168f96067cc-053f7689-8362-49c5-85b6-3fe23ac7d4f4-000000@email.amazonses.com>
References: <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com> <20190211180654.GB24692@ziepe.ca> <20190214202622.GB3420@redhat.com> <20190214205049.GC12668@bombadil.infradead.org> <20190214213922.GD3420@redhat.com> <20190215011921.GS20493@dastard>
 <01000168f1d25e3a-2857236c-a7cc-44b8-a5f3-f51c2cfe6ce4-000000@email.amazonses.com> <20190215180852.GJ12668@bombadil.infradead.org> <01000168f26d9e0c-aef3255a-5059-4657-b241-dae66663bbea-000000@email.amazonses.com> <20190215220031.GB8001@ziepe.ca>
 <20190215233828.GB30818@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190215233828.GB30818@iweiny-DESK2.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Doug Ledford <dledford@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 15 Feb 2019, Ira Weiny wrote:

> > > > for filesystems and processes.  The only problems come in for the things
> > > > which bypass the page cache like O_DIRECT and DAX.
> > >
> > > It makes a lot of sense since the filesystems play COW etc games with the
> > > pages and RDMA is very much like O_DIRECT in that the pages are modified
> > > directly under I/O. It also bypasses the page cache in case you have
> > > not noticed yet.
> >
> > It is quite different, O_DIRECT modifies the physical blocks on the
> > storage, bypassing the memory copy.
> >
>
> Really?  I thought O_DIRECT allowed the block drivers to write to/from user
> space buffers.  But the _storage_ was still under the control of the block
> drivers?

It depends on what you see as the modification target. O_DIRECT uses
memory as a target and source like RDMA. The block device is at the other
end of the handling.

> > RDMA modifies the memory copy.
> >
> > pages are necessary to do RDMA, and those pages have to be flushed to
> > disk.. So I'm not seeing how it can be disconnected from the page
> > cache?
>
> I don't disagree with this.

RDMA does direct access to memory. If that memmory is a mmmap of a regular
block  device then we have a problem (this has not been a standard use case to my
knowledge). The semantics are simmply different. RDMA expects memory to be
pinned and always to be able to read and write from it. The block
device/filesystem expects memory access to be controllable via the page
permission. In particular access to be page need to be able to be stopped.

This is fundamentally incompatible. RDMA access to such an mmapped section
must preserve the RDMA semantics while the pinning is done and can only
provide the access control after RDMA is finished. Pages in the RDMA range
cannot be handled like normal page cache pages.

This is in particular evident in the DAX case in which we have direct pass
through even to the storage medium. And in this case write through can
replace the page cache.
