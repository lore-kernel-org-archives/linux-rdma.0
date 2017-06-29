From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Add wait/retry version of ibnl_unicast
Date: Thu, 29 Jun 2017 08:04:36 +0300
Message-ID: <20170629050436.GO1248@mtr-leonro.local>
References: <1498658565-3408-1-git-send-email-mustafa.ismail@intel.com>
 <20170628141211.GA16312@ctung-MOBL3.amr.corp.intel.com>
 <20170628153639.GF1248@mtr-leonro.local>
 <20170628203003.GA23300@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VJvbhUb+lmZn6RCr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628203003.GA23300-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--VJvbhUb+lmZn6RCr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 28, 2017 at 03:30:03PM -0500, Chien Tin Tung wrote:
> On Wed, Jun 28, 2017 at 06:36:39PM +0300, Leon Romanovsky wrote:
> > On Wed, Jun 28, 2017 at 09:12:11AM -0500, Chien Tin Tung wrote:
> > > On Wed, Jun 28, 2017 at 09:02:45AM -0500, Mustafa Ismail wrote:
> > > > Add a wait/retry version of ibnl_unicast, ibnl_unicast_wait,
> > > > and modify ibnl_unicast to not wait/retry.  This eliminates
> > > > the undesirable wait for future users of ibnl_unicast.
> > > >
> > > > Change Portmapper calls originating from kernel to user-space
> > > > to use ibnl_unicast_wait and take advantage of the wait/retry
> > > > logic in netlink_unicast.
> > > >
> > > > Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/core/iwpm_msg.c |  6 +++---
> > > >  drivers/infiniband/core/netlink.c  | 12 +++++++++++-
> > > >  include/rdma/rdma_netlink.h        | 10 ++++++++++
> > > >  3 files changed, 24 insertions(+), 4 deletions(-)
> > >
> > > Please apply this patch instead of Leon's patch to revert
> > > "IB/core: Add flow control to the portmapper netlink calls".
> > >
> > > Leon, we can work out names and parameters if this works for you.
> >
> > Chien,
> >
> > The names are less my worries with this patch. First of all, it misleads
> > by using wait/retry naming, because it blocks and not waits.
>
> Nope.  It does a single shot retry and waits in a waitqueue.
> Go look at netlink_unicast and in turn netlink_attachskb.  If you still
> disagree, please flag specific code where it blocks.

I agree, it wouldn't block in your scenario. However will it work in more h=
ostile
environments?

For example, malicious user can open RDMA netlink socket directly (socket(.=
=2E.)),
set sndtimeo to be MAX_SCHEDULE_TIMEOUT - 1 (LONG_MAX - 1) and send custom
netlink messages right to your new _wait function. If I understand correctly
=66rom the code, it will add them to waitqueue and won't release skb till
the end of processing.

Will it cause to mark whole netlink socket as NETLINK_S_CONGESTED?
Will other users will be able to progress with their messages or they
will need to wait till those _wait calls finish?

