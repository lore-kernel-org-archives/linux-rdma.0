From: Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/36] HMM: introduce heterogeneous memory management v3.
Date: Tue, 9 Jun 2015 11:56:03 -0400
Message-ID: <20150609155601.GA3101@gmail.com>
References: <1432236705-4209-1-git-send-email-j.glisse@gmail.com>
 <1432236705-4209-6-git-send-email-j.glisse@gmail.com>
 <alpine.DEB.2.00.1506081222270.27796@mdh-linux64-2.nvidia.com>
 <20150608211740.GA5241@gmail.com>
 <alpine.DEB.2.00.1506081841490.1802@mdh-linux64-2.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1506081841490.1802-ptWJzH4JGIzJt4XymMeBgkn48jw8i0AO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org" <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brendan Conoboy <blc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joe Donohue <jdonohue-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 06:54:29PM -0700, Mark Hairgrove wrote:
> On Mon, 8 Jun 2015, Jerome Glisse wrote:
> > On Mon, Jun 08, 2015 at 12:40:18PM -0700, Mark Hairgrove wrote:
> > > On Thu, 21 May 2015, j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > > > From: J=E9r=F4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > >
> > > > This patch only introduce core HMM functions for registering a =
new
> > > > mirror and stopping a mirror as well as HMM device registering =
and
> > > > unregistering.
> > > >
> > > > [...]
> > > >
> > > > +/* struct hmm_device_operations - HMM device operation callbac=
k
> > > > + */
> > > > +struct hmm_device_ops {
> > > > +	/* release() - mirror must stop using the address space.
> > > > +	 *
> > > > +	 * @mirror: The mirror that link process address space with t=
he device.
> > > > +	 *
> > > > +	 * When this is call, device driver must kill all device thre=
ad using
> > > > +	 * this mirror. Also, this callback is the last thing call by=
 HMM and
> > > > +	 * HMM will not access the mirror struct after this call (ie =
no more
> > > > +	 * dereference of it so it is safe for the device driver to f=
ree it).
> > > > +	 * It is call either from :
> > > > +	 *   - mm dying (all process using this mm exiting).
> > > > +	 *   - hmm_mirror_unregister() (if no other thread holds a re=
ference)
> > > > +	 *   - outcome of some device error reported by any of the de=
vice
> > > > +	 *     callback against that mirror.
> > > > +	 */
> > > > +	void (*release)(struct hmm_mirror *mirror);
> > > > +};
> > >
> > > The comment that ->release is called when the mm dies doesn't mat=
ch the
> > > implementation. ->release is only called when the mirror is destr=
oyed, and
> > > that can only happen after the mirror has been unregistered. This=
 may not
> > > happen until after the mm dies.
> > >
> > > Is the intent for the driver to get the callback when the mm goes=
 down?
> > > That seems beneficial so the driver can kill whatever's happening=
 on the
> > > device. Otherwise the device may continue operating in a dead add=
ress
> > > space until the driver's file gets closed and it unregisters the =
mirror.
> >
> > This was the intent before merging free & release. I guess i need t=
o
> > reinstate the free versus release callback. Sadly the lifetime for =
HMM
> > is more complex than mmu_notifier as we intend the mirror struct to
> > be embedded into a driver private struct.
>=20
> Can you clarify how that's different from mmu_notifiers? Those are al=
so
> embedded into a driver-owned struct.

=46or HMM you want to be able to kill a mirror from HMM, you might have=
 kernel
thread call inside HMM with a mirror (outside any device file lifetime)=
 ...
The mirror is not only use at register & unregister, there is a lot mor=
e thing
you can call using the HMM mirror struct.

So the HMM mirror lifetime as a result is more complex, it can not simp=
ly be
free from the mmu_notifier_release callback or randomly. It needs to be
refcounted. The mmu_notifier code assume that the mmu_notifier struct i=
s
embedded inside a struct that has a lifetime properly synchronize with =
the
mm. For HMM mirror this is not something that sounds like a good idea a=
s there
is too many way to get it wrong.

So idea of HMM mirror is that it can out last the mm lifetime but the H=
MM
struct can not. So you have hmm_mirror <~> hmm <-> mm and the mirror ca=
n be
"unlink" and have different lifetime from the hmm that itself has same =
life
time as mm.

> Is the goal to allow calling hmm_mirror_unregister from within the "m=
m is
> dying" HMM callback? I don't know whether that's really necessary as =
long
> as there's some association between the driver files and the mirrors.

No this is not a goal and i actualy forbid that.

>=20
> > > If so, I think there's a race here in the case of mm teardown hap=
pening
> > > concurrently with hmm_mirror_unregister.
> > >
> > > [...]
> > >
> > > Do you agree that this sequence can happen, or am I missing somet=
hing
> > > which prevents it?
> >
> > Can't happen because child have mm->hmm =3D NULL ie only one hmm pe=
r mm
> > and hmm is tie to only one mm. It is the responsability of the devi=
ce
> > driver to make sure same apply to private reference to the hmm mirr=
or
> > struct ie hmm_mirror should never be tie to a private file struct.
>=20
> It's useful for the driver to have some association between files and
> mirrors. If the file is closed prior to process exit we would like to
> unregister the mirror, otherwise it will persist until process teardo=
wn.
> The association doesn't have to be 1:1 but having the files ref count=
 the
> mirror or something would be useful.

This is allowed, i might have put strong word here, but you can associa=
te
with a file struct. What you can not do is use the mirror from a differ=
ent
process ie one with a different mm struct as mirror is linked to a sing=
le
mm. So on fork there is no callback to update the private file struct, =
when
the device file is duplicated (well just refcount inc) against a differ=
ent
process. This is something you need to be carefull in your driver. Insi=
de
the dummy driver i abuse that to actually test proper behavior of HMM b=
ut
it should not be use as an example.

>=20
> But even if we assume no association at all between files and mirrors=
, are
> you sure that prevents the race? The driver may choose to unregister =
the
> hmm_device at any point once its files are closed. In the case of mod=
ule
> unload the device unregister can't be prevented. If mm teardown hasn'=
t
> happened yet mirrors may still be active and registered on that
> hmm_device. The driver thus has to first call hmm_mirror_unregister o=
n all
> active mirrors, then call hmm_device_unregister. mm teardown of those
> mirrors may trigger at any point in this sequence, so we're right bac=
k to
> that race.

So when device driver unload the first thing it needs to do is kill all=
 of
its context ie all of its HMM mirror (unregister them) by doing so it w=
ill
make sure that there can be no more call to any of its functions.

The race with mm teardown does not exist as what matter for mm teardown=
 is
the fact that the mirror is on the struct hmm mirrors list or not. Eith=
er
the device driver is first to remove the mirror from the list or it is =
the
mm teardown but this is lock protected so only one thread can do it.

The issue you pointed is really about decoupling the lifetime of the mi=
rror
context (ie hardware thread that use the mirror) and the lifetime of th=
e
structure that embedded the hmm_mirror struct. The device driver will c=
are
about the second while everything else will only really care about the
first. The second tells you when you know for sure that there will be n=
o
more callback to your device driver code. The first only tells you that
there should be no more activity associated with that mirror but some t=
hread
might still hold a reference on the underlying struct.


Hope this clarify design and motivation behind the hmm_mirror vs hmm st=
ruct
lifetime.


Cheers,
J=E9r=F4me
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
