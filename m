From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/8] More warning fixing
Date: Sat, 15 Oct 2016 12:46:59 +0300
Message-ID: <20161015094659.GA25013@leon.nu>
References: <1476483257-16308-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476483257-16308-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 14, 2016 at 04:14:09PM -0600, Jason Gunthorpe wrote:
> This batch is on top of the series from Christoph Hellwig, it turns on a few
> more useful gcc warnings and fixes the fall out.
>
> Whole batch is here now: https://github.com/linux-rdma/rdma-core/pull/19

Thanks, applied whole batch.

>
> Jason Gunthorpe (8):
>   rdmacm: constify rdma_getaddrinfo public function
>   Enable -Wwrite-strings
>   verbs: Use cmake to detect if net/if.h vs netling/route/link.h is
>     broken
>   Enable -Wredundant-decls
>   acm: Fix wrong format attributes for error
>   acm: Fix format string usage with acm_log
>   Enable -Wformat=2
>   Enable -Wshadow
>
>  CMakeLists.txt                      | 55 ++++++++++++++++++++++++++++++++
>  buildlib/config.h.in                |  2 ++
>  ibacm/include/infiniband/acm_prov.h |  7 +++--
>  ibacm/prov/acmp/src/acmp.c          | 38 ++++++++++++-----------
>  ibacm/src/acm.c                     | 25 ++++++++-------
>  ibacm/src/acm_util.h                |  6 ++--
>  ibacm/src/acme.c                    |  8 ++---
>  ibacm/src/parse.c                   |  2 +-
>  iwpmd/iwarp_pm.h                    |  2 +-
>  iwpmd/iwarp_pm_common.c             |  7 +++--
>  libibverbs/examples/srq_pingpong.c  |  1 -
>  libibverbs/examples/xsrq_pingpong.c |  6 ++--
>  libibverbs/neigh.c                  |  8 ++---
>  libibverbs/sysfs.c                  | 13 ++++----
>  libibverbs/verbs.h                  |  6 ++--
>  librdmacm/acm.c                     |  3 +-
>  librdmacm/addrinfo.c                | 14 +++++----
>  librdmacm/cma.h                     |  3 +-
>  librdmacm/examples/cmatose.c        |  2 +-
>  librdmacm/examples/cmtime.c         |  4 +--
>  librdmacm/examples/common.c         |  2 +-
>  librdmacm/examples/common.h         |  2 +-
>  librdmacm/examples/rcopy.c          |  2 +-
>  librdmacm/examples/rdma_client.c    |  4 +--
>  librdmacm/examples/rdma_server.c    |  2 +-
>  librdmacm/examples/rdma_xclient.c   |  2 +-
>  librdmacm/examples/rdma_xserver.c   |  2 +-
>  librdmacm/examples/riostream.c      | 36 ++++++++++-----------
>  librdmacm/examples/rping.c          |  2 +-
>  librdmacm/examples/rstream.c        | 52 +++++++++++++++----------------
>  librdmacm/examples/udaddy.c         |  2 +-
>  librdmacm/examples/udpong.c         | 62 ++++++++++++++++++-------------------
>  librdmacm/man/rdma_getaddrinfo.3    |  6 ++--
>  librdmacm/preload.c                 |  2 --
>  librdmacm/rdma_cma.h                |  4 +--
>  providers/mlx4/mlx4.h               |  6 ----
>  providers/mthca/cq.c                |  2 +-
>  srp_daemon/srp_daemon.c             | 29 ++++++++++-------
>  srp_daemon/srp_daemon.h             |  2 +-
>  39 files changed, 247 insertions(+), 186 deletions(-)
>
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYAfsTAAoJEORje4g2clinUoMP/0YRoHSBuPyZ2/2IN2H1/THi
PsNhGH5krrlFZdkkJnzMKSsghBT2b0Umi++7iq0xbaRWh+7K4g9b4Pnye1rREKsC
EDXxXUIglcvYKKTgfjdupvazYyPJ3tiIugavNzGuTvHfOFiQtkUA+SUKmYgPPTOL
prP3r2zfVmWIAg86KCEMZwvXesoyTXh1DvsKdWngblEM5nRLMAz7tB4o7Eb4UK8I
MehmTZViK2dinusaEFdXiPHCl4Zc6j0WzDh6Vz9/KX+4Avdtg6Vfnx4dei/s5z5s
mARpIbb/35gFFQ2tbpRu30uW6Iy3ePptVXaMa5mQLQ8/tOzTTlytmbOfpCqLqgst
B3ZUucbgCO128sOBOyNHp+gkraAipBMwOwxUdMAmfCBd98dG2dgtZLMOsbhBYrGf
La7KYhiE/ugWfp0ukpUir86THwnSYb26cNcNbbRQdfvWbZkj68yT7ZP48y0tSJje
44SfKukRuoti7Kn3F6/mFlrMgwL838rvaI9oTZ5xf5wCjpRHgocXCXBki/VrZWDO
c0Km7wfhahmsKLGSZdLo9ny/CkH2XPsq2LE5matYGidsiPqSfkL6ZVUCj2JKo327
nIzZYe/dC1WvYkooSM8UGJrj64/WWDBnPkrUAmbrJkU/tBvTUqgwC0+nnsKtKFcg
NQKJLmksHT5w5us4BrwH
=EhCM
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
