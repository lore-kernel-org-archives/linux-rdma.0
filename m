From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 19/20] IB/rdmavt, IB/qib, IB/hfi1: Make percpu
 refcount optional for user MRs
Date: Fri, 7 Apr 2017 21:12:34 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC342EBA18@fmsmsx120.amr.corp.intel.com>
References: <20170321002631.28538.2121.stgit@scvm10.sc.intel.com>
 <1491417489.2923.6.camel@redhat.com>
 <f008c532-340e-01f2-80e6-4bea74175e3e@intel.com>
 <CALq1K=JsjSCiSBeZVe4kHQmjw7tznL36JcsamZTVGZ5RhBvZPw@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC342EA858@fmsmsx120.amr.corp.intel.com>
 <20170406074955.GG2269@mtr-leonro.local>
 <8cdf2fbb-f2a9-0b4b-b144-397ee73d1569@intel.com>
 <32E1700B9017364D9B60AED9960492BC342EABD0@fmsmsx120.amr.corp.intel.com>
 <20170406171354.GA19854@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC342EADEE@fmsmsx120.amr.corp.intel.com>
 <20170406174438.GA20020@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170406174438.GA20020-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Umm.. This doesn't look like a refcount, it is a rwlock - why aren't you =
using
> the optimized percpu_rwsem?
>=20

The refcount with a completion has been in qib and rdmavt for years without=
 issue.

It is the best way to express having an MR's underlying pages held until al=
l of the "users" have finished.

When the count gets to zero, the completion is triggered and allows a dereg=
istration to complete.

What we have found is that as lkey and rkey validation calls scale out to m=
any cores/threads, the atomic operation causes excessive cache bouncing.

That is the motivation for using the percpu reference counting: to avoid th=
e bouncing in scaled out data path operations.

The information that is in include/linux/percpu-refcount.h and lib/percpu-r=
efcount.c has the API documentation and our use is consistent with other ca=
llers and was pretty much a drop in replacement for our older atomic operat=
ions.

>From the above header file:
 * This implements a refcount with similar semantics to atomic_t - atomic_i=
nc(),
 * atomic_dec_and_test() - but percpu.

The percpu rwsem seems more a drop-in replacement for the older rwlock_t st=
uff.

> ... micro-optimize it is fantastically ugly/bad
> taste.
>=20

All this being said, we have encountered a use case where the MR is short l=
ived and supports just one transaction.

In that case, the RCU quiescence during deregistration IS the performance b=
ottleneck.    As cores scale out, the RCU grace period can cause large dela=
ys.

I have a prototype patch to pass a hint (no module parameter) to the user M=
R registration via the access flags.

Before (no hint):
    -- Alloc memory: 4 us
    -- Zero memory: 1933 us
    -- Register: 112 us
    -- Unregister: 6086 us <------
    -- Free memory: 89 us

After (with hint):
    -- Alloc memory: 7 us
    -- Zero memory: 1929 us
    -- Register: 111 us
    -- Unregister: 49 us   <------
    -- Free memory: 85 us

I don't think a two order of magnitude improvement is a micro optimization.

Note that in percpu-rw-semaphore.txt:
   Locking for reading is very fast, it uses RCU and it avoids any atomic
   instruction in the lock and unlock path. On the other hand, locking for
   writing is very expensive, it calls synchronize_rcu() that can take
   hundreds of milliseconds.

So the RCU grace period is problematic in this context as well.

Mike


 =20


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
