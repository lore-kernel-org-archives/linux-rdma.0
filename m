From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v4 1/7] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 18 Jan 2018 07:20:20 +0200
Message-ID: <20180118052020.GS13639@mtr-leonro.local>
References: <20180115151255.30167-1-leon@kernel.org>
 <20180115151255.30167-2-leon@kernel.org>
 <1516138397.2844.34.camel@wdc.com>
 <20180117054721.GE13639@mtr-leonro.local>
 <1516246321.3665.7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="chReQkDOePndSGWY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516246321.3665.7.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--chReQkDOePndSGWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 18, 2018 at 03:32:03AM +0000, Bart Van Assche wrote:
> On Wed, 2018-01-17 at 07:47 +0200, Leon Romanovsky wrote:
> > On Tue, Jan 16, 2018 at 09:33:18PM +0000, Bart Van Assche wrote:
> > > > +/**
> > > > + * enum rdma_restrack_obj - HW objects to track
> > > > + */
> > > > +enum rdma_restrack_obj {
> > > > +	/**
> > > > +	 * @RDMA_RESTRACK_PD: Protection domain (PD)
> > > > +	 */
> > > > +	RDMA_RESTRACK_PD,
> > > > +	/**
> > > > +	 * @RDMA_RESTRACK_CQ: Completion queue (CQ)
> > > > +	 */
> > > > +	RDMA_RESTRACK_CQ,
> > > > +	/**
> > > > +	 * @RDMA_RESTRACK_QP: Queue pair (QP)
> > > > +	 */
> > > > +	RDMA_RESTRACK_QP,
> > > > +	/* private: counts number of elements, always last */
> > > > +	_RDMA_RESTRACK_MAX
> > > > +};
> > >
> > > This looks really ugly to me. Please use kernel-doc syntax to documen=
t the RDMA
> > > resource types.
> >
> > I used kerne-doc and _RDMA_RESTRACK_MAX was an exception, it is not sup=
posed to be
> > used outside of restrack code.
>
> Hello Leon,
>
> Please have a look at the following example from Documentation/kernel-doc=
-nano-HOWTO.txt:
>

Cite from that document:
1 NOTE: this document is outdated and will eventually be removed.  See
2 Documentation/doc-guide/ for current information.

I followed guidelines from Documentation/doc-guide/kernel-doc.rst.

> kernel-doc for structs, unions, enums, and typedefs
> ---------------------------------------------------
>
> [ ... ]
>
> /**
>  * struct my_struct - short description
>  * @a: first member
>  * @b: second member
>  *
>  * Longer description
>  */
> struct my_struct {
>     int a;
>     int b;
> /* private: internal use only */
>     int c;
> };
>
> > > > +/**
> > > > + * struct rdma_restrack_root - main resource tracking management
> > > > + * entity, per-device
> > > > + */
> > > > +struct rdma_restrack_root {
> > > > +	/**
> > > > +	 * @cnt: global counter to avoid the need to count number
> > > > +	 * of elements in the object's list.
> > > > +	 *
> > > > +	 * It can be different from the list_count, because we are
> > > > +	 * not taking lock during counter increment and don't
> > > > +	 * synchronize the RCU.
> > > > +	 */
> > > > +	refcount_t		cnt[_RDMA_RESTRACK_MAX];
> > > > +	/**
> > > > +	 * @list: linked list of all entries per-object
> > > > +	 */
> > > > +	struct list_head	list[_RDMA_RESTRACK_MAX];
> > > > +	/* private: Internal read/write lock.
> > > > +	 * It is needed to protect the add/delete list operations.
> > > > +	 */
> > > > +	struct rw_semaphore	rwsem[_RDMA_RESTRACK_MAX];
> > > > +};
> > >
> > > The above looks wrong to me. Please change the above into an array of=
 data structures
> > > instead of a data structure that is full of arrays of identical size.
> >
> > It is a matter for taste.
>
> No, it is not. The above layout makes it impossible for the CPU prefetche=
r to
> be effective if _RDMA_RESTRACK_MAX would be large. Additionally, the above
> layout makes it impossible to pass a pointer to the (cnt, list, rwsem) tr=
iplet
> from one function to another.

Thanks for the explanation, I'm changing it now.

