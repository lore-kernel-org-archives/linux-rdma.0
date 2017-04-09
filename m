From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v2 19/20] IB/rdmavt, IB/qib, IB/hfi1: Make percpu
 refcount optional for user MRs
Date: Sun, 9 Apr 2017 09:26:02 +0300
Message-ID: <20170409062602.GN2269@mtr-leonro.local>
References: <CALq1K=JsjSCiSBeZVe4kHQmjw7tznL36JcsamZTVGZ5RhBvZPw@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC342EA858@fmsmsx120.amr.corp.intel.com>
 <20170406074955.GG2269@mtr-leonro.local>
 <8cdf2fbb-f2a9-0b4b-b144-397ee73d1569@intel.com>
 <32E1700B9017364D9B60AED9960492BC342EABD0@fmsmsx120.amr.corp.intel.com>
 <20170406171354.GA19854@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC342EADEE@fmsmsx120.amr.corp.intel.com>
 <20170406174438.GA20020@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC342EBA18@fmsmsx120.amr.corp.intel.com>
 <20170407220618.GA29138@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zROEGoKAXsG5UqGB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170407220618.GA29138-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--zROEGoKAXsG5UqGB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 07, 2017 at 04:06:18PM -0600, Jason Gunthorpe wrote:
> On Fri, Apr 07, 2017 at 09:12:34PM +0000, Marciniszyn, Mike wrote:
> > > Umm.. This doesn't look like a refcount, it is a rwlock - why aren't you using
> > > the optimized percpu_rwsem?
> > >
> >
> > The refcount with a completion has been in qib and rdmavt for years
> > without issue.
>
> Doesn't change the fact this isn't a refcount behavior, it is a rwsem
> with write lock on destroy. A proper refcounf would destroy the object
> not call a completion.
>
> Doing things properly using the common primitives makes stuff work
> better, eg percpu_rwsem has sane lockdep.
>
> > All this being said, we have encountered a use case where the MR is
> > short lived and supports just one transaction.
>
> Well, yes, that is a pretty common idiom in kernel workloads too..
>
> > I have a prototype patch to pass a hint (no module parameter) to the
> > user MR registration via the access flags.
>
> Okay, so you'd have a IBV_MR_MULTI_THREADED to enable the RCU
> optimization?

It is not needed for kernel paths (RCU optimization).
There is get_nr_threads(struct task_struct *tsk) call to get number of threads.
However I don't know if it is appropriate to use that function in driver code.

If the goal to optimize the user space drivers, indeed the flag will be needed.

>
> That seems sort of consistent with some of the other flags we've had
> in the past (eg single threaded CQ polling optimization)
>
> > I don't think a two order of magnitude improvement is a micro optimization.
>
> The micro optimization was tring to optimize rwlock with percpu and
> RCU. The two order of magnitude penalty on the destroy and the new
> need for tuning knobs is the penalty for that.
>
> I doubt the percpu optimization was two orders of magnitude..
>
> > So the RCU grace period is problematic in this context as well.
>
> Of course, RCU is not designed to have these kinds of performance
> characteristics. If you define destroy to be a hot path then you can't
> use RCU here, the worst case RCU grace period times are potentually
> quite big..
>
> This is why you shouldn't have the RCU optimization on by default at
> all.
>
> Usually RCU grace period latency is solved by defering the write side
> to an async rcu grace period callback - why not do that instead of
> adding a flag? It feels like destroy is a reasonable candidate to do
> that kind of trick.
>
> Perhaps some kind of enhancement to percpu_rwsem such that it would
> asynchronously call a function with the write side lock held? Looks
> not to hard..
>
> Jason

--zROEGoKAXsG5UqGB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljp0/oACgkQ5GN7iDZy
WKcrzA//SpPMQWbUt8cJxW5EQkIRxvGPTD6EoAW3AH4DWq/Z2dNII6fMmfz8Lrit
z82/wPjbxV64iuKYzvh30ExaCyx8hxmuHFY6FXKSTzcBQO57xxamGbWllPJnTUiB
Xw75S75vSixXAF4LSvEsX51NJK/VmiwvdpcE29rSPjww6CxCPMROezWIkkrNdV6o
HruDLlzO01XRAa2KwjeZlOXOHWJJTQ0sJY88HCZeZMbgtn/6aIR0b04rtUzbNWVm
Jkqg6I5cHcYwz00KjkvcUpzuN/OV6OGZ5Aa5hDcS4rl19yKLi7xf26aJTcXNlyU3
fmnyIQz9jdFCnL0WZXZ07tZa8CCkcI32uJ7SzhF3joRC23Ijsj+PrtxFoEc49CkW
8BL1qhfVGw/NtjBkcpXac+jZmbjjxcdJn1CsXxoZju0oyu6GTCbNhcvpPHjBXgOi
rlV8yTXHz8rnUP+Shka8pBbvG9VDvZ7FOLaokOXUKIzI920qse05jOfsh5jC8o+a
pxrepxnj1ldFqUDTGkmt4Xul7Yk6mGzcLKKBkm2YOv4VcHCxUlV4vXrYg41K5SAO
UuXnpYB0EBh4Ak6DLlH56TUDc4SKPuspiJKGQ9+y1dSe4bqT2kRla4ob8rd7XrhT
U3QA837l/pmC5OKi05gAMuiWfDnmFrSJtS30Dt1HkXpcW8XRvdE=
=6wKu
-----END PGP SIGNATURE-----

--zROEGoKAXsG5UqGB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
