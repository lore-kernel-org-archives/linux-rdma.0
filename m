From: Mark Hairgrove <mhairgrove@nvidia.com>
Subject: Re: [PATCH 05/36] HMM: introduce heterogeneous memory management
 v3.
Date: Tue, 9 Jun 2015 20:33:12 -0700
Message-ID: <alpine.DEB.2.00.1506091939490.21359@mdh-linux64-2.nvidia.com>
References: <1432236705-4209-1-git-send-email-j.glisse@gmail.com> <1432236705-4209-6-git-send-email-j.glisse@gmail.com> <alpine.DEB.2.00.1506081222270.27796@mdh-linux64-2.nvidia.com> <20150608211740.GA5241@gmail.com> <alpine.DEB.2.00.1506081841490.1802@mdh-linux64-2.nvidia.com>
 <20150609155601.GA3101@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-1789454448-1433907201=:21359"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150609155601.GA3101@gmail.com>
Sender: owner-linux-mm@kvack.org
To: Jerome Glisse <j.glisse@gmail.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>, "joro@8bytes.org" <joro@8bytes.org>, Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Johannes Weiner <jweiner@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>, Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>, Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Lucien Dunning <ldunning@nvidia.com>, Cameron Buschardt <cabuschardt@nvidia.com>, Arvind Gopalakrishnan <arvindg@nvidia.com>, Haggai Eran <hag>
List-Id: linux-rdma@vger.kernel.org

--8323329-1789454448-1433907201=:21359
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable



On Tue, 9 Jun 2015, Jerome Glisse wrote:

> On Mon, Jun 08, 2015 at 06:54:29PM -0700, Mark Hairgrove wrote:
> > Can you clarify how that's different from mmu_notifiers? Those are al=
so
> > embedded into a driver-owned struct.
>=20
> For HMM you want to be able to kill a mirror from HMM, you might have k=
ernel
> thread call inside HMM with a mirror (outside any device file lifetime)=
 ...
> The mirror is not only use at register & unregister, there is a lot mor=
e thing
> you can call using the HMM mirror struct.
>=20
> So the HMM mirror lifetime as a result is more complex, it can not simp=
ly be
> free from the mmu_notifier_release callback or randomly. It needs to be
> refcounted.

Sure, there are driver -> HMM calls like hmm_mirror_fault that=20
mmu_notifiers don't have, but I don't understand why that fundamentally=20
makes HMM mirror lifetimes more complex. Decoupling hmm_mirror lifetime=20
from mm lifetime adds complexity too.

> The mmu_notifier code assume that the mmu_notifier struct is
> embedded inside a struct that has a lifetime properly synchronize with =
the
> mm. For HMM mirror this is not something that sounds like a good idea a=
s there
> is too many way to get it wrong.

What kind of synchronization with the mm are you referring to here?=20
Clients of mmu_notifiers don't have to do anything as far as I know.=20
They're guaranteed that the mm won't go away because each registered=20
notifier bumps mm_count.

> So idea of HMM mirror is that it can out last the mm lifetime but the H=
MM
> struct can not. So you have hmm_mirror <~> hmm <-> mm and the mirror ca=
n be
> "unlink" and have different lifetime from the hmm that itself has same =
life
> time as mm.

Per the earlier discussion hmm_mirror_destroy is missing a call to=20
hmm_unref. If that's added back I don't understand how the mirror can=20
persist past the hmm struct. The mirror can be unlinked from hmm's list,=20
yes, but that doesn't mean that hmm/mm can be torn down. The hmm/mm=20
structs will stick around until hmm_destroy since that does the=20
mmu_notifier_unregister. hmm_destroy can't be called until the last=20
hmm_mirror_destroy.

Doesn't that mean that hmm/mm are guaranteed to be allocated until the=20
last hmm_mirror_unregister? That sounds like a good guarantee to make.


