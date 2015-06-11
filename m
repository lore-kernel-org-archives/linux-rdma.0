From: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: [PATCH 05/36] HMM: introduce heterogeneous memory management v3.
Date: Thu, 11 Jun 2015 10:23:14 -0400
Message-ID: <20150611142313.GA26195@gmail.com>
References: <1432236705-4209-1-git-send-email-j.glisse@gmail.com>
 <1432236705-4209-6-git-send-email-j.glisse@gmail.com>
 <alpine.DEB.2.00.1506081222270.27796@mdh-linux64-2.nvidia.com>
 <20150608211740.GA5241@gmail.com>
 <alpine.DEB.2.00.1506081841490.1802@mdh-linux64-2.nvidia.com>
 <20150609155601.GA3101@gmail.com>
 <alpine.DEB.2.00.1506091939490.21359@mdh-linux64-2.nvidia.com>
 <20150610154237.GA13465@gmail.com>
 <alpine.DEB.2.00.1506101757580.8383@mdh-linux64-2.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1506101757580.8383@mdh-linux64-2.nvidia.com>
Sender: owner-linux-mm@kvack.org
To: Mark Hairgrove <mhairgrove@nvidia.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>, "joro@8bytes.org" <joro@8bytes.org>, Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Johannes Weiner <jweiner@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>, Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>, Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Lucien Dunning <ldunning@nvidia.com>, Cameron Buschardt <cabuschardt@nvidia.com>, Arvind Gopalakrishnan <arvindg@nvidia.com>, Haggai
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 10, 2015 at 06:15:08PM -0700, Mark Hairgrove wrote:

[...]
> > There is no race here, the mirror struct will only be freed once as a=
gain
> > the list is a synchronization point. Whoever remove the mirror from t=
he
> > list is responsible to drop the list reference.
> >=20
> > In the fixed code the only thing that will happen twice is the ->rele=
ase()
> > callback. Even that can be work around to garanty it is call only onc=
e.
> >=20
> > Anyway i do not see anyrace here.
> >=20
>=20
> The mirror lifetime is fine. The problem I see is with the device lifet=
ime=20
> on a multi-core system. Imagine this sequence:
>=20
> - On CPU1 the mm associated with the mirror is going down
> - On CPU2 the driver unregisters the mirror then the device
>=20
> When this happens, the last device mutex_unlock on CPU1 is the only thi=
ng=20
> preventing the free of the device in CPU2. That doesn't work, as descri=
bed=20
> in this thread: https://lkml.org/lkml/2013/12/2/997
>=20
> Here's the full sequence again with mutex_unlock split apart. Hopefully=
=20
> this shows the device_unregister problem more clearly:
>=20
> CPU1 (mm release)                   CPU2 (driver)
> ----------------------              ----------------------
> hmm_notifier_release
>   down_write(&hmm->rwsem);
>   hlist_del_init(&mirror->mlist);
>   up_write(&hmm->rwsem);
>=20
>   // CPU1 thread is preempted or=20
>   // something
>                                     hmm_mirror_unregister
>                                       hmm_mirror_kill
>                                         down_write(&hmm->rwsem);
>                                         // mirror removed by CPU1 alrea=
dy
>                                         // so hlist_unhashed returns 1
>                                         up_write(&hmm->rwsem);
>=20
>                                       hmm_mirror_unref(&mirror);
>                                       // Mirror ref now 1
>=20
>                                       // CPU2 thread is preempted or
>                                       // something
> // CPU1 thread is scheduled
>=20
> hmm_mirror_unref(&mirror);
>   // Mirror ref now 0, cleanup
>   hmm_mirror_destroy(&mirror)
>     mutex_lock(&device->mutex);
>     list_del_init(&mirror->dlist);
>     device->ops->release(mirror);
>       kfree(mirror);
>                                       // CPU2 thread is scheduled, now
>                                       // both CPU1 and CPU2 are running
>=20
>                                     hmm_device_unregister
>                                       mutex_lock(&device->mutex);
>                                         mutex_optimistic_spin()
>     mutex_unlock(&device->mutex);
>       [...]
>       __mutex_unlock_common_slowpath
>         // CPU2 releases lock
>         atomic_set(&lock->count, 1);
>                                           // Spinning CPU2 acquires now=
-
>                                           // free lock
>                                       // mutex_lock returns
>                                       // Device list empty
>                                       mutex_unlock(&device->mutex);
>                                       return 0;
>                                     kfree(hmm_device);
>         // CPU1 still accessing=20
>         // hmm_device->mutex in=20
>         //__mutex_unlock_common_slowpath

Ok i see the race you are afraid of and really it is an unlikely one
__mutex_unlock_common_slowpath() take a spinlock right after allowing
other to take the mutex, when we are in your scenario there is no
contention on that spinlock so it is taken right away and as there
is no one in the mutex wait list then it goes directly to unlock the
spinlock and return. You can ignore the debug function as if debugging
is enabled than the mutex_lock() would need to also take the spinlock
and thus you would have proper synchronization btw 2 thread thanks to
the mutex.wait_lock.

So basicly while CPU1 is going :
spin_lock(mutex.wait_lock)
if (!list_empty(mutex.wait_list)) {
  // wait_list is empty so branch not taken
}
spin_unlock(mutex.wait_lock)

CPU2 would have to test the mirror list and mutex_unlock and return
before the spin_unlock() of CPU1. This is a tight race, i can add a
synchronize_rcu() to device_unregister after the mutex_unlock() so
that we also add a grace period before the device is potentialy freed
which should make that race completely unlikely.

Moreover for something really bad to happen it would need that the
freed memory to be reallocated right away by some other thread. Which
really sound unlikely unless CPU1 is the slowest of all :)

Cheers,
J=E9r=F4me

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
