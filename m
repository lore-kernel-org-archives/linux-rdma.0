From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [PATCH net-next 1/5] net: hns3: Enable HW GRO for Rev B(=0x21)
 HNS3 hardware
Date: Thu, 15 Nov 2018 09:36:10 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93BFB6F3E@FRAEML521-MBX.china.huawei.com>
References: <20181113101307.6020-1-salil.mehta@huawei.com>
 <20181113101307.6020-2-salil.mehta@huawei.com>
 <20181113112446.GC3759@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181113112446.GC3759@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "lipeng (Y)" <lipeng321@huawei.com>, "mehta.salil@opnsrc.net" <mehta.salil@opnsrc.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-rdma@vger.kernel.org

> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: Tuesday, November 13, 2018 11:25 AM
> To: Salil Mehta <salil.mehta@huawei.com>
> Cc: davem@davemloft.net; Zhuangyuzeng (Yisen) <yisen.zhuang@huawei.com>;
> lipeng (Y) <lipeng321@huawei.com>; mehta.salil@opnsrc.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH net-next 1/5] net: hns3: Enable HW GRO for Rev
> B(=0x21) HNS3 hardware
> 
> On Tue, Nov 13, 2018 at 10:13:03AM +0000, Salil Mehta wrote:
> > From: Peng Li <lipeng321@huawei.com>
> >
> > HNS3 hardware Revision B(=0x21) supports Hardware GRO feature. This
> > patch enables this feature in the HNS3 PF/VF driver.
> >
> > Signed-off-by: Peng Li <lipeng321@huawei.com>
> > Signed-off-by: Salil Mehta <salil.mehta@huawei.com>


> >
> > +	ret = hclge_config_gro(hdev, true);
> > +	if (ret) {
> > +		dev_err(&pdev->dev,
> > +			"Failed to enable GRO in hardware, ret =%d\n", ret);
> 
> You already printed an error in the hclge_config_gro().

sure. thanks.

> 
> > +		goto err_mdiobus_unreg;
> > +	}
> > +
> >  	ret = hclge_init_vlan_config(hdev);
> >  	if (ret) {
> >  		dev_err(&pdev->dev, "VLAN init fail, ret =%d\n", ret);
> > @@ -7221,6 +7250,13 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
> >  		return ret;
> >  	}
> >
> > +	ret = hclge_config_gro(hdev, true);
> > +	if (ret) {
> > +		dev_err(&pdev->dev,
> > +			"Failed to enable GRO in hardware, ret =%d\n", ret);
> 
> Ditto

ok.


> >  static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
> >  {
> >  	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
> > @@ -2122,6 +2145,13 @@ static int hclgevf_reset_hdev(struct
> hclgevf_dev *hdev)
> >  		return ret;
> >  	}
> >
> > +	ret = hclgevf_config_gro(hdev, true);
> > +	if (ret) {
> > +		dev_err(&pdev->dev,
> > +			"failed to enable VF GRO in hardware, ret =%d\n",
> ret);
> > +		return ret;
> 
> Ditto

sure.


> 
> > +	}
> > +
> >  	ret = hclgevf_init_vlan_config(hdev);
> >  	if (ret) {
> >  		dev_err(&hdev->pdev->dev,
> > @@ -2199,6 +2229,13 @@ static int hclgevf_init_hdev(struct hclgevf_dev
> *hdev)
> >  		goto err_config;
> >  	}
> >
> > +	ret = hclgevf_config_gro(hdev, true);
> > +	if (ret) {
> > +		dev_err(&pdev->dev,
> > +			"Failed to enable VF GRO in hardware, ret =%d\n",
> ret);
> 
> Ditto

Fixed in V2. Thanks Leon.


Best regards
Salil.
