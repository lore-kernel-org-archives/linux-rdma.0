From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 3/9] RDMA/hns: Add return statement when kzalloc
 return NULL in hns_roce_v1_recreate_lp_qp
Date: Fri, 29 Sep 2017 13:23:37 +0300
Message-ID: <20170929102337.GK2297@mtr-leonro.local>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
 <1506574654-56699-4-git-send-email-xavier.huwei@huawei.com>
 <20170928091308.GT2297@mtr-leonro.local>
 <59CCE38B.4040408@huawei.com>
 <20170928125912.GU2297@mtr-leonro.local>
 <59CDE31A.5090707@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IfjLu832HdL/xSp1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <59CDE31A.5090707-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--IfjLu832HdL/xSp1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 29, 2017 at 02:07:22PM +0800, Wei Hu (Xavier) wrote:
>
>
> On 2017/9/28 20:59, Leon Romanovsky wrote:
> > On Thu, Sep 28, 2017 at 07:56:59PM +0800, Wei Hu (Xavier) wrote:
> > >
> > > On 2017/9/28 17:13, Leon Romanovsky wrote:
> > > > On Thu, Sep 28, 2017 at 12:57:28PM +0800, Wei Hu (Xavier) wrote:
> > > > > From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > > >
> > > > > When lp_qp_work is NULL, it should be returned ENOMEM. This patch
> > > > > mainly fixes it.
> > > > >
> > > > > Ihis patch fixes the smatch error as below:
> > > > > drivers/infiniband/hw/hns/hns_roce_hw_v1.c:918 hns_roce_v1_recreate_lp_qp()
> > > > > error: potential null dereference 'lp_qp_work'.  (kzalloc returns null)
> > > > >
> > > > > Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > > > Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > > > Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > > > ---
> > > > >    drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 2 ++
> > > > >    1 file changed, 2 insertions(+)
> > > > >
> > > > > diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > > > > index 95f5c88..1071fa2 100644
> > > > > --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > > > > +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > > > > @@ -912,6 +912,8 @@ static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
> > > > >
> > > > >    	lp_qp_work = kzalloc(sizeof(struct hns_roce_recreate_lp_qp_work),
> > > > >    			     GFP_KERNEL);
> > > > > +	if (!lp_qp_work)
> > > > > +		return -ENOMEM;
> > > > >
> > > > You will treat this error in the same was as you will treat timeout,
> > > > which is wrong.
> > > Thanks,  Leon
> > > We will send v2 to fix the compatible warn info.
> > No, you missed the point.
> >  From the code flow below the behavior of hns_roce_v1_recreate_lp_qp
> > for ENOMEM and ETIMEOUT returns will be the same and it is wrong.
> >
> > For the ETIMEOUT, you can continue, for ENOMEM, you should properly
> > unfold the whole flow.
> >
> > Thanks
> >
> Hi, Leon
>     We prepare to modify the warn info as bleow:
>
>         if (hr_dev->hw->dereg_mr && hns_roce_v1_recreate_lp_qp(hr_dev))
>             dev_warn(&hr_dev->pdev->dev, "recreate lp qp failed!\n");
>
>     for -ETIMEDOUT,  there is a warn info as blow, but there isn't this one
> for -ENOMEM.
>         dev_warn(dev, "recreate lp qp failed 20s timeout and return
> failed!\n");
>
>         static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
>         {
>             <snip>
>             lp_qp_work = kzalloc(sizeof(struct
> hns_roce_recreate_lp_qp_work),
>                  GFP_KERNEL);
>             if (!lp_qp_work)
>                 return -ENOMEM;
>
>             <snip>
>             dev_warn(dev, "recreate lp qp failed 20s timeout and return
> failed!\n");
>             return -ETIMEDOUT;
>         }
>
>     Regards
> Wei Hu

Hi Wei,

It will be helpful, if you post your suggestions in git diff format.

My expectation is to see the following code:

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 747efd1ae5a6..0b9ec7c24f2d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1648,14 +1648,18 @@ void hns_roce_v1_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port, u8 *addr)
 	u16 *p_h;
 	u32 *p;
 	u32 val;

 	/*
 	 * When mac changed, loopback may fail
 	 * because of smac not equal to dmac.
 	 * We Need to release and create reserved qp again.
 	 */
-	if (hr_dev->hw->dereg_mr && hns_roce_v1_recreate_lp_qp(hr_dev))
-		dev_warn(&hr_dev->pdev->dev, "recreate lp qp timeout!\n");
+	if (hr_dev->hw->dereg_mr) {
+		int ret;
+		ret = hns_roce_v1_recreate_lp_qp(hr_dev);
+		if (ret && ret != -ETIMEDOUT)
+			return ret;
+	}

 	p = (u32 *)(&addr[0]);
 	reg_smac_l = *p;

Thanks

--IfjLu832HdL/xSp1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnOHykACgkQ5GN7iDZy
WKd/5Q//TvBljpUuSq2PtalwCzklD6k5c22oqIIaFv684cUTeK+zDCmCF8Erpu/p
1tpG5miQtlRo0V0ca/ugcMiju7sFemz4ikP52N1fIXOvUAckeKaYmakGqm5LJzkT
P9fzLcE/jSGOLUR7z+PAevkeHFjYv1xwHP4P/Keb9vBwD7wuhXSpY0PPQhjq/Fv+
YapZogyt3mvrnZ9kFw/Hhe2UdQJrMGZsLyExCr66FfHiX4ZoWcgNjafasQVUo4Fo
jBDji8xi4FA2VkqCF7DNGhyO7QXYbeyel3zd8eSkkYMr1aoRc9isLmwmV4n16Zx4
oJijQE6AAnwNwpLLX1KVs6CUxVMGd75w43M99pIfqGG4usAfSiRVoeMkgQh1NaiD
M33WHSG6+RyqxNwDQ1SZxGuERcsqOJQ8Eapx69akECWx6lVMgFgLP0BIOqN5MNuA
TKdRoeiaMqq9yR7KENtfKIii5P3xM3j51WL7n4XWzpfoD0IvhHRaQUwgq7Z0r1jE
ppp5eWNyULzQ2GClIX1NNJdM2P8etWJw9hfyE6IIU7AwTqkV07md5rsPiyQsXYji
O7f9eD0FGb0PtT9R9fJNo0wNmDsKJK+2cl3sEnvanA2IAj5pVx5EcZgrERdDmMYy
LbVrqoLTCc5VYMvv9wtuPUXR/Tu/u/r6GOcQn3lmTfFw4oaUBL4=
=frLn
-----END PGP SIGNATURE-----

--IfjLu832HdL/xSp1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
