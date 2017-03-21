From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/3] IB/umem: Drop hugetlb variable and VMA
 allocation
Date: Tue, 21 Mar 2017 10:14:08 +0200
Message-ID: <20170321081408.GZ2079@mtr-leonro.local>
References: <20170319085557.6023-1-leon@kernel.org>
 <20170319085557.6023-3-leon@kernel.org>
 <20170321021936.GA18356@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fdv96I0Kd+XSW/CM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170321021936.GA18356-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--fdv96I0Kd+XSW/CM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2017 at 09:19:36PM -0500, Shiraz Saleem wrote:
> On Sun, Mar 19, 2017 at 10:55:56AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > IB umem structure has field hugetlb which was assigned, but except
> > i40iw driver, it was actually never used.
> >
> > This patch drops that variable out of the struct ib_umem, removes
> > all writes to it, get rids of VMA allocation which wasn't used and
> > removes check hugetlb from i40iw driver, because it is checked anyway in
> > i40iw_set_hugetlb_values() routine.
> >
> > @@ -143,9 +141,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *con=
text, unsigned long addr,
> >
> >  	umem->odp_data =3D NULL;
> >
> > -	/* We assume the memory is from hugetlb until proved otherwise */
> > -	umem->hugetlb   =3D 1;
> > -
> >  	page_list =3D (struct page **) __get_free_page(GFP_KERNEL);
> >  	if (!page_list) {
> >  		put_pid(umem->pid);
> > @@ -153,14 +148,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *co=
ntext, unsigned long addr,
> >  		return ERR_PTR(-ENOMEM);
> >  	}
> >
> > -	/*
> > -	 * if we can't alloc the vma_list, it's not so bad;
> > -	 * just assume the memory is not hugetlb memory
> > -	 */
> > -	vma_list =3D (struct vm_area_struct **) __get_free_page(GFP_KERNEL);
> > -	if (!vma_list)
> > -		umem->hugetlb =3D 0;
> > -
> >  	npages =3D ib_umem_num_pages(umem);
> >
> >  	down_write(&current->mm->mmap_sem);
> > @@ -194,7 +181,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *con=
text, unsigned long addr,
> >  		ret =3D get_user_pages(cur_base,
> >  				     min_t(unsigned long, npages,
> >  					   PAGE_SIZE / sizeof (struct page *)),
> > -				     gup_flags, page_list, vma_list);
> > +				     gup_flags, page_list, NULL);
> >
> >  		if (ret < 0)
> >  			goto out;
> > @@ -203,12 +190,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *co=
ntext, unsigned long addr,
> >  		cur_base +=3D ret * PAGE_SIZE;
> >  		npages   -=3D ret;
> >
> > -		for_each_sg(sg_list_start, sg, ret, i) {
> > -			if (vma_list && !is_vm_hugetlb_page(vma_list[i]))
> > -				umem->hugetlb =3D 0;
> > -
> > +		for_each_sg(sg_list_start, sg, ret, i)
> >  			sg_set_page(sg, page_list[i], PAGE_SIZE, 0);
> > -		}
> >
> >  		/* preparing for next loop */
> >  		sg_list_start =3D sg;
>
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infini=
band/hw/i40iw/i40iw_verbs.c
> > index 9b2849979756..59c8d74e3704 100644
> > --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > @@ -1850,7 +1850,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_=
pd *pd,
> >  	iwmr->page_size =3D region->page_size;
> >  	iwmr->page_msk =3D PAGE_MASK;
> >
> > -	if (region->hugetlb && (req.reg_type =3D=3D IW_MEMREG_TYPE_MEM))
> > +	if (req.reg_type =3D=3D IW_MEMREG_TYPE_MEM)
> >  		i40iw_set_hugetlb_values(start, iwmr);
>
> The code in ib_umem_get iterates through __all__ VMA=E2=80=99s correspond=
ing to the
> user-space buffer and hugetlb field of the umem struct is set only if they
> are all using huge_pages. So in the essence, umem->hugetlb provides the
> driver info on whether __all__ pages of the memory region uses huge pages
> or not.
>
> i40iw_set_hugetlb_values only finds the VMA w.r.t the start virtual addre=
ss of
> the user-space buffer and checks if __this__ VMA uses hugetlb pages or no=
t.
> It is a sanity check done on the VMA found.

>
> So the question is -- Do we know that only a single VMA represents the us=
er-space
> buffer backed by huge pages?
> If not, it doesnt appear that the check in i40iw_set_hugetlb_values will =
suffice to
> identify if the entire memory region is composed of huge pages since it d=
oesnt
> check all the VMAs. umem->hugetlb would be required for it.

You are right and thank you for pointing that. User memory buffer indeed can
span more than one VMA. For example one reg_mr with READ property for
two adjacent VAMs, one with READ properties and another with READ-WRITE.

However, relying on hugetlb which was set during creation is not best
thing too. It can be changed during the application run. The mlx5 relies on
the mlx5_ib_cont_pages() function to understand the actual layout.

Thanks

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--fdv96I0Kd+XSW/CM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljQ4NAACgkQ5GN7iDZy
WKfKZRAAzPDQ0rYYYDjC6SyA9052++T8RL/A6MAJ+Uc/Synwensc3dXPSQ/rkwfQ
Za2jtcly2nopPe7bjBh5lokzpSBNFjLGQCGJMGkP5PazI47xd8Dd4cD+4m1Xt6Oo
lmG9eTvZKf1X0MXXwzTbStjz1EopM5eESUF515PnKmXnWm2fPdN8mo0TNx1ZcTdf
dWcskSuFATiixJ56vA0QcfZwbhe+O3PL6bwDMNejgMsJyEFFUYMuRO7+VP6qQ1//
DLnauDcbpHqqdhSPuMyMC0GVyGK6xn/yn3CepnbrnhA6+Ycsdipk8ZCpE1Md+naw
froVeR8oVdWTUV1PDgyvCtS9oh+kPJcyDTJw9DhzUCV8ju6U3h1jg9MF+2yhfZs4
5MQ6gHIqGWwYIlTa0mj9pZdW4ijRw7E38OcV+mfisG5gMb7lWRu7gekwNNgRsilF
+PT7BOf6S+ovBN1DqOXBx/YW2Tx7rojRrUGkPggHWicn3sDokoNW0m16SJkHU6hV
YH7vlIrn1cEZ6W44D/8ZgeRZ7oKyT0KDT9xpOcR9oT8yVYwCvywO/gz4Wz8GW7GZ
OOA33GOii3ZY9FV+aQ285M3NJhJGTz6MRG8FvZ6wR5H9z+Mt+2keXBQ6xYxNIvir
K5hwAnvsbWqxRX1xWs1uR2UxEEC1cOdcQtk1ok5CStR2InaC3gw=
=zdVz
-----END PGP SIGNATURE-----

--fdv96I0Kd+XSW/CM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
