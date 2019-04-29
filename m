From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Mon, 29 Apr 2019 08:09:47 +0200
Message-ID: <20190429060947.GB3665@osiris>
References: <20190428115207.GA11924@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190428115207.GA11924@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 28, 2019 at 11:52:12AM +0000, Jason Gunthorpe wrote:
> Hi Linus,
> 
> Third rc pull request
> 
> Nothing particularly special here. There is a small merge conflict
> with Adrea's mm_still_valid patches which is resolved as below:
...
> Jason Gunthorpe (3):
>       RDMA/mlx5: Do not allow the user to write to the clock page
>       RDMA/mlx5: Use rdma_user_map_io for mapping BAR pages
>       RDMA/ucontext: Fix regression with disassociate

This doesn't compile. The patch below would fix it, but not sure if
this is what is intended:

drivers/infiniband/core/uverbs_main.c: In function 'rdma_umap_fault':
drivers/infiniband/core/uverbs_main.c:898:28: error: 'struct vm_fault' has no member named 'vm_start'
   vmf->page = ZERO_PAGE(vmf->vm_start);
                            ^~
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 7843e89235c3..65fe89b3fa2d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -895,7 +895,7 @@ static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)
 
 	/* Read only pages can just use the system zero page. */
 	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
-		vmf->page = ZERO_PAGE(vmf->vm_start);
+		vmf->page = ZERO_PAGE(vmf->vma->vm_start);
 		get_page(vmf->page);
 		return 0;
 	}
