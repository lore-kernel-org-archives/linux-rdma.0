From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH for-next 10/20] IB/hns: Modify the init of iboe lock
Date: Wed, 14 Sep 2016 08:04:55 +0300
Message-ID: <20160914050455.GY8812@leon.nu>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-11-git-send-email-salil.mehta@huawei.com>
 <20160913065028.GR8812@leon.nu>
 <F4CC6FACFEB3C54C9141D49AD221F7F91A716DF6@lhreml503-mbx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OEa2bCMk+rg6xBXy"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F4CC6FACFEB3C54C9141D49AD221F7F91A716DF6@lhreml503-mbx>
Sender: linux-kernel-owner@vger.kernel.org
To: Salil Mehta <salil.mehta@huawei.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "Huwei (Xavier)" <xavier.huwei@huawei.com>, oulijun <oulijun@huawei.com>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "xuwei (O)" <xuwei5@hisilicon.com>, "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, "Huangdongdong (Donald)" <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org


--OEa2bCMk+rg6xBXy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 14, 2016 at 02:09:37AM +0000, Salil Mehta wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> > owner@vger.kernel.org] On Behalf Of Leon Romanovsky
> > Sent: Tuesday, September 13, 2016 7:50 AM
> > To: Salil Mehta
> > Cc: dledford@redhat.com; Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> > xuwei (O); mehta.salil.lnk@gmail.com; linux-rdma@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Linuxarm; Huangdongdong (Donald)
> > Subject: Re: [PATCH for-next 10/20] IB/hns: Modify the init of iboe
> > lock
> >
> > On Fri, Sep 09, 2016 at 06:30:41PM +0800, Salil Mehta wrote:
> > > From: Lijun Ou <oulijun@huawei.com>
> > >
> > > This lock will be used in query port interface, and will be called
> > > while IB device was registered to OFED frame. So, the lock of iboe
> > > must be initiated before IB device was registered.
> >
> > Sorry,
> > what did you mean by writing "OFED frame"?
> It is a typo. It was OFED framework but I guess more appropriate word
> might have been 'IB core' layer of Infiniband. Will fix this. Thanks!

As a general note, and I understand that these contributors are not
native English speakers, and I understand the desire to submit the right
code and code should speak by itself, but can you invest more time in
commit messages and write them in English?

Thanks

>
> Best regards
> Salil
> >
> > >
> > > Signed-off-by: Lijun Ou <oulijun@huawei.com>
> > > Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
> > > Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
> > > Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> > > ---
> > >  drivers/infiniband/hw/hns/hns_roce_main.c |    3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c
> > b/drivers/infiniband/hw/hns/hns_roce_main.c
> > > index 2704076..4721c0c 100644
> > > --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> > > +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> > > @@ -615,6 +615,7 @@ static int hns_roce_register_device(struct
> > hns_roce_dev *hr_dev)
> > >  	struct device *dev = &hr_dev->pdev->dev;
> > >
> > >  	iboe = &hr_dev->iboe;
> > > +	spin_lock_init(&iboe->lock);
> > >
> > >  	ib_dev = &hr_dev->ib_dev;
> > >  	strlcpy(ib_dev->name, "hisi_%d", IB_DEVICE_NAME_MAX);
> > > @@ -701,8 +702,6 @@ static int hns_roce_register_device(struct
> > hns_roce_dev *hr_dev)
> > >  		goto error_failed_setup_mtu_gids;
> > >  	}
> > >
> > > -	spin_lock_init(&iboe->lock);
> > > -
> > >  	iboe->nb.notifier_call = hns_roce_netdev_event;
> > >  	ret = register_netdevice_notifier(&iboe->nb);
> > >  	if (ret) {
> > > --
> > > 1.7.9.5
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--OEa2bCMk+rg6xBXy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2Np3AAoJEORje4g2clinmSIQANL5gJSfVy2Zwg/O1V9ZNHAp
d41BBB5U4+q/8nBXYOkXoWZ7Td5ZQMXbRYKa/+6PR4VHnub1GHXCSgqY/2OfZRmI
j0ohtaEn0XwIABc7/I3Pb+py98qS3OmWcnfVnKFUAuYTQWkdWBrTPFruDTLB2KrL
crn7RkbBewNleM+FVFqW+34jjn8/5+oWTuY8hWZDF+N+49YXu9uaR14JpgaUZVwe
Fzf5cUTg0U6i21Au+6pgTvPDnU8GBjpZrWtuY7jSgJQMXZRCLOKI4Fh2VAjV0BDD
Otadn7gBWv0/4NtnAYJqpNX7h+rUDI7RrAWYriIII32xW158eW35MGhx2nBTfpLq
dC6wWoQ1a+h4o/2mCfYV3AltIh/6WFA6p1Q5G73oYVkADh2/zPA8mzXXtAwl6Moo
DklrTo1/2T7mhD6VWquMVYz9mauj+M+Qb7bEN+cksDKHzzHw91zYSJjGm9h8Jnk0
sWbji1Bb8AjZf7/POAnHT25oqrDzuMu8D857xMSxdn0pzNF+JYQ4SMvgJDEz5uPJ
nsOqnKDnNACz5J99jAOpxBL5jJADH99I35ZLcsQNY+E8MphF7dDKHdIYrktnEqKx
ouD1ab8Q2I8h4oE4WMoe4Fsz1rz6pK8zrVPvU/WiY98w02Sohfro9c8wrT4QjKo5
cZbPlXPGkcvQMBzQfEm2
=QPF8
-----END PGP SIGNATURE-----

--OEa2bCMk+rg6xBXy--
