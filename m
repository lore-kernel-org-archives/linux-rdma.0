From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH for-next 3/9] RDMA/hns: Add return statement when kzalloc
 return NULL in hns_roce_v1_recreate_lp_qp
Date: Thu, 28 Sep 2017 15:59:12 +0300
Message-ID: <20170928125912.GU2297@mtr-leonro.local>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
 <1506574654-56699-4-git-send-email-xavier.huwei@huawei.com>
 <20170928091308.GT2297@mtr-leonro.local>
 <59CCE38B.4040408@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aTHdXM4WpLndGb15"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <59CCE38B.4040408@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, xavier.huwei@tom.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com
List-Id: linux-rdma@vger.kernel.org


--aTHdXM4WpLndGb15
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 28, 2017 at 07:56:59PM +0800, Wei Hu (Xavier) wrote:
>
>
> On 2017/9/28 17:13, Leon Romanovsky wrote:
> > On Thu, Sep 28, 2017 at 12:57:28PM +0800, Wei Hu (Xavier) wrote:
> > > From: Lijun Ou <oulijun@huawei.com>
> > >
> > > When lp_qp_work is NULL, it should be returned ENOMEM. This patch
> > > mainly fixes it.
> > >
> > > Ihis patch fixes the smatch error as below:
> > > drivers/infiniband/hw/hns/hns_roce_hw_v1.c:918 hns_roce_v1_recreate_l=
p_qp()
> > > error: potential null dereference 'lp_qp_work'.  (kzalloc returns nul=
l)
> > >
> > > Signed-off-by: Lijun Ou <oulijun@huawei.com>
> > > Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
> > > Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
> > > ---
> > >   drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/inf=
iniband/hw/hns/hns_roce_hw_v1.c
> > > index 95f5c88..1071fa2 100644
> > > --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > > +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > > @@ -912,6 +912,8 @@ static int hns_roce_v1_recreate_lp_qp(struct hns_=
roce_dev *hr_dev)
> > >
> > >   	lp_qp_work =3D kzalloc(sizeof(struct hns_roce_recreate_lp_qp_work),
> > >   			     GFP_KERNEL);
> > > +	if (!lp_qp_work)
> > > +		return -ENOMEM;
> > >
> > You will treat this error in the same was as you will treat timeout,
> > which is wrong.
> Thanks,  Leon
> We will send v2 to fix the compatible warn info.

No, you missed the point.
=46rom the code flow below the behavior of hns_roce_v1_recreate_lp_qp
for ENOMEM and ETIMEOUT returns will be the same and it is wrong.

For the ETIMEOUT, you can continue, for ENOMEM, you should properly
unfold the whole flow.

Thanks


> > 1656          */
> > 1657         if (hr_dev->hw->dereg_mr && hns_roce_v1_recreate_lp_qp(hr_=
dev))
> > 1658                 dev_warn(&hr_dev->pdev->dev, "recreate lp qp timeo=
ut!\n");
> > 1659
> > 1660         p =3D (u32 *)(&addr[0]);
> >
> >
> > >   	INIT_WORK(&(lp_qp_work->work), hns_roce_v1_recreate_lp_qp_work_fn);
> > >
> > > --
> > > 1.9.1
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--aTHdXM4WpLndGb15
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnM8iAACgkQ5GN7iDZy
WKeo8A/+LntTRCibvesSgfGo8JHT+KhqZJ3B6QRk/3VeFcab9O0aTdiAXy+MAHYx
2MwREoZ+1C7+9oMdl2Jv4BrdN8WXscto6D872eG8jEUPft+0ZUvhccnEwNsg6bs0
NyW+BkVeWAIZVFcce/z9BZHYoQTv9BAUuI1ULyCIRy3fztq6qlzvD/io4OepoZd7
MzRbl1Na23dRZdzOFbC7Y8tz0NmFa9Pp1jSX5g3Uei/U7LrOGnuhV3yVfhMLNj7A
pACSC9CcaWcWWnjgoo/e0xy7U6ZoIPu18uF723fIvWdeKSnxuQWQTTwYQVTeOl90
mefnLSrOFrSnrK9dwoVJrP6DAx6VJwmaPPlGLXa+tW6SVybYsWb4c92oAm1agalm
RS4SPe0KlyDQEeK+vCNH7CD6bLrXf7i0T+xW6VATrpTx6ILCx5EwxVYMNImReTrk
97E9ConxAQibfFp85wqTXNz0rq6FQA+V7RN8QTww/NTENObREi/wD4dGtbxbYVFh
sKgwnbORnzgEhmJ+LQPc8Gugr2NCOm+k3JhByKRdZ2F+sjqBAnfbdtVRxm5+AmzW
CuS0spYYLIJbwx9gkm6olpm4PukZYWjaYGMtjaFYgsiwFM66qviXOQafLDY8FsW1
j4N0N0wFZFzpFYjNldvKxrwyI4YP6BSg7KhW2ZBkhAbP/cFsG6k=
=1GFs
-----END PGP SIGNATURE-----

--aTHdXM4WpLndGb15--
