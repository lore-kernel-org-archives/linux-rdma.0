From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/ucma: check fd type in ucma_migrate_id()
Date: Tue, 4 Sep 2018 15:24:25 -0600
Message-ID: <20180904212425.GD18686@ziepe.ca>
References: <20180903165414.248309-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180903165414.248309-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 03, 2018 at 06:54:14PM +0200, Jann Horn wrote:
> The current code grabs the private_data of whatever file descriptor
> userspace has supplied and implicitly casts it to a `struct ucma_file *`,
> potentially causing a type confusion.
> 
> This is probably fine in practice because the pointer is only used for
> comparisons, it is never actually dereferenced; and even in the
> comparisons, it is unlikely that a file from another filesystem would have
> a ->private_data pointer that happens to also be valid in this context.
> But ->private_data is not always guaranteed to be a valid pointer to an
> object owned by the file's filesystem; for example, some filesystems just
> cram numbers in there.
> 
> Check the type of the supplied file descriptor to be safe, analogous to how
> other places in the kernel do it.
> 
> Fixes: 88314e4dda1e ("RDMA/cma: add support for rdma_migrate_id()")
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> Only compile-tested, because I don't have an environment in which I
> could test this.
> 
>  drivers/infiniband/core/ucma.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Yep, this looks right to me also, applied to for-rc, thanks

Jason
