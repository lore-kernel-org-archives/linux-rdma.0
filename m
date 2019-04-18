From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 3/6] RDMA/ucontext: Do not allow BAR mappings to
 be executable
Date: Thu, 18 Apr 2019 05:58:01 +0000
Message-ID: <20190418055759.GA3155@mellanox.com>
References: <20190416110730.32230-1-leon@kernel.org>
 <20190416110730.32230-4-leon@kernel.org>
 <14063C7AD467DE4B82DEDB5C278E8663BE6A5513@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663BE6A5513@FMSMSX108.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <8785FA9F16468446BC4673E3B86BB48B@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: "Ruhl, Michael J" <michael.j.ruhl@intel.com>, Kees Cook <keescook@chromium.org>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Feras Daoud <ferasda@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 17, 2019 at 07:05:37PM +0000, Ruhl, Michael J wrote:

> >diff --git a/drivers/infiniband/core/uverbs_main.c
> >b/drivers/infiniband/core/uverbs_main.c
> >index fef4519d1241..3ef6474cd201 100644
> >+++ b/drivers/infiniband/core/uverbs_main.c
> >@@ -889,6 +889,10 @@ static struct rdma_umap_priv
> >*rdma_user_mmap_pre(struct ib_ucontext *ucontext,
> > 	struct ib_uverbs_file *ufile =3D ucontext->ufile;
> > 	struct rdma_umap_priv *priv;
> >
> >+	if (vma->vm_flags & VM_EXEC)
> >+		return ERR_PTR(-EINVAL);
> >+	vma->vm_flags &=3D ~VM_MAYEXEC;
> >+
>=20
> A change like this was made in HFI with:
>=20
> commit 12220267645cb7d1f3f699218e0098629e932e1f
> IB/hfi: Protect against writable mmap
>=20
> This caused user applications that use the stack for execution to fail.
> The VM_EXEC flag is passed down during mmaps.
>=20
> We had to remove this patch with:
>=20
> commit 7709b0dc265f28695487712c45f02bbd1f98415d
> IB/hfi1: Remove overly conservative VM_EXEC flag check
>=20
> to resolve this issue.
>=20
> I am not sure if this is an equivalent issue, but the code path
> appears very similar.

It does seem problematic here too

Kees: You have worked in this W^X area in other parts of the kernel,
what should drivers do here?

The situation is we have a driver providing mmap against BAR memory
that is absolutely not intended for execution, so we would prefer to
block VM_EXEC in the driver's mmap fops callback

However READ_IMPLIES_EXEC forces VM_EXEC on for everything with no way
to opt out..

Jason