>
> > > > +/**
> > > > + * struct rdma_restrack_entry - metadata per-entry
> > > > + */
> > > > +struct rdma_restrack_entry {
> > > > +	/**
> > > > +	 * @list: linked list between entries
> > > > +	 */
> > > > +	struct list_head	list;
> > > > +	/**
> > > > +	 * @valid: validity indicator
> > > > +	 *
> > > > +	 * The entries are filled during rdma_restrack_add,
> > > > +	 * can be attempted to be free during rdma_restrack_del.
> > > > +	 *
> > > > +	 * As an example for that, see mlx5 QPs with type MLX5_IB_QPT_HW_=
GSI
> > > > +	 */
> > > > +	bool			valid;
> > > > +	/**
> > > > +	 * @srcu: sleepable RCU to protect object data.
> > > > +	 */
> > > > +	struct srcu_struct	srcu;
> > > > +	/**
> > > > +	 * @task: owner of resource tracking entity
> > > > +	 *
> > > > +	 * There are two types of entities: created by user and created
> > > > +	 * by kernel.
> > > > +	 *
> > > > +	 * This is relevant for the entities created by users.
> > > > +	 * For the entieies created by kernel, this pointer will be NULL.
> > > > +	 */
> > > > +	struct task_struct	*task;
> > > > +	/**
> > > > +	 * @kern_name: name of owner for the kernel created entities.
> > > > +	 */
> > > > +	const char		*kern_name;
> > > > +};
> > >
> > > Again, please use the kernel-doc syntax to document structure members=
=2E Additionally,
> > > please fix the spelling of "entieies".
> >
> > It was formatted according to kernel-doc checker:
> > =E2=9E=9C  linux-rdma git:(rn/restrack-v5) ./scripts/kernel-doc include=
/rdma/restrack.h |grep warnin
> > include/rdma/restrack.h:59: warning: Enum value '_RDMA_RESTRACK_MAX' no=
t described in enum 'rdma_restrack_obj'
>
> Again, please have a look at Documentation/kernel-doc-nano-HOWTO.txt. That
> document shows that members of data structures should be documented above=
 the
> "struct" keyword instead of inside the structure definition.

Please read Documentation/doc-guide/kernel-doc.rst - "In-line member
documentation comments" section.

Regarding other comments, I'm working to address them in new patchset.

Thanks for the review.


>
> Thanks,
>
> Bart.

--chReQkDOePndSGWY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpgLpMACgkQ5GN7iDZy
WKfpnRAAkRw5J3gHB8H3C62KlEgffZGn0geeZJELXci9co++plG+QdR6imYlAfiG
RUV7tpnqBYk3zKLUjm/z2E6h5tORvKgh4+zwv+k3jDjtB4yiNokhB0PNv5QPDVKs
DclrR7c/wBaqke+1KHSKSLL1QMtH04fPbp0YL35IVF6Rwvz4yTZDyinrfYNlL71/
Umpy3y1GENhCvcbX0zkZIT3BlwNE8KGTUWkupMGnV4gxldBEA2GrsK6TdiISnbB1
OM2soaWMk38F+oe9rXCLKUKhxFiu9Iy7+9iAJUmpxyJcWcRRxVFEUjGTAyAulNq3
s8yJ2AhsAQlRjDcvcCCB26p5qQj6AjDLstzpWc+OxzT3E8aSTazPTCrn3FYW5DzV
mcuPC0VPpdY72Bz6es1+EMs5kvX8ejxGJTpfsWWvfWpAb+9ds4q3H4B5/h4Zw7mk
gl2Kt96u/jd/+5WR9uPWdSB7f21tZ108pvOG3hCGJXFHa7cd+MsjVhx8EIXgi9tE
UEPqauKlBnTLM8OBE62zw0K1EdPONaaX19wbSPb2am8lQ3d/ZafHsqmFoqeMwumi
wjdsHIEnYSQACbXXJJSVosva5BKciqcP0EwJ2HanaKAV/wGSP09qL0eBmRRfAz2a
aGCyDdysAaASGXdu+rrraprL9/ONPVWTIpFhGphZSEl/Bb+P9ac=
=5h1h
-----END PGP SIGNATURE-----

--chReQkDOePndSGWY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
