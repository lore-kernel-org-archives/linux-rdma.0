From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [PATCH for-next 03/10] IB/hns: Add & initialize "node_guid"
 parameter for RDMA CM
Date: Mon, 12 Sep 2016 15:50:59 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A713996@lhreml503-mbx>
References: <1472765845-118972-1-git-send-email-salil.mehta@huawei.com>
 <1472765845-118972-4-git-send-email-salil.mehta@huawei.com>
 <20160912123623.GH8812@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160912123623.GH8812@leon.nu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "Huwei (Xavier)" <xavier.huwei@huawei.com>, oulijun <oulijun@huawei.com>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: Monday, September 12, 2016 1:36 PM
> To: Salil Mehta
> Cc: dledford@redhat.com; Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> mehta.salil.lnk@gmail.com; linux-rdma@vger.kernel.org; linux-
> kernel@vger.kernel.org; Linuxarm
> Subject: Re: [PATCH for-next 03/10] IB/hns: Add & initialize
> "node_guid" parameter for RDMA CM
> 
> On Fri, Sep 02, 2016 at 05:37:18AM +0800, Salil Mehta wrote:
> > From: Lijun Ou <oulijun@huawei.com>
> >
> > According to the Infiniband spec, NodeGUID uniquely identifies a
> > node. This must be initialized to some unique value. This patch
> > adds the support to the HNS RoCE driver to fetch the NodeGUID
> > value from DT or ACPI and then use this value to initialize the
> > node_guid parameter of IB device. This value shall be used by
> > RDMA CM.
> >
> > Signed-off-by: Lijun Ou <oulijun@huawei.com>
> > Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
> > Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> > ---
> >  drivers/infiniband/hw/hns/hns_roce_device.h |    1 +
> >  drivers/infiniband/hw/hns/hns_roce_main.c   |    7 +++++++
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h
> b/drivers/infiniband/hw/hns/hns_roce_device.h
> > index ea73580..e943b98 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> > +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> > @@ -74,6 +74,7 @@
> >  #define MR_TYPE_DMA				0x03
> >
> >  #define PKEY_ID					0xffff
> > +#define GUID_LEN				8
> >  #define NODE_DESC_SIZE				64
> >
> >  #define SERV_TYPE_RC				0
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c
> b/drivers/infiniband/hw/hns/hns_roce_main.c
> > index 4e93120..ec27f0c 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> > @@ -812,6 +812,13 @@ static int hns_roce_get_cfg(struct hns_roce_dev
> *hr_dev)
> >  	if (IS_ERR(hr_dev->reg_base))
> >  		return PTR_ERR(hr_dev->reg_base);
> >
> > +	/* read the node_guid of IB device from the DT or ACPI */
> > +	ret = device_property_read_u8_array(dev, "node-guid",
> > +					    (u8 *)&hr_dev->ib_dev.node_guid,
> > +					    GUID_LEN);
> > +	if (ret)
> > +		dev_err(dev, "couldn't get node_guid from DT or ACPI!\n");
> 
> Is it error? If yes, you need to implement proper error folding. If
> not,
> this error shouldn't be error.
Yes, that's correct. This is a merge error. Thanks for catching this.
Above statement should have been like below:

/* read the node_guid of IB device from the DT or ACPI */
	ret = device_property_read_u8_array(dev, "node-guid",
					    (u8 *)&hr_dev->ib_dev.node_guid,
					    GUID_LEN);
	if (ret) {
		dev_err(dev, "couldn't get node_guid from DT or ACPI!\n");
		return ret;
      }

Will fix this. Thanks!

Best regards
Salil Mehta
> 
> > +
> >  	/* get the RoCE associated ethernet ports or netdevices */
> >  	for (i = 0; i < HNS_ROCE_MAX_PORTS; i++) {
> >  		if (dev_of_node(dev)) {
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
