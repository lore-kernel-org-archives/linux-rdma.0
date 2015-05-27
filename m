From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 for-next 1/3] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Wed, 27 May 2015 12:04:29 -0400
Message-ID: <1432742669.28905.228.camel@redhat.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
	 <1431515438-24042-2-git-send-email-yishaih@mellanox.com>
	 <20150525165449.GA4379@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-sFXBKh8oP6PxqAgYSdAR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150525165449.GA4379-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-sFXBKh8oP6PxqAgYSdAR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-25 at 10:54 -0600, Jason Gunthorpe wrote:
> On Wed, May 13, 2015 at 02:10:36PM +0300, Yishai Hadas wrote:
>=20
> > +	struct srcu_struct			disassociate_srcu;
>=20
> There is no need for rcu for this, use a rw sem.

The rcu was used becuase it's on the hot path I assume.  Do we have
numbers on whether a rwsem vs. an rcu matters performance wise?  If the
rcu actually helps performance, then I'm inclined to leave it, but if it
doesn't, then I'd agree that a rwsem is simpler and easier to deal with.

> > @@ -1326,6 +1327,13 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_=
uverbs_file *file,
> >  		return -EFAULT;
> >  	}
> > =20
> > +	/* Taking ref count on uverbs_file to make sure that file won't be
> > +	 * freed till that event file is closed. It will enable accessing the
> > +	 * uverbs_device fields as part of closing the events file and making
> > +	 * sure that uverbs device is available by that time as well.
> > +	 * Note: similar is already done for the async event file.
> > +	*/
> > +	kref_get(&file->ref);
>=20
> Is this a bug today? It doesn't look like it, but this stuff does look wr=
ong.
>=20
> Woulnd't this would make more sense for ib_uverbs_alloc_event_file to
> unconditionally grab the kref and unconditionally release it on
> release?=20
>=20
> The existing code for this looks broken, in ib_uverbs_get_context all
> the error paths between ib_uverbs_alloc_event_file and the
> kref_get(file->ref) are wrong - the will result in fput() which will
> call ib_uverbs_event_close, which will try to do kref_put and
> ib_unregister_event_handler - which are no longer paired.
>=20
> [I recommend moving the kref_get and ib_register_event_handler into
>  ib_uverbs_alloc_event_file, so the 'create' and 'destroy' code paths
>  are clearly paired instead of being partially open coded in call
>  sites]
>=20
> Fix all this in a seperate patch to add the needed change in kref
> semantics please.

Seconded.

> > -	if (!try_module_get(dev->ib_dev->owner)) {
> > -		ret =3D -ENODEV;
> > +	mutex_lock(&dev->disassociate_mutex);
> > +	if (dev->disassociated) {
> > +		ret =3D -EIO;
> >  		goto err;
> >  	}
> > =20
> > -	file =3D kmalloc(sizeof *file, GFP_KERNEL);
> > +	/* In case IB device supports disassociate ucontext, there is no hard
> > +	 * dependency between uverbs device and its low level device.
> > +	 */
> > +	module_dependent =3D !(dev->flags & UVERBS_FLAG_DISASSOCIATE);
> > +
> > +	if (module_dependent) {
> > +		if (!try_module_get(dev->ib_dev->owner)) {
> > +			ret =3D -ENODEV;
> > +			goto err;
>=20
> Again? Why I do I keep pointing this same basic thing to Mellanox
> people:
>=20
>  If you hold a X then you hold the ref to X as well.
>=20
> So, if the core code is holding function pointers to module code, then
> the core code holds a module ref. When the core code null's those
> function pointers, then it can release the module ref.

Seconded.

> This might work today like this (I'm not entirely sure), but it makes
> no sense at all.
>=20
> I'll look more closely in a few weeks once the rwsem change is done.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-sFXBKh8oP6PxqAgYSdAR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZesNAAoJELgmozMOVy/dj+YQAK6WbZb4wNJ/bgj4leVtLAtb
xl+F6P1Uc+GJTlngxy6SEB03G3InQSrcSc2F83U/RL1PPf3wt4b5zRPhjfvxFH8p
xqz44JOdVrHveAW/DANwTrUw36hDrQaL4bkSKtvylecgwKIv79hsdRpiXAaToJW2
VbUe+TZxz7v+DQh98oeeBl9JOZL+HBTuDhQ5aFvUGiu0FPZdP7K5REPlVpBxGV1H
OeI4MbcIMhGU/sW9i1j1tQ1nMkOK1GhBmK7EeFR2K3ZyuqWhxDQzI0Om724UzBHW
MV2+BqpYHhnqzmShaz795Phq4eaMt+CkuqoCr3ou6wjhD75DSwIbbaCKGKCRUtQa
90MD1ljN/puBwHonCpBMhNInVxV+q0YzHD94rjAijlMTcV5P8fbMTVsyOjR7jjSE
5LOFGKnzcPaKJpGgquABRP2zkZzhCSt1bYF7ZgPSwhKouzSK3loxIT4uumRZe23R
AqFbdSy0sRoqJQWaRnkTxPc+YDe/4wbG7AxUBbRyitoiHK8bLvmTD9DHvYp/4jIv
oOfUtf2LfCO/zyaxrhN/Jc/KQvyZe6Jnv0eLZgiIdyAcBoQ0YZhjRqfr4ph9e8kD
5EDyzYR+sAvempLp6epW2+LrDSznAkAZK0gTmjXvrrwzGiCZBmWt4NacWlZjJLrE
WrgtUWd5SX58NsiMDWg+
=FaTk
-----END PGP SIGNATURE-----

--=-sFXBKh8oP6PxqAgYSdAR--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