>
> Here are the two functions for your convenience.
>
>
> int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
>                     u32 portid, int nonblock)
> {
>         struct sock *sk;
>         int err;
>         long timeo;
>
>         skb =3D netlink_trim(skb, gfp_any());
>
>         timeo =3D sock_sndtimeo(ssk, nonblock);
> retry:
>         sk =3D netlink_getsockbyportid(ssk, portid);
>         if (IS_ERR(sk)) {
>                 kfree_skb(skb);
>                 return PTR_ERR(sk);
>         }
>         if (netlink_is_kernel(sk))
>                 return netlink_unicast_kernel(sk, skb, ssk);
>
>         if (sk_filter(sk, skb)) {
>                 err =3D skb->len;
>                 kfree_skb(skb);
>                 sock_put(sk);
>                 return err;
>         }
>
>         err =3D netlink_attachskb(sk, skb, &timeo, ssk);
>         if (err =3D=3D 1)
>                 goto retry;
>         if (err)
>                 return err;
>
>         return netlink_sendskb(sk, skb);
> }
>
> /*
>  * Attach a skb to a netlink socket.
>  * The caller must hold a reference to the destination socket. On error, =
the
>  * reference is dropped. The skb is not send to the destination, just all
>  * all error checks are performed and memory in the queue is reserved.
>  * Return values:
>  * < 0: error. skb freed, reference to sock dropped.
>  * 0: continue
>  * 1: repeat lookup - reference dropped while waiting for socket memory.
>  */
> int netlink_attachskb(struct sock *sk, struct sk_buff *skb,
>                       long *timeo, struct sock *ssk)
> {
>         struct netlink_sock *nlk;
>
>         nlk =3D nlk_sk(sk);
>
>         if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
>              test_bit(NETLINK_S_CONGESTED, &nlk->state))) {
>                 DECLARE_WAITQUEUE(wait, current);
>                 if (!*timeo) {
>                         if (!ssk || netlink_is_kernel(ssk))
>                                 netlink_overrun(sk);
>                         sock_put(sk);
>                         kfree_skb(skb);
>                         return -EAGAIN;
>                 }
>
>                 __set_current_state(TASK_INTERRUPTIBLE);
>                 add_wait_queue(&nlk->wait, &wait);
>
>                 if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
>                      test_bit(NETLINK_S_CONGESTED, &nlk->state)) &&
>                     !sock_flag(sk, SOCK_DEAD))
>                         *timeo =3D schedule_timeout(*timeo);
>
>                 __set_current_state(TASK_RUNNING);
>                 remove_wait_queue(&nlk->wait, &wait);
>                 sock_put(sk);
>
>                 if (signal_pending(current)) {
>                         kfree_skb(skb);
>                         return sock_intr_errno(*timeo);
>                 }
>                 return 1;
>         }
>         netlink_skb_set_owner_r(skb, sk);
>         return 0;
> }
>
>
> BTW, _nobody_ is resetting the socket attribute from O_NONBLOCK.
>
> It is very difficult to understand your argument of "blocking" when you a=
re not
> sharing the specifics.  Please put your finger on it so everyone can unde=
rstand
> your point.

I hope that I succeeded to answer on your questions.

>
> > The second, I disagree with solution in kernel for user space applicati=
on which can't
> > handle the netlink errors.
>
> There is no guarantee delivery nor blocking on send.  Like I mentioned ab=
ove,
> it is a 1 shot retry with a set wait time.  The code obviousely handles e=
rror
> condition as it can happen.

So, can you please refresh our memory and explain again what exactly
this patch is fixing if user-space handles errors correctly?

>
>
> Chien

--VJvbhUb+lmZn6RCr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllUimQACgkQ5GN7iDZy
WKe94g/9ELAmJPLerYD0qtChsqtnUM9USU0GCnLdreMfozaeaAJKYpQ9EF6uEGHX
UpouITsLqmP24y0Q7bidCq++b156axmUD3sV5Ptu1+VWwaHdoR/71hmTgOkv8kvM
BgzIH+sM/han1853W+1OH4trEbc+GHREz2PcNafO4cFMvaB13/U+zWk8pd8wo7DY
ikPivZl0yHZs02wGcgLypcbXvwwHXCauPpxaQ4TgmaxYDJlhbtz0S0PRI6ehXag2
lXrIw7a6pm4p6cYl714OIz//I6JxTgMxrbRkaCcA0WEzbvcN5KpHAiJfH1KxbILX
fFeuKUtY25zVNYr2MZTJ/uJCWWxVWM8O+DHUXzh1JIfMy6a839io8SkeWpWperRT
z5gd2/41nP2OiDlF9MqPNzhOC+ZXbNKQ2RvT9/CDFPkKBZYDGPHw0F8wlXsWFumt
T0SlArwFjH+iQncgEwgwLc1b8ZgRNZ+WNODs0UayIRzXN22UIJ5u+xOiRoc7//SW
ohFe9imseDjjKHu8O1QCDFEW7A/rw3Mw07fDMWJvkxuT5iAGj7+NT1Nk0ZstWT6H
ElY0B4CTm5nfI8buidyyzem7aA88A72GuvKFkGVfc9Q+wsgIAnVBHexztPdWW6CF
jSLujkKr2h0O9+S8shoRFWSAGVMTTElcihKXlH90SNqDxCSj1Hc=
=+G/6
-----END PGP SIGNATURE-----

--VJvbhUb+lmZn6RCr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
