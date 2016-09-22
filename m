From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH V2 for-next 00/19] IB/hns: Fixes for various misc. bugs
Date: Thu, 22 Sep 2016 16:37:09 +0300
Message-ID: <20160922133709.GG4088@leon.nu>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fCcDWlUEdh43YKr8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Salil Mehta <salil.mehta@huawei.com>
Cc: dledford@redhat.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org


--fCcDWlUEdh43YKr8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 20, 2016 at 05:06:53PM +0100, Salil Mehta wrote:
> This patch-set introduces fixes for various bugs and potential
> problems found during internal review and testing phases of
> the HNS RoCE driver.
>
> NOTE: These fixes have been done over already floated CM
> patch: https://lkml.org/lkml/2016/9/1/609
>
> All fixes have been done & tested by Oulijun and Huwei.
>
> V1->V2: * PATCH 3/20 and 13/20 have been dropped after rework
>           of comments by Leon Romanovsky on V1 patch.
>         * New patch "Fix for removal of redundant code" has
>           been added to remove the redundant code.
>
> Lijun Ou (15):
>   IB/hns: Remove unused parameters in some functions
>   IB/hns: Remove parameters of resize cq
>   IB/hns: Fix bug of using uninit refcount and free
>   IB/hns: Simplify function of pd alloc and qp alloc
>   IB/hns: Remove unused parameter named qp_type
>   IB/hns: Modify the init of iboe lock
>   IB/hns: Fix bug of memory leakage for registering user mr
>   IB/hns: Return bad wr while post send failed
>   IB/hns: The Ack timeout need a lower limit value
>   IB/hns: Some items of qpc need to take user param
>   IB/hns: Validate mtu when modified qp
>   IB/hns: Cq has not been freed
>   IB/hns: Update the rq head when modify qp state
>   IB/hns: Fix the bug when platform_get_resource() exec fail
>   IB/hns: Delete the redundant lines in hns_roce_v1_m_qp()
>
> Salil Mehta (1):
>   IB/hns: Fix for removal of redundant code
>
> Wei Hu (Xavier) (3):
>   IB/hns: Fix bug of clear hem
>   IB/hns: Delete the sqp_start from the structure hns_roce_caps
>   IB/hns: Optimize code of aeq and ceq interrupt handle and fix the bug
>     of qpn
>
>  drivers/infiniband/hw/hns/hns_roce_cq.c     |  23 +--
>  drivers/infiniband/hw/hns/hns_roce_device.h |  13 +-
>  drivers/infiniband/hw/hns/hns_roce_eq.c     | 146 ++++++++++---------
>  drivers/infiniband/hw/hns/hns_roce_eq.h     |   4 +
>  drivers/infiniband/hw/hns/hns_roce_hem.c    |  76 +---------
>  drivers/infiniband/hw/hns/hns_roce_hem.h    |   4 +
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 211 +++++++++++++++++++++++-----
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |   9 ++
>  drivers/infiniband/hw/hns/hns_roce_main.c   |   4 +-
>  drivers/infiniband/hw/hns/hns_roce_mr.c     |   3 +
>  drivers/infiniband/hw/hns/hns_roce_pd.c     |  18 +--
>  drivers/infiniband/hw/hns/hns_roce_qp.c     |  57 +++-----
>  12 files changed, 312 insertions(+), 256 deletions(-)

Thanks Salil,
The change from v0 to v2 is astonishing !!!!!!

Reviewed-by: Leon Romanovsky <leonro@mellanox.com> for whole series.

>
> --
> 1.9.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--fCcDWlUEdh43YKr8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX496FAAoJEORje4g2clin0esQAIkBzxIGugIeSkq7gbBKdepk
ycHnddffRg9ZXAGFJ/vdaZDA63B6rV28A8OFEC53kEVn5EJbfu0GFK0u+dx+T9a+
WlxI2hHvzx4v8+Bci4hbUoWbvREmNUfRy37xtTeMttSxkOKs3M0BzK5WfgesqJh1
eTIOOPpkSRVIKqm4XrL1CWOlZ3XpLcBeE3Lp2z9Uu+mYT9mrXpfX8ITl1QEU6/AT
jqmC/APbCUbmD0GGeFSYvogMhAPTXbic2aFaSBT12CLrHL3/jxODeiFMd87xwvUA
G1/u2gqm7JylN31uTxOjFroH8sCaVv+dKzNjurqIx1Q6zVLnRdnOsalFUjeWY5bE
XIaNldkLP+u3pwlTiorn7IB9ffcp4U24b3GFAgt4z0v/Jyugyill4dra1D7uqJoC
AI35OFMgeVcKNqapQ1hhFEqEtAp8SoPyhifb1fp1PnHc/XFFgY6iEHVHi+EvXxTQ
OBpzmu+je+TCy+SLbFJv4MuneiN1pRYnjyv4OftR2LsbVs+aIYiLCZDkJgQ3Pd17
hzINniSjrWOMia1M+FXLFht3Bron9wpBKzD/IOm93QAqaQaBi4Te7l+2TjVc6hNm
cwzVzTz7Qq1JFzKFpglAfjjEgz0i8GIa1nTQpnHlDGC9NzPtBes/duu/YVHJMhwP
roeKNb829T3PdawUFq/G
=b9ME
-----END PGP SIGNATURE-----

--fCcDWlUEdh43YKr8--
