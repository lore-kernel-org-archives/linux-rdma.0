From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v6 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 25 Jan 2018 23:18:31 +0200
Message-ID: <20180125211831.GT1393@mtr-leonro.local>
References: <20180125151227.28202-1-leon@kernel.org>
 <20180125151227.28202-4-leon@kernel.org>
 <20180125174529.GB3739@ziepe.ca>
 <20180125194436.GR1393@mtr-leonro.local>
 <20180125201023.GA9162@ziepe.ca>
 <20180125202710.GS1393@mtr-leonro.local>
 <20180125210026.GA10719@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w0g8YuYCbDvF0cDN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180125210026.GA10719-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--w0g8YuYCbDvF0cDN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 25, 2018 at 02:00:26PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 25, 2018 at 10:27:10PM +0200, Leon Romanovsky wrote:
> > On Thu, Jan 25, 2018 at 01:10:23PM -0700, Jason Gunthorpe wrote:
> > > On Thu, Jan 25, 2018 at 09:44:36PM +0200, Leon Romanovsky wrote:
> > > > > > +	/*
> > > > > > +	 * @kref: Protect destroy of the resource
> > > > > > +	 */
> > > > > > +	struct kref		kref;
> > > > >
> > > > > Sticking a kref in a random structure that is itself not malloc'd is a
> > > > > big red flag:
> > > >
> > > > It is not "rand", but embedded part of ib_qp,ib_pd and ib_cq. It is
> > > > malloced as part of their creation.
> > >
> > > I mean the kref isn't in any way linked the lifetime of the malloc
> > > that contains it. So it isn't really a kref, it is just a refcount.
> >
> > For now, yes, in the future no. IMHO it is the direction to manage RDMA
> > objects.
>
> Maybe but until we do that this doesn't have struct kref semantics at
> all and shouldn't be called kref..

You are actually open-coded kref semantics with addition of completions.

>
> > > What I sent you wasn't remotely like this, it had two nested locks,
> > > the outer mutex and a very special open coded inner read/write lock
> > > that doesn't deadlock when nested..
> >
> > I still didn't like your approach, because it has three words which i don't want
> > to see here: "special open-coded variant". I believe that the way to go is to add
> > completion structure and convert _del to be something like that:
>
> Well, we can code the same idea with a completion, it is a little
> clearer but uses more memory for the per-object completion struct.
>
> Read side:
>   mutex_lock(list_lock)
>   for_each_list(...,obj...) { // Must NOT use _safe here
>      // The object is in process of being deleted
>      if (refcount_inc_not_zero(&obj->refcount))
>           continue;
>      mutex_unlock(list_lock);
>       ...
>      mutex_lock(list_lock);
>      if (refcount_dec_and_test(&obj->recount))
>          complete(&res->completion);
>   }
>
> Destroy side:
>    if (refcount_dec_and_test(&obj->ref))
>          complete(&obj->completion);
>    wait_for_completion(obj->free);
>
>    mutex_lock(list_lock)
>    list_del(obj);
>
>
> The refcount starts at 1 during init. Destroy triggers the freeing
> process by decr. Once the refcount reaches 0 it latches at 0 as 'to be
> destroyed' and the pointer can never leave the list_lock critical
> section.
>
> It is still tricky..

This is more or less how nldev does reads, with exception that counters
(kref) incremented and decremented under r/w semaphore, it eliminates the
check "if (refcount_inc_not_zero(&obj->refcount))" and instead complete
it calls to release (kref semantics).

It is worth to read the nldev part too.

The bug is that I didn't block rdma_restrack_del(), but the semantics
and locking scheme is right.

Thanks

>
> Jason

--w0g8YuYCbDvF0cDN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpqSacACgkQ5GN7iDZy
WKeWMA//aa7UM6w3epWDMrST95tqrh7hKZzIoD8PK6vi3VCw1ZCc229GVsDzYHfx
MOuJpAgoknJNN7PAUxWseNX91Ma/FrfaV+Q2hFmosjJuGHVrsoO/MCF8UtTgZhYE
3qLG5BPPwwPw7zxa77+fpSamt8nD/fPHtG4d7tNQq6ahiZu+EXuMm6WRtC1pbSRf
IOA2l/L7KIay8HXy1fAFXdXlFHslQ0UNiIy32aHsGz9zbgN0rUz9ZQupx3XGqgG9
9lFsSDe7OTcvqlKVagA1xi/Ltpklak5Ed788EDTZoMJSuP3pKh4W9nJPnzskQi/d
HdbFJkQ/2TouGWXUjgGNglaCyfgd3YUZflpVs5N218G5GNI3f7IC5WxzOCakDR8y
cCSWQ/N1AVbV3/8FX5VuRvSL/Erfr9zPUJplWJG4l31qlq6YiHH7/q5CtmhCaaOz
aqaXb9mkqEMSZi2+BgsRM3PBesZMbJ5by7hacXwHtUxov9al9C9G307Wr26w5gYQ
QoJKJ8ENkf/8Kt+YcCxC9N9QoshuJsjhLkYrCNW36nAdemt1vyJk4/MZ0B99Grkp
MORl+2cYI9RiTpxASLUSJsBpeO+pPvK9norzdaUbEwfDpz5z3apv2xX4dWxZOiu0
ycxL7EtNoomLIERikeZDs8xS+1XdnXSjtbl+trYkwjD6ezHg0bg=
=e7tO
-----END PGP SIGNATURE-----

--w0g8YuYCbDvF0cDN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
