From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Add wait/retry version of ibnl_unicast
Date: Thu, 29 Jun 2017 19:37:19 +0300
Message-ID: <20170629163719.GC12009@mtr-leonro.local>
References: <1498658565-3408-1-git-send-email-mustafa.ismail@intel.com>
 <20170628141211.GA16312@ctung-MOBL3.amr.corp.intel.com>
 <20170628153639.GF1248@mtr-leonro.local>
 <20170628203003.GA23300@ctung-MOBL3.amr.corp.intel.com>
 <20170629050436.GO1248@mtr-leonro.local>
 <20170629150249.GA21856@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170629150249.GA21856-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 29, 2017 at 10:02:49AM -0500, Chien Tin Tung wrote:
> On Thu, Jun 29, 2017 at 08:04:36AM +0300, Leon Romanovsky wrote:
> > On Wed, Jun 28, 2017 at 03:30:03PM -0500, Chien Tin Tung wrote:
> > > On Wed, Jun 28, 2017 at 06:36:39PM +0300, Leon Romanovsky wrote:
> > > > On Wed, Jun 28, 2017 at 09:12:11AM -0500, Chien Tin Tung wrote:
> > > > > On Wed, Jun 28, 2017 at 09:02:45AM -0500, Mustafa Ismail wrote:
> > > > > > Add a wait/retry version of ibnl_unicast, ibnl_unicast_wait,
> > > > > > and modify ibnl_unicast to not wait/retry.  This eliminates
> > > > > > the undesirable wait for future users of ibnl_unicast.
> > > > > >
> > > > > > Change Portmapper calls originating from kernel to user-space
> > > > > > to use ibnl_unicast_wait and take advantage of the wait/retry
> > > > > > logic in netlink_unicast.
> > > > > >
> > > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > > Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > > ---
> > > > > >  drivers/infiniband/core/iwpm_msg.c |  6 +++---
> > > > > >  drivers/infiniband/core/netlink.c  | 12 +++++++++++-
> > > > > >  include/rdma/rdma_netlink.h        | 10 ++++++++++
> > > > > >  3 files changed, 24 insertions(+), 4 deletions(-)
> > > > >
> > > > > Please apply this patch instead of Leon's patch to revert
> > > > > "IB/core: Add flow control to the portmapper netlink calls".
> > > > >
> > > > > Leon, we can work out names and parameters if this works for you.
> > > >
> > > > Chien,
> > > >
> > > > The names are less my worries with this patch. First of all, it misleads
> > > > by using wait/retry naming, because it blocks and not waits.
> > >
> > > Nope.  It does a single shot retry and waits in a waitqueue.
> > > Go look at netlink_unicast and in turn netlink_attachskb.  If you still
> > > disagree, please flag specific code where it blocks.
> >
> > I agree, it wouldn't block in your scenario. However will it work in more hostile
> > environments?
>
> The reason behind the original patch was to make it more tolerable to "hostile"
> environments by giving it one more try allocate buffer to send the message.
> So yes, it does work in more hostile environment.

Are you really calling extra load as a "hostile environment"?

>
> >
> > For example, malicious user can open RDMA netlink socket directly (socket(...)),
> > set sndtimeo to be MAX_SCHEDULE_TIMEOUT - 1 (LONG_MAX - 1)
>
> How do you open the _kernel_ RDMA netlink socket directly from user-space and
> set the timeout value?

Exactly as libnl, libmnl and rdma-core do. The netlink socket is
accessible from the user space without root access. It is the whole
purpose of it.

>
> > and send custom
> > netlink messages right to your new _wait function. If I understand correctly
> > from the code, it will add them to waitqueue and won't release skb till
> > the end of processing.
>
> The only caller of ibnl_unicast_wait is portmapper kernel client.  The call is
> initiated from kernel not in response to user message so you did not understand
> the code correctly.

Maybe and maybe you didn't read your code at all.

Calls to _unicast are triggered from kernel for LS only, in you case as
an example the request to get RDMA_NL_IWPM_MAPINFO will trigger ibnl_unicast_wait.

>
> > Will it cause to mark whole netlink socket as NETLINK_S_CONGESTED?
>
> No.  It has nothing to do with the new function or relevant to this discussion.

Again, read the source, the netlink socket overrun will set that flag.

>
> > Will other users will be able to progress with their messages or they
> > will need to wait till those _wait calls finish?
>
> Short answer is yes.  With this patch other users of ibnl_unicast would not
> get the retry/wait.  If you choose to use the wait version, obviousely you will
> have retry/wait.  For the work you are doing, you should stick with ibnl_unicast
> and there's no impact to your code.  This is the reason for the two functions as
> proposed originally.

Again, read the code and my proposed scenario. User without root
permissions can open netlink socket (I'm doing it in rdmatool) and can
send any message he wants. He can and will overflow the calls with
ibnl_unicast_wait, so no other user will have resources available.

>
> > > > The second, I disagree with solution in kernel for user space application which can't
> > > > handle the netlink errors.
> > >
> > > There is no guarantee delivery nor blocking on send.  Like I mentioned above,
> > > it is a 1 shot retry with a set wait time.  The code obviousely handles error
> > > condition as it can happen.
> >
> > So, can you please refresh our memory and explain again what exactly
> > this patch is fixing if user-space handles errors correctly?
>
> You assertion of user-space flaw is incorrect.  It is based on incorrect
> conclusion of deadlock and blocking.
>
> There is no deadlock and no blocking, period.

That question doesn't assume anything. I'm still asking what exactly are
you fixing?
>
>
> So what's the issue with taking this patch instead of the revert?

It doesn't fix anything broken in kernel.

>
> Chien
>

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllVLL8ACgkQ5GN7iDZy
WKcbAA//frVAc4GUuE0CUY3Ihx+ISMWU9aWGa/ycHhB1FJu26yE6+ElKSrNDPHSg
pZGDjQi/eNsZcYdymZZq04PqP9rRk6lOKx5tw1UjPlId6oOV0+Or7jiXMg4TW5F4
gmpFDHfavzUa1tSeYkcNFOFRLOAi/oeDOE5lzDqOcnY+9jQfF46DiW65oXALEY7h
2IgdpZSPoVElIB3lSxYEisTx7uA/ZK9My9dG6iTgiV/oK882NxVb9VDe401GAXRO
3JBarxa4l2N/UsRNzQwPVP0JPtY/IQBv9KHTHjbXxinQGAIMkFx6mo1NbIxDVOY0
A926zzFRGkQP42u+crNclehLKvvMJs86SkfZ3C7Hfmye30b2wZg5xWF6UpW0QwvG
r5477YtHkyll6EPxw8zXXTT/GkcW+JJ1vb3k3I86uF7rZhOKnoUgEnGjoaD/7E8b
OoL+m21VU4mE7gN26ULWcHW49P5guVu2sq/3c9J3RqPck/8Q6pH2z8Y/KadIsFrz
sHESnOPoFUtkWPixKb37FTnSyxGXPDGGdsS2SNA8gwvJRAgII7yGo9AeCQs82h//
vVXplzhOmDZ9LJ62dqBqvchDF+GvXUA3NIsUTO12SQe8/tHpGNBVfcKxDIU5Wfqd
HRvscYDb70hO4eJBiO58qeJcinb0wWVgsqzL20V06R+ue0Y1kkA=
=pNr9
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
