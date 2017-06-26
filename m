From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 1/5] RDMA/netlink: Remove netlink clients
 infrastructure
Date: Mon, 26 Jun 2017 22:11:54 +0300
Message-ID: <20170626191154.GG1248@mtr-leonro.local>
References: <20170613085927.2908-1-leon@kernel.org>
 <20170613085927.2908-2-leon@kernel.org>
 <20170626175505.GA2904@ctung-MOBL3.amr.corp.intel.com>
 <20170626181324.GE1248@mtr-leonro.local>
 <20170626183329.GA11716@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qCuyVVLLFvr0p6ls"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170626183329.GA11716-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--qCuyVVLLFvr0p6ls
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 26, 2017 at 01:33:29PM -0500, Chien Tin Tung wrote:
> On Mon, Jun 26, 2017 at 09:13:24PM +0300, Leon Romanovsky wrote:
> > On Mon, Jun 26, 2017 at 12:55:05PM -0500, Chien Tin Tung wrote:
> > > On Tue, Jun 13, 2017 at 03:59:23AM -0500, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > RDMA netlink has complicated infrastructure to add and remove netli=
nk
> > > > clients to NETLINK_RDMA family. This complicates the code and not in
> > > > use because not many clients are available (3 clients) and most of =
them
> > > > (2 clients) are statically compiled together with netlink.c.
> > > >
> > > > The following patch refactors RDMA netlink and opens door for the f=
uture
> > > > patches which will be able to get rid of a lot of dead iwcm* code.
> > > >
> > > > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > Reviewed-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/core/cma.c     |   6 +-
> > > >  drivers/infiniband/core/device.c  |  41 +++------
> > > >  drivers/infiniband/core/iwcm.c    |  10 +--
> > > >  drivers/infiniband/core/netlink.c | 185 ++++++++++++++++++--------=
------------
> > > >  include/rdma/rdma_netlink.h       |  17 ++--
> > > >  5 files changed, 110 insertions(+), 149 deletions(-)
> > >
> > > > diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlin=
k.h
> > > > index 585266144329..6735dcf5d2a3 100644
> > > > --- a/include/rdma/rdma_netlink.h
> > > > +++ b/include/rdma/rdma_netlink.h
> > > > @@ -10,27 +10,22 @@ struct ibnl_client_cbs {
> > > >         struct module *module;
> > > >  };
> > > >
> > > > -int ibnl_init(void);
> > > > -void ibnl_cleanup(void);
> > > > +int rdma_nl_init(void);
> > > > +void rdma_nl_exit(void);
> > >
> > > This hunk is in direct conflict with 233c1955 which you removed
> > > ibnl_init and ibnl_cleanup.  Are you putting back the init and
> > > exit or do you want to leave them out?
> >
> > We have different git hashes and I don't know about which commit you are
> > referring.
>
> There is only one true upstream, go look at Linus' git.
>
> >
> > This commit simply renames exit/init functions in general header file.
> > The init/exit is still needed, because it is called from device.c.
> >
> > The git log doesn't show me anything suspicious too.
> > =E2=9E=9C  linux-rdma git:(topic/rdma-netlink-v1) git log -p include/rd=
ma/rdma_netlink.h
>
> Your git and branch is out of sync.  This is the relevant part of the pat=
ch.
>
> commit 233c1955835bd8649003be9bb3d8e79788b08be1
> Author: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Sun May 14 15:49:57 2017 +0300
>
>     RDMA/netlink: Reduce exposure of RDMA netlink functions
>
>     RDMA netlink is part of ib_core, hence ibnl_chk_listeners(),
>     ibnl_init() and ibnl_cleanup() don't need to be published
>     in public header file.
>
>     Let's remove EXPORT_SYMBOL from ibnl_chk_listeners() and move all the=
se
>     functions to private header file.
>
>     CC: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>     Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
> index 5852661..348c102 100644
> --- a/include/rdma/rdma_netlink.h
> +++ b/include/rdma/rdma_netlink.h
> @@ -10,9 +10,6 @@ struct ibnl_client_cbs {
>         struct module *module;
>  };
>
> -int ibnl_init(void);
> -void ibnl_cleanup(void);
> -

Thanks,

It is rebase error, those functions needs to be in core_priv.h. I'll resend.

>
>
> Chien

--qCuyVVLLFvr0p6ls
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllRXHkACgkQ5GN7iDZy
WKfhUQ/9FQ7sBTjT1rsWcDT4mawym/iDwlVVB7oMlzcGuaEdD5Ip0SpSCTc0OqBg
s+NBnXdWg/pSlWNWkTscVWq9eP8N/naG1um8fWPIGPG/8pRLv0Tat4DRPtZMJQds
O38SOAa7g+EhkQJc9zw5N+Dcthp4h0supOB2CqWPCUXW/EdSlao056v1swWEFfbT
0xUU0/pVHbHCHKVBwa5Cgz/OGVDA0Ko3uNjD/9lPTHVYQz9qKi1k2N40MQpGC27m
BdnQ/NCKZfjMU8ogRD/yV8SE2btbkc6bh76VPtiwCTTXbDfRfqfm628pA9ioIBHY
LP12r50xQfAUtqP1f2qED0/45xMaBtuYkTRCmC9jxnWkuoSQ46EPBNg+isiPBy/w
XV5ZA6VB3nbnE7ovzEdPT+AyqY6ASe47SxlV5a/5sBa+GO2QnRKxbo7wOKttcYVH
mQ07F56V3FTJmOIflqv56u/oFqDKcmeGfVj5ClYugWWRrpt7GmOvAfXZ4Q3aE0tJ
XzDIGM0DV0c7iFFxwRu1ACwYnVJiMZxV1udnF20p1i6Sg8r4maKik2iq46OUJDxj
MzXBOJ8sdpracCKjPziRll7YBYeLTC9jl4BRsrQDJZdM3ldF2jHHd873FYuT/5fS
p+VFHzE/qqmm5Nb1fBZ9mw3CLYquUXN1+eq3fgzYLldyW3AD+io=
=TwXq
-----END PGP SIGNATURE-----

--qCuyVVLLFvr0p6ls--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
