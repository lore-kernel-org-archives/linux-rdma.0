From: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: [PATCH 05/36] HMM: introduce heterogeneous memory management v3.
Date: Wed, 10 Jun 2015 11:42:38 -0400
Message-ID: <20150610154237.GA13465@gmail.com>
References: <1432236705-4209-1-git-send-email-j.glisse@gmail.com>
 <1432236705-4209-6-git-send-email-j.glisse@gmail.com>
 <alpine.DEB.2.00.1506081222270.27796@mdh-linux64-2.nvidia.com>
 <20150608211740.GA5241@gmail.com>
 <alpine.DEB.2.00.1506081841490.1802@mdh-linux64-2.nvidia.com>
 <20150609155601.GA3101@gmail.com>
 <alpine.DEB.2.00.1506091939490.21359@mdh-linux64-2.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1506091939490.21359@mdh-linux64-2.nvidia.com>
Sender: owner-linux-mm@kvack.org
To: Mark Hairgrove <mhairgrove@nvidia.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>, "joro@8bytes.org" <joro@8bytes.org>, Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Johannes Weiner <jweiner@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>, Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>, Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Lucien Dunning <ldunning@nvidia.com>, Cameron Buschardt <cabuschardt@nvidia.com>, Arvind Gopalakrishnan <arvindg@nvidia.com>, Haggai
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 09, 2015 at 08:33:12PM -0700, Mark Hairgrove wrote:
>=20
>=20
> On Tue, 9 Jun 2015, Jerome Glisse wrote:
>=20
> > On Mon, Jun 08, 2015 at 06:54:29PM -0700, Mark Hairgrove wrote:
> > > Can you clarify how that's different from mmu_notifiers? Those are =
also
> > > embedded into a driver-owned struct.
> >=20
> > For HMM you want to be able to kill a mirror from HMM, you might have=
 kernel
> > thread call inside HMM with a mirror (outside any device file lifetim=
e) ...
> > The mirror is not only use at register & unregister, there is a lot m=
ore thing
> > you can call using the HMM mirror struct.
> >=20
> > So the HMM mirror lifetime as a result is more complex, it can not si=
mply be
> > free from the mmu_notifier_release callback or randomly. It needs to =
be
> > refcounted.
>=20
> Sure, there are driver -> HMM calls like hmm_mirror_fault that=20
> mmu_notifiers don't have, but I don't understand why that fundamentally=
=20
> makes HMM mirror lifetimes more complex. Decoupling hmm_mirror lifetime=
=20
> from mm lifetime adds complexity too.

Driver->HMM calls can happen from random kernel thread thus you need to
garanty that hmm_mirror can not go away. More over you can have CPU MM
call into HMM outside of mmu_notifier. Basicly you can get to HMM code
by many different code path, unlike any of the current mmu_notifier.

So refcounting is necessary as otherwise the device driver might decide
to unregister and free the mirror while some other kernel thread is
about to dereference the exact same mirror. Synchronization with mmu
notifier srcu will not be enough in the case of page fault on remote
memory for instance. Other case too.

>=20
> > The mmu_notifier code assume that the mmu_notifier struct is
> > embedded inside a struct that has a lifetime properly synchronize wit=
h the
> > mm. For HMM mirror this is not something that sounds like a good idea=
 as there
> > is too many way to get it wrong.
>=20
> What kind of synchronization with the mm are you referring to here?=20
> Clients of mmu_notifiers don't have to do anything as far as I know.=20
> They're guaranteed that the mm won't go away because each registered=20
> notifier bumps mm_count.

So for all current user afaict (kvm, xen, intel, radeon) tie to a file,
(sgi gru) tie to vma, (iommu) tie to mm. Which means this is all properly
synchronize with lifetime of mm (ignoring the fork case).

The struct that is tie to mmu_notifier for all of them can be accessed
only through one code path (ioctl for most of them).

>=20
> > So idea of HMM mirror is that it can out last the mm lifetime but the=
 HMM
> > struct can not. So you have hmm_mirror <~> hmm <-> mm and the mirror =
can be
> > "unlink" and have different lifetime from the hmm that itself has sam=
e life
> > time as mm.
>=20
> Per the earlier discussion hmm_mirror_destroy is missing a call to=20
> hmm_unref. If that's added back I don't understand how the mirror can=20
> persist past the hmm struct. The mirror can be unlinked from hmm's list=
,=20
> yes, but that doesn't mean that hmm/mm can be torn down. The hmm/mm=20
> structs will stick around until hmm_destroy since that does the=20
> mmu_notifier_unregister. hmm_destroy can't be called until the last=20
> hmm_mirror_destroy.
>=20
> Doesn't that mean that hmm/mm are guaranteed to be allocated until the=20
> last hmm_mirror_unregister? That sounds like a good guarantee to make.

Like said, just ignore current code it is utterly broken in so many way
when it comes to lifetime. I screw that part badly when reworking the
patchset, i was focusing on other part.

I fixed that in my tree, i am waiting for more review on other part as
anyway the lifetime thing is easy to rework/fix.

http://cgit.freedesktop.org/~glisse/linux/log/?h=3Dhmm