>=20
> > Is the goal to allow calling hmm_mirror_unregister from within the "m=
m is
> > dying" HMM callback? I don't know whether that's really necessary as =
long
> > as there's some association between the driver files and the mirrors.
>=20
> No this is not a goal and i actualy forbid that.
>=20
> >=20
> > > > If so, I think there's a race here in the case of mm teardown hap=
pening
> > > > concurrently with hmm_mirror_unregister.
> > > >
> > > > [...]
> > > >
> > > > Do you agree that this sequence can happen, or am I missing somet=
hing
> > > > which prevents it?
> > >
> > > Can't happen because child have mm->hmm =3D NULL ie only one hmm pe=
r mm
> > > and hmm is tie to only one mm. It is the responsability of the devi=
ce
> > > driver to make sure same apply to private reference to the hmm mirr=
or
> > > struct ie hmm_mirror should never be tie to a private file struct.
> >=20
> > It's useful for the driver to have some association between files and
> > mirrors. If the file is closed prior to process exit we would like to
> > unregister the mirror, otherwise it will persist until process teardo=
wn.
> > The association doesn't have to be 1:1 but having the files ref count=
 the
> > mirror or something would be useful.
>=20
> This is allowed, i might have put strong word here, but you can associa=
te
> with a file struct. What you can not do is use the mirror from a differ=
ent
> process ie one with a different mm struct as mirror is linked to a sing=
le
> mm. So on fork there is no callback to update the private file struct, =
when
> the device file is duplicated (well just refcount inc) against a differ=
ent
> process. This is something you need to be carefull in your driver. Insi=
de
> the dummy driver i abuse that to actually test proper behavior of HMM b=
ut
> it should not be use as an example.

So to confirm, on all file operations from user space the driver is=20
expected to check that current->mm matches the mm associated with the=20
struct file's hmm_mirror?

On file->release the driver still ought to call hmm_mirror_unregister=20
regardless of whether the mms match, otherwise we'll never tear down the=20
mirror. That means we're not saved from the race condition because=20
hmm_mirror_unregister can happen in one thread while hmm_notifier_release=
=20
might be happening in another thread.


> >=20
> > But even if we assume no association at all between files and mirrors=
, are
> > you sure that prevents the race? The driver may choose to unregister =
the
> > hmm_device at any point once its files are closed. In the case of mod=
ule
> > unload the device unregister can't be prevented. If mm teardown hasn'=
t
> > happened yet mirrors may still be active and registered on that
> > hmm_device. The driver thus has to first call hmm_mirror_unregister o=
n all
> > active mirrors, then call hmm_device_unregister. mm teardown of those
> > mirrors may trigger at any point in this sequence, so we're right bac=
k to
> > that race.
>=20
> So when device driver unload the first thing it needs to do is kill all=
 of
> its context ie all of its HMM mirror (unregister them) by doing so it w=
ill
> make sure that there can be no more call to any of its functions.

When is the driver expected to call hmm_mirror_unregister? Is it file=20
close, module unload, or some other time?

If it's file close, there's no need to unregister anything on module=20
unload because the files were all closed already.

If it's module unload, then the mirrors and mms all get leaked until that=
=20
point.

We're exposed to the race in both cases.

>=20
> The race with mm teardown does not exist as what matter for mm teardown=
 is
> the fact that the mirror is on the struct hmm mirrors list or not. Eith=
er
> the device driver is first to remove the mirror from the list or it is =
the
> mm teardown but this is lock protected so only one thread can do it.
>=20

Agreed, removing the mirror from the list is not a "race" in the classica=
l=20
sense. The true race is between hmm_notifier_release's device mutex_unloc=
k=20
(process exit) and post-hmm_device_unregister device mutex free (driver=20
close/unload). What I meant is that in order to expose that race you firs=
t=20
need one thread to call hmm_mirror_unregister while another thread is in=20
hmm_notifier_release.

Regardless of where hmm_mirror_unregister is called (file close, module=20
unload, etc) it can happen concurrently with hmm_notifier_release so we'r=
e=20
exposed to this race.


> The issue you pointed is really about decoupling the lifetime of the mi=
rror
> context (ie hardware thread that use the mirror) and the lifetime of th=
e
> structure that embedded the hmm_mirror struct. The device driver will c=
are
> about the second while everything else will only really care about the
> first. The second tells you when you know for sure that there will be n=
o
> more callback to your device driver code. The first only tells you that
> there should be no more activity associated with that mirror but some t=
hread
> might still hold a reference on the underlying struct.
>=20
>=20
> Hope this clarify design and motivation behind the hmm_mirror vs hmm st=
ruct
> lifetime.
>=20
>=20
> Cheers,
> J=E9r=F4me
>=20
--8323329-1789454448-1433907201=:21359--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
