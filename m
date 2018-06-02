From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v3 00/14] Verbs flow counters support
Date: Sat, 2 Jun 2018 08:04:19 +0300
Message-ID: <20180602050419.GH2843@mtr-leonro.mtl.com>
References: <20180531134341.18441-1-leon@kernel.org>
 <20180601211149.GA24028@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="y2zxS2PfCDLh6JVG"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601211149.GA24028@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--y2zxS2PfCDLh6JVG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 01, 2018 at 03:11:49PM -0600, Jason Gunthorpe wrote:
> On Thu, May 31, 2018 at 04:43:27PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog:
> > v2->v3:
> >  * Change function mlx5_fc_query signature to hide the details of
> >    internal core driver struct mlx5_fc
> >  * Add commen to data[] field at struct mlx5_ib_flow_counters_data (mlx5-abi.h)
> >  * Use array of struct mlx5_ib_flow_counters_desc to clarify the output
> > v1->v2:
> >  * Removed conversion from struct mlx5_fc* to void*
> >  * Fixed one place with double space in it
> >  * Balanced release of hardware handler in case of counters allocation failure
> >  * Added Tested-by
> >  * Minimize time spent holding mutex lock
> >  * Fixed deadlock caused by nested lock in error path
> >  * Protect from handler pointer derefence in the error paths
>
> Okay,
>
> Acked-by: Jason Gunthorpe <jgg@mellanox.com>
>
> I've revised some of the commit messages, fixed the two bad
> check-patch warnings, and fixed the patch ordering..
>
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=wip/jgg-counters
>
> Please send a PR with the mlx-core bits and above commits.

Hi,

I applied two mlx5-next commits to the relevant tree:
https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/commit/?h=mlx5-next&id=930821e39d0a5f91ed58fea1692afe04f0fe0e1f
https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/commit/?h=mlx5-next&id=5f9bf63ae80c4d0e5e986b6c1280bf8174978545

In first commit, I dropped the words "as used to be", per-Saeed's request.

The proper signed tag for whole the series is: verbs_flow_counters
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/verbs_flow_counters

Thanks

>
> Thanks,
> Jason

--y2zxS2PfCDLh6JVG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbEiVTAAoJEORje4g2clinOlsP/jmDywMxEUAIUpS0V2DZF94j
Mr0LL0JImPBp2xdoQiVMYCpIT9Hx0O2NaeHxO7D8QyLZVsK0RLsDXrFDGrkPk3eB
Kw1GQdXlWHqLUGhtgiyxEGbj2F9jWHIjsUkrMRFc0IHvEakEX62HhnlgTtm+XxAb
WZFao8ZWe0FEbv3G3q5FP+6xkHcNQrt4L6HpndtZIL/IVXWU7hnC/611hxCMB5Ip
OUCCItb324rJuSPafEzyBw7mmM16leFnTu9w8ZhX68x9laXtUsqM6HRMeMzcklD2
h0l1dmDkmxMNRr+HqJTA4zJuMfQLcUHzRTS3siLaG1O8tp0OOkICneeOhKfGBXRJ
75dD3hTeiKJnxaEz8WzW7dWwAsPaejVacwgiTZ3S5yp43wK7eCX+nrbKoL4CVCZ8
eAl/mqUibaLKUoCYq7Ht3a8JGiC47fTzFVC5Us26HWfgMbko+qcT6d8m56wqCy0S
cJJoQwM3S8HdgOJ03lDuWML5YG786BkT6l+eWn8REa0hr5KOj0JBpLxdlJDmIrFs
ZU2tEfWIeRqGr9UyWYc8wtnH1LkrhJKcLJQrX7P/3gDy7IZmipCx45SW9Zgd638f
chF06x3YmAJL3jbr1hdCG1u4ZbIv1n89kwcQSbf8sXp6O3mgK9ioPWhOPJiOcBOu
DSBpdC/CSqLSAcs7YB2z
=tkiJ
-----END PGP SIGNATURE-----

--y2zxS2PfCDLh6JVG--
