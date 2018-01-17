From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v4 1/7] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Wed, 17 Jan 2018 07:47:21 +0200
Message-ID: <20180117054721.GE13639@mtr-leonro.local>
References: <20180115151255.30167-1-leon@kernel.org>
 <20180115151255.30167-2-leon@kernel.org>
 <1516138397.2844.34.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u5E4XgoOPWr4PD9E"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516138397.2844.34.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--u5E4XgoOPWr4PD9E
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 16, 2018 at 09:33:18PM +0000, Bart Van Assche wrote:
> On Mon, 2018-01-15 at 17:12 +0200, Leon Romanovsky wrote:
> > +int rdma_restrack_init(struct rdma_restrack_root *res)
> > +{
> > +	int i =3D 0;
> > +
> > +	for (; i < _RDMA_RESTRACK_MAX; i++) {
> > +		refcount_set(&res->cnt[i], 1);
> > +		INIT_LIST_HEAD_RCU(&res->list[i]);
> > +		init_rwsem(&res->rwsem[i]);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +void rdma_restrack_clean(struct rdma_restrack_root *res)
> > +{
> > +	int i =3D 0;
> > +
> > +	for (; i < _RDMA_RESTRACK_MAX; i++) {
> > +		WARN_ON_ONCE(!refcount_dec_and_test(&res->cnt[i]));
> > +		WARN_ON_ONCE(!list_empty(&res->list[i]));
> > +	}
> > +}
>
> Is it really useful to set res->cnt to 1 in rdma_restrack_init() and to d=
ecrement
> it in rdma_restrack_clean()? Why not to set res->cnt to 0 in the initiali=
zation
> function?

I'm using refcount_dec() in rdma_restrack_del() and hitting 0 will cause
warning from refcount code. I feel that the simple refcount_dec() more
easy to read than refcount_dec_and_test()

>
> > +
> > +static bool is_restrack_valid(enum rdma_restrack_obj type)
> > +{
> > +	return !(type >=3D _RDMA_RESTRACK_MAX);
> > +}
>
> Whether or not an enum is signed depends on the compiler. So 'type' shoul=
d be cast
> to an unsigned type before being compared against _RDMA_RESTRACK_MAX. Add=
itionally,
> why does the name _RDMA_RESTRACK_MAX start with a single underscore? I'm =
not aware
> of any other constant in the IB stack of which the name starts with an un=
derscore.
>

We can remove this function and I can use double underscores to mark
that it is not needed to use outside of restrack code.

> > +
> > +int rdma_restrack_count(struct rdma_restrack_root *res,
> > +			enum rdma_restrack_obj type)
> > +{
> > +	if (!is_restrack_valid(type))
> > +		return 0;
> > +
> > +	/*
> > +	 * The counter was initialized to 1 at the beginning.
> > +	 */
> > +	return refcount_read(&res->cnt[type]) - 1;
> > +}
> > +EXPORT_SYMBOL(rdma_restrack_count);
>
> Why are invalid resource tracking IDs ignored silently instead of e.g. tr=
iggering
> a kernel warning?

I'll remove the is_restrack_valid() check, in current implementation it
is always valid.

>
> > +void rdma_restrack_add(struct rdma_restrack_entry *res,
> > +		       enum rdma_restrack_obj type, const char *comm)
> > +{
> > +	struct ib_device *dev;
> > +	struct ib_pd *pd;
> > +	struct ib_cq *cq;
> > +	struct ib_qp *qp;
> > +
> > +	if (!is_restrack_valid(type))
> > +		return;
> > +
> > +	switch (type) {
> > +	case RDMA_RESTRACK_PD:
> > +		pd =3D container_of(res, struct ib_pd, res);
> > +		dev =3D pd->device;
> > +		break;
> > +	case RDMA_RESTRACK_CQ:
> > +		cq =3D container_of(res, struct ib_cq, res);
> > +		dev =3D cq->device;
> > +		break;
> > +	case RDMA_RESTRACK_QP:
> > +		qp =3D container_of(res, struct ib_qp, res);
> > +		dev =3D qp->device;
> > +		break;
> > +	default:
> > +		/* unreachable */
> > +		return;
> > +	}
>
> Please do not add unreachable default clauses but instead leave the defau=
lt clause
> out such that the compiler can detect missing case labels.
>
> > @@ -1527,9 +1528,10 @@ struct ib_pd {
> >  	u32			unsafe_global_rkey;
> >
> >  	/*
> > -	 * Implementation details of the RDMA core, don't use in drivers:
> > +	 * Implementation details of the RDMA core, don't use in the drivers
>
> The above change changes a grammatically correct sentence into a grammati=
cally
> incorrect one.
>
> > +	/*
> > +	 * Internal to RDMA/core, don't use in the drivers
> > +	 */
> > +	struct rdma_restrack_entry res;
>
> Does a single-line comment have to be formatted as a block comment? Addit=
ionally,
> please leave out "the".
>
> > +/**
> > + * enum rdma_restrack_obj - HW objects to track
> > + */
> > +enum rdma_restrack_obj {
> > +	/**
> > +	 * @RDMA_RESTRACK_PD: Protection domain (PD)
> > +	 */
> > +	RDMA_RESTRACK_PD,
> > +	/**
> > +	 * @RDMA_RESTRACK_CQ: Completion queue (CQ)
> > +	 */
> > +	RDMA_RESTRACK_CQ,
> > +	/**
> > +	 * @RDMA_RESTRACK_QP: Queue pair (QP)
> > +	 */
> > +	RDMA_RESTRACK_QP,
> > +	/* private: counts number of elements, always last */
> > +	_RDMA_RESTRACK_MAX
> > +};
>
> This looks really ugly to me. Please use kernel-doc syntax to document th=
e RDMA
> resource types.

I used kerne-doc and _RDMA_RESTRACK_MAX was an exception, it is not suppose=
d to be
used outside of restrack code.

>
> > +/**
> > + * struct rdma_restrack_root - main resource tracking management
> > + * entity, per-device
> > + */
> > +struct rdma_restrack_root {
> > +	/**
> > +	 * @cnt: global counter to avoid the need to count number
> > +	 * of elements in the object's list.
> > +	 *
> > +	 * It can be different from the list_count, because we are
> > +	 * not taking lock during counter increment and don't
> > +	 * synchronize the RCU.
> > +	 */
> > +	refcount_t		cnt[_RDMA_RESTRACK_MAX];
> > +	/**
> > +	 * @list: linked list of all entries per-object
> > +	 */
> > +	struct list_head	list[_RDMA_RESTRACK_MAX];
> > +	/* private: Internal read/write lock.
> > +	 * It is needed to protect the add/delete list operations.
> > +	 */
> > +	struct rw_semaphore	rwsem[_RDMA_RESTRACK_MAX];
> > +};
>
> The above looks wrong to me. Please change the above into an array of dat=
a structures
> instead of a data structure that is full of arrays of identical size.
>

It is a matter for taste.

> > +/**
> > + * struct rdma_restrack_entry - metadata per-entry
> > + */
> > +struct rdma_restrack_entry {
> > +	/**
> > +	 * @list: linked list between entries
> > +	 */
> > +	struct list_head	list;
> > +	/**
> > +	 * @valid: validity indicator
> > +	 *
> > +	 * The entries are filled during rdma_restrack_add,
> > +	 * can be attempted to be free during rdma_restrack_del.
> > +	 *
> > +	 * As an example for that, see mlx5 QPs with type MLX5_IB_QPT_HW_GSI
> > +	 */
> > +	bool			valid;
> > +	/**
> > +	 * @srcu: sleepable RCU to protect object data.
> > +	 */
> > +	struct srcu_struct	srcu;
> > +	/**
> > +	 * @task: owner of resource tracking entity
> > +	 *
> > +	 * There are two types of entities: created by user and created
> > +	 * by kernel.
> > +	 *
> > +	 * This is relevant for the entities created by users.
> > +	 * For the entieies created by kernel, this pointer will be NULL.
> > +	 */
> > +	struct task_struct	*task;
> > +	/**
> > +	 * @kern_name: name of owner for the kernel created entities.
> > +	 */
> > +	const char		*kern_name;
> > +};
>
> Again, please use the kernel-doc syntax to document structure members. Ad=
ditionally,
> please fix the spelling of "entieies".

It was formatted according to kernel-doc checker:
=E2=9E=9C  linux-rdma git:(rn/restrack-v5) ./scripts/kernel-doc include/rdm=
a/restrack.h |grep warnin
include/rdma/restrack.h:59: warning: Enum value '_RDMA_RESTRACK_MAX' not de=
scribed in enum 'rdma_restrack_obj'

Thanks

>
> Thanks,
>
> Bart.

--u5E4XgoOPWr4PD9E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpe42kACgkQ5GN7iDZy
WKe2nQ//YXWkJd8GrTIiBlCaTiXyc+iKw2lKn25UdkZeUVfFDp0tEIY9DMXR7ShH
CIVobIcmI2QHPTjIRmETM9ikhsSdAZL1lxRoJ5FBXzlFXupomAIoAmobVAGbUCFX
bgbq+l9CNIcLwAWiw3F7TquOWBEktiiFSdeH0ttcToVy7hYH7spjinXcmN+msEui
EK248JY9BNkOhjKGDHg4MnIVcLwQCg3CykDmyWiNzkrWWzUx6KD9P/8CY71PglEl
vM0ysENe7QWw7h3Wx7GyOEXFY6SiezdeAHH5O3io+ofVVLSn6IyeS8J7NbrvVs8G
wYeyRlBiPaw0RJiHA/yUTJEJs5tUEp2gXi2zJ1gHYLR8+0yx2SRITonn/gjlL4kL
h4vbGKsGoY0t+hNa12Z7SVsB34ZbblXGHLfSzj0aQ6NgAgvGWF4uz65dHBKrg00U
UqPGV+byvfprno/biYAEs6XUsF6jsrL0geS8RN0vofmuJZTk+KawUHKmZeK+nliY
chQnSJh63scm4P7WOydsi3AI1ptwGu/Ri3NmF4tgdVv+j/REaE6G41FGfH8Tjhum
tbLIu/grAWAtOdypd8HZrU7qBfQRjEZePZNinQUloK3yu54KZ/Sg4+ER0MEDnZdx
Cy2g11dWF0vpw/bmwmwdMDjJZGjKWWO9AY5saVtIT+6VxfvPADg=
=2kcr
-----END PGP SIGNATURE-----

--u5E4XgoOPWr4PD9E--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
