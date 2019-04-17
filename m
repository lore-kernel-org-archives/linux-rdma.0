From: "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Subject: RE: [PATCH rdma-next 3/6] RDMA/ucontext: Do not allow BAR mappings
 to be executable
Date: Wed, 17 Apr 2019 19:05:37 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663BE6A5513@FMSMSX108.amr.corp.intel.com>
References: <20190416110730.32230-1-leon@kernel.org>
 <20190416110730.32230-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190416110730.32230-4-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Feras Daoud <ferasda@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>-----Original Message-----
>From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>owner@vger.kernel.org] On Behalf Of Leon Romanovsky
>Sent: Tuesday, April 16, 2019 4:07 AM
>To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
><jgg@mellanox.com>
>Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
>rdma@vger.kernel.org>; Andrea Arcangeli <aarcange@redhat.com>; Feras
>Daoud <ferasda@mellanox.com>; Haggai Eran <haggaie@mellanox.com>;
>Jason Gunthorpe <jgg@ziepe.ca>; Saeed Mahameed
><saeedm@mellanox.com>; linux-netdev <netdev@vger.kernel.org>
>Subject: [PATCH rdma-next 3/6] RDMA/ucontext: Do not allow BAR mappings
>to be executable
>
>From: Jason Gunthorpe <jgg@mellanox.com>
>
>These are not code pages and should never be executed.
>
>Cc: stable@vger.kernel.org
>Fixes: 5f9794dc94f5 ("RDMA/ucontext: Add a core API for mmaping driver IO
>memory")
>Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
>Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>---
> drivers/infiniband/core/uverbs_main.c | 4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/drivers/infiniband/core/uverbs_main.c
>b/drivers/infiniband/core/uverbs_main.c
>index fef4519d1241..3ef6474cd201 100644
>--- a/drivers/infiniband/core/uverbs_main.c
>+++ b/drivers/infiniband/core/uverbs_main.c
>@@ -889,6 +889,10 @@ static struct rdma_umap_priv
>*rdma_user_mmap_pre(struct ib_ucontext *ucontext,
> 	struct ib_uverbs_file *ufile = ucontext->ufile;
> 	struct rdma_umap_priv *priv;
>
>+	if (vma->vm_flags & VM_EXEC)
>+		return ERR_PTR(-EINVAL);
>+	vma->vm_flags &= ~VM_MAYEXEC;
>+

A change like this was made in HFI with:

commit 12220267645cb7d1f3f699218e0098629e932e1f
IB/hfi: Protect against writable mmap

This caused user applications that use the stack for execution to fail.
The VM_EXEC flag is passed down during mmaps.

We had to remove this patch with:

commit 7709b0dc265f28695487712c45f02bbd1f98415d
IB/hfi1: Remove overly conservative VM_EXEC flag check

to resolve this issue.

I am not sure if this is an equivalent issue, but the code path
appears very similar.

Testing with applications that set the EXECSTACK bit will show if this
is an issue.

Mike

> 	if (vma->vm_end - vma->vm_start != size)
> 		return ERR_PTR(-EINVAL);
>
>--
>2.20.1
