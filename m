From: Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/36] HMM: introduce heterogeneous memory management v3.
Date: Mon, 8 Jun 2015 17:17:42 -0400
Message-ID: <20150608211740.GA5241@gmail.com>
References: <1432236705-4209-1-git-send-email-j.glisse@gmail.com>
 <1432236705-4209-6-git-send-email-j.glisse@gmail.com>
 <alpine.DEB.2.00.1506081222270.27796@mdh-linux64-2.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1506081222270.27796-ptWJzH4JGIzJt4XymMeBgkn48jw8i0AO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org" <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brendan Conoboy <blc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joe Donohue <jdonohue-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 12:40:18PM -0700, Mark Hairgrove wrote:
>=20
>=20
> On Thu, 21 May 2015, j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>=20
> > From: J=E9r=F4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > This patch only introduce core HMM functions for registering a new
> > mirror and stopping a mirror as well as HMM device registering and
> > unregistering.
> >
> > [...]
> >
> > +/* struct hmm_device_operations - HMM device operation callback
> > + */
> > +struct hmm_device_ops {
> > +	/* release() - mirror must stop using the address space.
> > +	 *
> > +	 * @mirror: The mirror that link process address space with the d=
evice.
> > +	 *
> > +	 * When this is call, device driver must kill all device thread u=
sing
> > +	 * this mirror. Also, this callback is the last thing call by HMM=
 and
> > +	 * HMM will not access the mirror struct after this call (ie no m=
ore
> > +	 * dereference of it so it is safe for the device driver to free =
it).
> > +	 * It is call either from :
> > +	 *   - mm dying (all process using this mm exiting).
> > +	 *   - hmm_mirror_unregister() (if no other thread holds a refere=
nce)
> > +	 *   - outcome of some device error reported by any of the device
> > +	 *     callback against that mirror.
> > +	 */
> > +	void (*release)(struct hmm_mirror *mirror);
> > +};
>=20
> The comment that ->release is called when the mm dies doesn't match t=
he
> implementation. ->release is only called when the mirror is destroyed=
, and
> that can only happen after the mirror has been unregistered. This may=
 not
> happen until after the mm dies.
>=20
> Is the intent for the driver to get the callback when the mm goes dow=
n?
> That seems beneficial so the driver can kill whatever's happening on =
the
> device. Otherwise the device may continue operating in a dead address
> space until the driver's file gets closed and it unregisters the mirr=
or.

This was the intent before merging free & release. I guess i need to
reinstate the free versus release callback. Sadly the lifetime for HMM
is more complex than mmu_notifier as we intend the mirror struct to
be embedded into a driver private struct.

>=20
> > +static void hmm_mirror_destroy(struct kref *kref)
> > +{
> > +	struct hmm_device *device;
> > +	struct hmm_mirror *mirror;
> > +	struct hmm *hmm;
> > +
> > +	mirror =3D container_of(kref, struct hmm_mirror, kref);
> > +	device =3D mirror->device;
> > +	hmm =3D mirror->hmm;
> > +
> > +	mutex_lock(&device->mutex);
> > +	list_del_init(&mirror->dlist);
> > +	device->ops->release(mirror);
> > +	mutex_unlock(&device->mutex);
> > +}
>=20
> The hmm variable is unused. It also probably isn't safe to access at =
this
> point.

hmm_unref(hmm); was lost somewhere probably in a rebase and it is safe =
to
access hmm here.

>=20
>=20
> > +static void hmm_mirror_kill(struct hmm_mirror *mirror)
> > +{
> > +	down_write(&mirror->hmm->rwsem);
> > +	if (!hlist_unhashed(&mirror->mlist)) {
> > +		hlist_del_init(&mirror->mlist);
> > +		up_write(&mirror->hmm->rwsem);
> > +
> > +		hmm_mirror_unref(&mirror);
> > +	} else
> > +		up_write(&mirror->hmm->rwsem);
> > +}
>=20
> Shouldn't this call hmm_unref? hmm_mirror_register calls hmm_ref but
> there's no corresponding hmm_unref when the mirror goes away. As a re=
sult
> the hmm struct gets leaked and thus so does the entire mm since
> mmu_notifier_unregister is never called.
>=20
> It might also be a good idea to set mirror->hmm =3D NULL here to prev=
ent
> accidental use in say hmm_mirror_destroy.

No, hmm_mirror_destroy must be the one doing the hmm_unref(hmm)