[...]
> > > > > If so, I think there's a race here in the case of mm teardown h=
appening
> > > > > concurrently with hmm_mirror_unregister.
> > > > >
> > > > > [...]
> > > > >
> > > > > Do you agree that this sequence can happen, or am I missing som=
ething
> > > > > which prevents it?
> > > >
> > > > Can't happen because child have mm->hmm =3D NULL ie only one hmm =
per mm
> > > > and hmm is tie to only one mm. It is the responsability of the de=
vice
> > > > driver to make sure same apply to private reference to the hmm mi=
rror
> > > > struct ie hmm_mirror should never be tie to a private file struct=
.
> > >=20
> > > It's useful for the driver to have some association between files a=
nd
> > > mirrors. If the file is closed prior to process exit we would like =
to
> > > unregister the mirror, otherwise it will persist until process tear=
down.
> > > The association doesn't have to be 1:1 but having the files ref cou=
nt the
> > > mirror or something would be useful.
> >=20
> > This is allowed, i might have put strong word here, but you can assoc=
iate
> > with a file struct. What you can not do is use the mirror from a diff=
erent
> > process ie one with a different mm struct as mirror is linked to a si=
ngle
> > mm. So on fork there is no callback to update the private file struct=
, when
> > the device file is duplicated (well just refcount inc) against a diff=
erent
> > process. This is something you need to be carefull in your driver. In=
side
> > the dummy driver i abuse that to actually test proper behavior of HMM=
 but
> > it should not be use as an example.
>=20
> So to confirm, on all file operations from user space the driver is=20
> expected to check that current->mm matches the mm associated with the=20
> struct file's hmm_mirror?

Well you might have a valid usecase for that, just be aware that
anything your driver do with the hmm_mirror will actually impact
the mm of the parent. Which i assume is not what you want.

I would actualy thought that what you want is having a way to find
hmm_mirror using both device file & mm as a key. Otherwise you can
not really use HMM with process that like to fork themself. Which
is a valid usecase to me. For instance process start using HMM
through your driver, decide to fork itself and to also use HMM
through your driver inside its child.

>=20
> On file->release the driver still ought to call hmm_mirror_unregister=20
> regardless of whether the mms match, otherwise we'll never tear down th=
e=20
> mirror. That means we're not saved from the race condition because=20
> hmm_mirror_unregister can happen in one thread while hmm_notifier_relea=
se=20
> might be happening in another thread.

Again there is no race the mirror list is the synchronization point and
it is protected by a lock. So either hmm_mirror_unregister() wins or the
other thread hmm_notifier_release()

> > > But even if we assume no association at all between files and mirro=
rs, are
> > > you sure that prevents the race? The driver may choose to unregiste=
r the
> > > hmm_device at any point once its files are closed. In the case of m=
odule
> > > unload the device unregister can't be prevented. If mm teardown has=
n't
> > > happened yet mirrors may still be active and registered on that
> > > hmm_device. The driver thus has to first call hmm_mirror_unregister=
 on all
> > > active mirrors, then call hmm_device_unregister. mm teardown of tho=
se
> > > mirrors may trigger at any point in this sequence, so we're right b=
ack to
> > > that race.
> >=20
> > So when device driver unload the first thing it needs to do is kill a=
ll of
> > its context ie all of its HMM mirror (unregister them) by doing so it=
 will
> > make sure that there can be no more call to any of its functions.
>=20
> When is the driver expected to call hmm_mirror_unregister? Is it file=20
> close, module unload, or some other time?
>=20
> If it's file close, there's no need to unregister anything on module=20
> unload because the files were all closed already.
>=20
> If it's module unload, then the mirrors and mms all get leaked until th=
at=20
> point.
>=20
> We're exposed to the race in both cases.

You unregister as soon as you want, it is up to your driver to do it,
i do not enforce anything. The only thing i enforce is that you can
not unregister the hmm device driver before all mirror are unregistered
and free.

So yes for device driver you want to unregister when device file is
close (which happens when the process exit).

In both cases there is no race as explain above.

>=20
> >=20
> > The race with mm teardown does not exist as what matter for mm teardo=
wn is
> > the fact that the mirror is on the struct hmm mirrors list or not. Ei=
ther
> > the device driver is first to remove the mirror from the list or it i=
s the
> > mm teardown but this is lock protected so only one thread can do it.
> >=20
>=20
> Agreed, removing the mirror from the list is not a "race" in the classi=
cal=20
> sense. The true race is between hmm_notifier_release's device mutex_unl=
ock=20
> (process exit) and post-hmm_device_unregister device mutex free (driver=
=20
> close/unload). What I meant is that in order to expose that race you fi=
rst=20
> need one thread to call hmm_mirror_unregister while another thread is i=
n=20
> hmm_notifier_release.
>=20
> Regardless of where hmm_mirror_unregister is called (file close, module=
=20
> unload, etc) it can happen concurrently with hmm_notifier_release so we=
're=20
> exposed to this race.

There is no race here, the mirror struct will only be freed once as again
the list is a synchronization point. Whoever remove the mirror from the
list is responsible to drop the list reference.

In the fixed code the only thing that will happen twice is the ->release(=
)
callback. Even that can be work around to garanty it is call only once.

Anyway i do not see anyrace here.

Cheers,
J=E9r=F4me

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
