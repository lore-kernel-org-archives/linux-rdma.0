From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1] iw_cxgb4: Fix kbuild bot reported warnings
Date: Tue, 28 Apr 2015 09:57:38 -0400
Message-ID: <1430229458.44548.89.camel@redhat.com>
References: <1430246138-3218-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-e22W5U6o6ikPLStBKb4r"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430246138-3218-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-e22W5U6o6ikPLStBKb4r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-04-29 at 00:05 +0530, Hariprasad Shenai wrote:
> Commit 20dca80f ("iw_cxgb4: 32b platform fixes") introduced warnings
> related to inappropriate argument type while printing arguments

The original patch has not yet been pushed upstream.  There is no need
to submit both it and a fix patch.  I've already modified my copy of
your patch to correct the errors (most of them, there were two spots I
missed that need corrected still).  However, that said...

> Reported by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reported by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cq.c  | 5 +++--
>  drivers/infiniband/hw/cxgb4/mem.c | 4 ++--
>  drivers/infiniband/hw/cxgb4/qp.c  | 4 ++--
>  3 files changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxg=
b4/cq.c
> index be66d5d..1f114c0 100644
> --- a/drivers/infiniband/hw/cxgb4/cq.c
> +++ b/drivers/infiniband/hw/cxgb4/cq.c
> @@ -340,7 +340,8 @@ static void advance_oldest_read(struct t4_wq *wq)
>   */
>  void c4iw_flush_hw_cq(struct c4iw_cq *chp)
>  {
> -	struct t4_cqe *hw_cqe, *swcqe, read_cqe;
> +	struct t4_cqe *hw_cqe =3D NULL;
> +	struct t4_cqe *swcqe, read_cqe;
>  	struct c4iw_qp *qhp;
>  	struct t4_swsqe *swsqe;
>  	int ret;
> @@ -975,7 +976,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,=
 int entries,
>  		mm2->len =3D PAGE_SIZE;
>  		insert_mmap(ucontext, mm2);
>  	}
> -	PDBG("%s cqid 0x%0x chp %p size %u memsize %zu, dma_addr 0x%0llx\n",
> +	PDBG("%s cqid 0x%0x chp %p size %u memsize %lu, dma_addr 0x%0llx\n",
>  	     __func__, chp->cq.cqid, chp, chp->cq.size,
>  	     (uintptr_t)chp->cq.memsize,
               ^^^^^^^^^^
               This is still wrong in your fixup.  The uintptr_t is to
be used where you want to shove an int into a ptr or vice versa and you
know that the sizes are appropriate and you don't want the compiler
complaining.  It isn't something that should be used in casting for a
printf format.  So it shouldn't have been added here in the first place.
The right fix is to remove this cast so the original memsize printf
format works properly again.

>  	     (unsigned long long) chp->cq.dma_addr);
             =20


> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cx=
gb4/mem.c
> index 9a26649..42805f6 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -930,7 +930,7 @@ struct ib_fast_reg_page_list *c4iw_alloc_fastreg_pbl(=
struct ib_device *device,
> =20
>  	PDBG("%s c4pl %p pll_len %u page_list %p dma_addr %pad\n",
>  	     __func__, c4pl, c4pl->pll_len, c4pl->ibpl.page_list,
> -	     (void *)(uintptr_t)c4pl->dma_addr);
> +	     (dma_addr_t *)(uintptr_t)c4pl->dma_addr);

This is wrong too.  It makes no sense to cast this as uintptr and then
back to dma_addr_t when it was dma_addr_t to begin with.

=20
>  	return &c4pl->ibpl;
>  }
> @@ -941,7 +941,7 @@ void c4iw_free_fastreg_pbl(struct ib_fast_reg_page_li=
st *ibpl)
> =20
>  	PDBG("%s c4pl %p pll_len %u page_list %p dma_addr %pad\n",
>  	     __func__, c4pl, c4pl->pll_len, c4pl->ibpl.page_list,
> -	     (void *)(uintptr_t)c4pl->dma_addr);
> +	     (dma_addr_t *)(uintptr_t)c4pl->dma_addr);
> =20
>  	dma_free_coherent(&c4pl->dev->rdev.lldi.pdev->dev,
>  			  c4pl->pll_len,
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxg=
b4/qp.c
> index 7ce40c3..176a238 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -1784,8 +1784,8 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, stru=
ct ib_qp_init_attr *attrs,
>  	qhp->ibqp.qp_num =3D qhp->wq.sq.qid;
>  	init_timer(&(qhp->timer));
>  	INIT_LIST_HEAD(&qhp->db_fc_entry);
> -	PDBG("%s sq id %u size %u memsize %zu num_entries %u "
> -	     "rq id %u size %u memsize %zu num_entries %u\n", __func__,
> +	PDBG("%s sq id %u size %u memsize %lu num_entries %u "
> +	     "rq id %u size %u memsize %lu num_entries %u\n", __func__,
>  	     qhp->wq.sq.qid, qhp->wq.sq.size, (unsigned long)qhp->wq.sq.memsize=
,
>  	     attrs->cap.max_send_wr, qhp->wq.rq.qid, qhp->wq.rq.size,
>  	     (unsigned long)qhp->wq.rq.memsize, attrs->cap.max_recv_wr);


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-e22W5U6o6ikPLStBKb4r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVP5HSAAoJELgmozMOVy/d0esP/A++5yLpq7HHgpDMd2pdGj8t
5u1SXYFB6/DBjZNOd48N553fh1nzeDmXU9SEkEBoWUC0WbIFfTvwyfBED31NQy6S
hl1Yhviqq//B5HH2DU3klNIug6nRcwEvNbo24jer3GmoV73EjrI6ZwBwWIInCC1Z
TS9Fj4Sg3NWL6kgNSlphEVoy688uIV8v2QNIXEIDhAxiYCRW2/+ghezzag0k1o/P
BYSMGGvKQW/WWVXdmtNM6GqiY0A//k5xhzwC1LAQJ7UKCvQJ8RN33xnuOdC4P9NW
eEQUFXOzN8wGk7tF5LX0L6tXNr2LUKJHQoTAv+tt8JHVSuUYgAm5t1AFSZlZNuYL
6LBWuL0afJvKeN995I6DTaRMO3gQY1r0ZzlKtNAEQWlC0E+H3B+Iu0zY9wB31C23
Xd3GkFSAza6RDFNix/Ml9o4+F5jt6cwoa6F/gHCWABXTLuFa4vE3Vt/n/ZInDLvP
zg1DgbFTS7fNC7PcdKRjxsnt90bzsrCBGwjefMhQhSNKWc171EJD67TCaSVxd4kU
HZbm5toLHxcg7bzUwYYDndTOb/tccVZQUbDKZdQX/ZWIY+zSMqcYNPzVvUQ1IvZP
zY5xfAGqYQCxJuiJ56oJ1+hzNrIR3ytPt3WimjRP90+2UBsFn+xkk+1SZYmJqXZB
WhaXFAFzhPdXrLd2Sir8
=7dok
-----END PGP SIGNATURE-----

--=-e22W5U6o6ikPLStBKb4r--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
