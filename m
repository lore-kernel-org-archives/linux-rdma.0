From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 08/10] IB/umem: Add support to huge ODP
Date: Wed, 5 Apr 2017 20:33:27 +0300
Message-ID: <20170405173327.GH20443@mtr-leonro.local>
References: <20170405062359.26623-1-leon@kernel.org>
 <20170405062359.26623-9-leon@kernel.org>
 <20170405164539.GA9232@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x9NlMAausKqHAFUv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170405164539.GA9232-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--x9NlMAausKqHAFUv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05, 2017 at 11:45:39AM -0500, Shiraz Saleem wrote:
> On Wed, Apr 05, 2017 at 09:23:57AM +0300, Leon Romanovsky wrote:
> > From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Add IB_ACCESS_HUGETLB ib_reg_mr flag.
> > Hugetlb region registered with this flag
> > will use single translation entry per huge page.
> >
> > Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/core/umem.c     |  2 +-
> >  drivers/infiniband/core/umem_odp.c | 19 +++++++++++++++++--
> >  include/rdma/ib_umem_odp.h         |  6 ++++--
> >  include/rdma/ib_verbs.h            |  1 +
> >  4 files changed, 23 insertions(+), 5 deletions(-)
> >
> > @@ -315,6 +317,20 @@ int ib_umem_odp_get(struct ib_ucontext *context, s=
truct ib_umem *umem)
> >  	if (!mm)
> >  		return -EINVAL;
> >
> > +	if (access & IB_ACCESS_HUGETLB) {
> > +		struct vm_area_struct *vma;
> > +		struct hstate *h;
> > +
> > +		vma =3D find_vma(mm, ib_umem_start(umem));
> > +		if (!vma || !is_vm_hugetlb_page(vma))
> > +			return -EINVAL;
> > +		h =3D hstate_vma(vma);
> > +		umem->page_shift =3D huge_page_shift(h);
> > +		umem->hugetlb =3D 1;
>
> User memory buffer could span multiple VMAs right? So shouldn=E2=80=99t w=
e check all VMAs of the umem
> before setting the hugetlb flag?

It depends on what do you want to achieve. Current implementation uses
best effort strategy and it assumes that user called to madvise
with MADV_HUGETLB before. In such case, all VMAs will have hugettlb
property in it. If the user calls madavise for partial umem region,
the application and ODP will continue to work, but won't efficient
in its memory usage.

Thanks

>
> > +	} else {
> > +		umem->hugetlb =3D 0;
> > +	}
> > +
> >  	/* Prevent creating ODP MRs in child processes */
> >  	rcu_read_lock();
> >  	our_pid =3D get_task_pid(current->group_leader, PIDTYPE_PID);

--x9NlMAausKqHAFUv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljlKmcACgkQ5GN7iDZy
WKenLRAAiqtv6mxRto/0eUXctvFHxLl4dCkuMLmPQL97VRq5OgSQXAmjOyOnV8U4
MyckV4A3yWOF3IPauwQi5hF3GgLd+1/nQcidnaz18OIAYW2aVXS/tghYfeUdC58p
k74kOtpSmnYTukezWHKZrRVi9DAljTUn7CY+eCBV+tPf1koLOLE+q5r0h6vZW30N
awV7JzIYcfHTSk1/zF2vmF6Ph9RYk4LEjWB/U7Ea+C5o+sOyJk6TK7cLODjAslGQ
VfSlpLJxE1wshhioZv+br7c3kxjlsBsF/QP9YTYImFRu1exi/EWr3p3OhKCFzEbu
htIIO+kgVQXKcrR+A43iQykQ+2cyeZgNNXw5d1o8TptK8kvXbu+FKMWZDQCrmDcL
VxvWsvYVKtxR7P8t3oPnVUH2DHWuO5d85KehuX/cmEe8g9IsOlrLq5Cbi76g20ch
/JIfDSQhp5WmHXotjcy8CubtHMp+mz/H9e9WuSTU+qIJGzz6zY7iTw9QMRvSdurR
3oTSgh9OfFrkceTAX5jrOaW1DnUOo02TFIdl0W7oNUmasuzHuxj093//YfMoQ9qI
sLQHOuKcYC5vinSQaG3bt8xX2FDDFY6ztdRIPuucYkK9/eZtQ5QMwt04Esd9rUhG
+N2QJR+QJMWZgQ8/iJssxkqunKpt0WyLRS15MgsGYe4GNOYM0Jk=
=5ufG
-----END PGP SIGNATURE-----

--x9NlMAausKqHAFUv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
