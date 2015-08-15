From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/22] iser patches for 4.3
Date: Fri, 14 Aug 2015 21:08:53 -0400
Message-ID: <55CE9125.1080407@redhat.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nQ06IoPGCu8eacMkwqXWfhk9XFnItgXvN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nQ06IoPGCu8eacMkwqXWfhk9XFnItgXvN
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/06/2015 11:32 AM, Sagi Grimberg wrote:
> This set is a resend that includes some extra patches that
> piled up in the meantime.
>=20
> I still have some patches in the pipe (including initiator/target
> support for remote invalidate) but I'm targeting those to 4.4
>=20
> I postponed the comment from Steve on using system PAGE_SIZE
> in patch 20 until I have access to a relevant arch to test on.
>=20
> This patch set includes:
> - Small fixes for bugs encountered in testing
> - Small fixes detected by static checkers
> - Memory registration code path rework (consolidate to
>   a single code path that branches only at the actual registration
>   FRWR vs. FMR). This reduces code duplication that exists in current c=
ode.
> - Larger IO transfer size support (up to 8MB at the moment) depending o=
n
>   the device capabilities.
> - Optimize Io path by chaining send work requests and posting them
>   only once.
>=20
> Changes from v0:
> - Added Fixes: tags to patches 4,6
> - Modified change logs for patche 20,22 to add some more details
>   (comments from Or)
>=20
> Adir Lev (1):
>   IB/iser: Maintain connection fmr_pool under a single registration
>     descriptor
>=20
> Jenny Falkovich (1):
>   IB/iser: Change some module parameters to be RO
>=20
> Sagi Grimberg (20):
>   IB/iser: Change minor assignments and logging prints
>   IB/iser: Remove '.' from log message
>   IB/iser: Fix missing return status check in iser_send_data_out
>   IB/iser: Get rid of un-maintained counters
>   IB/iser: Fix possible bogus DMA unmapping
>   IB/iser: Remove a redundant always-false condition
>   IB/iser: Remove an unneeded print for unaligned memory
>   IB/iser: Introduce struct iser_reg_resources
>   IB/iser: Rename struct fast_reg_descriptor -> iser_fr_desc
>   IB/iser: Remove dead code in fmr_pool alloc/free
>   IB/iser: Introduce iser_reg_ops
>   IB/iser: Move fastreg descriptor allocation to
>     iser_create_fastreg_desc
>   IB/iser: Introduce iser registration pool struct
>   IB/iser: Rename iser_reg_page_vec to iser_fast_reg_fmr
>   IB/iser: Make reg_desc_get a per device routine
>   IB/iser: Unify fast memory registration flows
>   IB/iser: Pass registration pool a size parameter
>   IB/iser: Support up to 8MB data transfer in a single command
>   IB/iser: Add debug prints to the various memory registration methods
>   IB/iser: Chain all iser transaction send work requests
>=20
>  drivers/infiniband/ulp/iser/iscsi_iser.c     |  89 +++--
>  drivers/infiniband/ulp/iser/iscsi_iser.h     | 206 ++++++++----
>  drivers/infiniband/ulp/iser/iser_initiator.c |  34 +-
>  drivers/infiniband/ulp/iser/iser_memory.c    | 480 +++++++++++++++----=
--------
>  drivers/infiniband/ulp/iser/iser_verbs.c     | 328 ++++++++++--------
>  5 files changed, 645 insertions(+), 492 deletions(-)
>=20

I've pulled these in as a replacement for the v0 patches.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nQ06IoPGCu8eacMkwqXWfhk9XFnItgXvN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzpElAAoJELgmozMOVy/d5xkP/0gSMGe4c0hrY2cwJlRvjhz2
niAUW659cLHPyLubtGQQXbbsU37B9mEuqZdyD06P78Y/URVWXEbX9VTDxUPXmpUV
gaeTdcqUqywfzk8oFRFm/Pw/LFHk6qN8ZNTQrcAG4e32wYga1Icuz2TR6sRbRJBv
ytK2KiReSXbttAhmqnu3tgES0tFYSJPWFsfOyx8GrcdNElRlW6yyr+ErRU+vMxKS
hK3j3pP0TuPNx8uCdXkDvVw1yepkynYMDcWNm/tCT6Fh5huQD4Nl8/YsC8E3qL6E
tvo1NLXCUYKjG0OcdO7U2/15RVEdSs1NsHFldkfRG3wb3Gp/yfKxk7xDrTeBeEz+
05qYgEaPLCyTFoe5qMVzb20OlsBNFXgS4f+Bhy+nCaiPdsYugtYwC+E8IYiaaw4c
vAmS11SvCxb48DbdlfjafXC4yCuwz5EkV/JcFXKp454izD90EumekPpxLRRo0fWq
qO5ykFHLm5WuQ+Ms0mDjDn4PfG0CK6QtZls/ATWf99VI9aN05iLIZJemu+pAV87+
XTD01kVI3BqZ39cHqTy/4kUF1vJ4ryuNyFi/TtnRN4nUKMcAGxnMxy1lwebDTROZ
SHiGH9e9kyLfHtVVbppbPJ16qzVuI5ir00Dal5poXSKXosV+zzAihrzrq5nC6suw
cFGm2cyl46+eSMUK/Li4
=jVlC
-----END PGP SIGNATURE-----

--nQ06IoPGCu8eacMkwqXWfhk9XFnItgXvN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