>=20
>=20
> > +/* hmm_device_unregister() - unregister a device with HMM.
> > + *
> > + * @device: The hmm_device struct.
> > + * Returns: 0 on success or -EBUSY otherwise.
> > + *
> > + * Call when device driver want to unregister itself with HMM. Thi=
s will check
> > + * that there is no any active mirror and returns -EBUSY if so.
> > + */
> > +int hmm_device_unregister(struct hmm_device *device)
> > +{
> > +	mutex_lock(&device->mutex);
> > +	if (!list_empty(&device->mirrors)) {
> > +		mutex_unlock(&device->mutex);
> > +		return -EBUSY;
> > +	}
> > +	mutex_unlock(&device->mutex);
> > +	return 0;
> > +}
>=20
> I assume that the intention is for the caller to spin on
> hmm_device_unregister until -EBUSY is no longer returned?
>=20
> If so, I think there's a race here in the case of mm teardown happeni=
ng
> concurrently with hmm_mirror_unregister. This can happen if the paren=
t
> process was forked and exits while the child closes the file, or if t=
he
> file is passed to another process and closed last there while the ori=
ginal
> process exits.
>=20
> The upshot is that the hmm_device may still be referenced by another
> thread even after hmm_device_unregister returns 0.
>=20
> The below sequence shows how this might happen. Coming into this, the
> mirror's ref count is 2:
>=20
> Thread A (file close)               Thread B (process exit)
> ----------------------              ----------------------
>                                     hmm_notifier_release
>                                       down_write(&hmm->rwsem);
> hmm_mirror_unregister
>   hmm_mirror_kill
>     down_write(&hmm->rwsem);
>     // Blocked on thread B
>                                       hlist_del_init(&mirror->mlist);
>                                       up_write(&hmm->rwsem);
>=20
>                                       // Thread A unblocked
>                                       // Thread B is preempted
>     // hlist_unhashed returns 1
>     up_write(&hmm->rwsem);
>=20
>   // Mirror ref goes 2 -> 1
>   hmm_mirror_unref(&mirror);
>=20
>   // hmm_mirror_unregister returns
>=20
> At this point hmm_mirror_unregister has returned to the caller but th=
e
> mirror still is in use by thread B. Since all mirrors have been
> unregistered, the driver in thread A is now free to call
> hmm_device_unregister.
>=20
>                                       // Thread B is scheduled
>=20
>                                       // Mirror ref goes 1 -> 0
>                                       hmm_mirror_unref(&mirror);
>                                         hmm_mirror_destroy(&mirror)
>                                           mutex_lock(&device->mutex);
>                                           list_del_init(&mirror->dlis=
t);
>                                           device->ops->release(mirror=
);
>                                           mutex_unlock(&device->mutex=
);
>=20
> hmm_device_unregister
>   mutex_lock(&device->mutex);
>   // Device list empty
>   mutex_unlock(&device->mutex);
>   return 0;
> // Caller frees device
>=20
> Do you agree that this sequence can happen, or am I missing something
> which prevents it?

Can't happen because child have mm->hmm =3D NULL ie only one hmm per mm
and hmm is tie to only one mm. It is the responsability of the device
driver to make sure same apply to private reference to the hmm mirror
struct ie hmm_mirror should never be tie to a private file struct.

>=20
> If this can happen, the problem is that the only thing preventing thr=
ead A
> from freeing the device is that thread B has device->mutex locked. Th=
at's
> bad, because a lock within a structure cannot be used to control free=
ing
> that structure. The mutex_unlock in thread B may internally still acc=
ess
> the mutex memory even after the atomic operation which unlocks the mu=
tex
> and unblocks thread A.
>=20
> This can't be solved by having the driver wait for the ->release mirr=
or
> callback before it calls hmm_device_unregister, because the race happ=
ens
> after that point.
>=20
> A kref on the device itself might solve this, but the core issue IMO =
is
> that hmm_mirror_unregister doesn't wait for hmm_notifier_release to
> complete before returning. It feels like hmm_mirror_unregister wants =
to do
> a synchronize_srcu on the mmu_notifier srcu. Is that possible?

I guess i need to revisit once again the whole lifetime issue.

>=20
> Whatever the resolution, it would be useful for the block comments of
> hmm_mirror_unregister and hmm_device_unregister to describe the
> expectations on the caller and what the caller is guaranteed as far a=
s
> mirror and device lifetimes go.

Yes i need to fix comment and add again spend time on lifetime. I
obviously completely screw that up in that version of the patchset.

Cheers,
J=E9r=F4me
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
