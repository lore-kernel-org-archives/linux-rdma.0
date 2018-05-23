From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 2/5] RDMA/hns: Modify uar allocation algorithm
 to avoid bitmap exhaust
Date: Wed, 23 May 2018 10:22:49 +0300
Message-ID: <20180523072249.GE5729@mtr-leonro.mtl.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-3-git-send-email-xavier.huwei@huawei.com>
 <20180523060515.GD2933@mtr-leonro.mtl.com>
 <5B050EFF.4040908@huawei.com>
 <20180523070055.GD5729@mtr-leonro.mtl.com>
 <5B05146D.901@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YToU2i3Vx8H2dn7O"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B05146D.901@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org


--YToU2i3Vx8H2dn7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2018 at 03:12:45PM +0800, Wei Hu (Xavier) wrote:
>
>
> On 2018/5/23 15:00, Leon Romanovsky wrote:
> > On Wed, May 23, 2018 at 02:49:35PM +0800, Wei Hu (Xavier) wrote:
> >>
> >> On 2018/5/23 14:05, Leon Romanovsky wrote:
> >>> On Thu, May 17, 2018 at 04:02:50PM +0800, Wei Hu (Xavier) wrote:
> >>>> This patch modified uar allocation algorithm in hns_roce_uar_alloc
> >>>> function to avoid bitmap exhaust.
> >>>>
> >>>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
> >>>> ---
> >>>>  drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
> >>>>  drivers/infiniband/hw/hns/hns_roce_pd.c     | 10 ++++++----
> >>>>  2 files changed, 7 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> >>>> index 53c2f1b..412297d4 100644
> >>>> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> >>>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> >>>> @@ -214,6 +214,7 @@ enum {
> >>>>  struct hns_roce_uar {
> >>>>  	u64		pfn;
> >>>>  	unsigned long	index;
> >>>> +	unsigned long	logic_idx;
> >>>>  };
> >>>>
> >>>>  struct hns_roce_ucontext {
> >>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
> >>>> index 4b41e04..b9f2c87 100644
> >>>> --- a/drivers/infiniband/hw/hns/hns_roce_pd.c
> >>>> +++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
> >>>> @@ -107,13 +107,15 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
> >>>>  	int ret = 0;
> >>>>
> >>>>  	/* Using bitmap to manager UAR index */
> >>>> -	ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->index);
> >>>> +	ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->logic_idx);
> >>>>  	if (ret == -1)
> >>>>  		return -ENOMEM;
> >>>>
> >>>> -	if (uar->index > 0)
> >>>> -		uar->index = (uar->index - 1) %
> >>>> +	if (uar->logic_idx > 0 && hr_dev->caps.phy_num_uars > 1)
> >>>> +		uar->index = (uar->logic_idx - 1) %
> >>>>  			     (hr_dev->caps.phy_num_uars - 1) + 1;
> >>>> +	else
> >>>> +		uar->index = 0;
> >>>>
> >>> Sorry, but maybe I didn't understand this change fully, but logic_idx is
> >>> not initialized at all and one of two (needs to check your uar
> >>> allocation): the logic_idx is always zero -> index will be zero too,
> >>> or logic_idx is random variable -> index will be random too.
> >>>
> >>> What did you want to do?
> >>>
> >> Hi, Leon
> >>
> >>     The prototype of hns_roce_bitmap_alloc as belows:
> >>         int hns_roce_bitmap_alloc(struct hns_roce_bitmap *bitmap,
> >> unsigned long *obj);
> >>     In this statement,  we evaluate uar->logic_idx.
> >>         ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap,
> >> &uar->logic_idx);
> >>
> >>     In hip06,  hr_dev->caps.phy_num_uars equals 8,
> >>         if (uar->logic_idx > 0)
> >>              uar-> index = 0;
> >>        else
> >>              uar-> index =(uar->logic_idx - 1) %
> >> (hr_dev->caps.phy_num_uars - 1) + 1;
> >>     In hip08,  hr_dev->caps.phy_num_uars equals 1,  uar-> index = 0;
> >>
> >>    Regards
> > Where did you change/set logic_idx?
> In hns_roce_uar_alloc,
>     ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->logic_idx);
> In hns_roce_uar_free,
>     hns_roce_bitmap_free(&hr_dev->uar_table.bitmap, uar->logic_idx,
> BITMAP_NO_RR);
>

I see it, thanks
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--YToU2i3Vx8H2dn7O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbBRbJAAoJEORje4g2clinepkP/0kcp5uz9zMH90ronD0N1Enh
c9ISep3gEfNouC2uZJ7sMtniJI/ljFTR1mf1B4mRWFMCx7a6MEa4zd+yi6s4fhHb
wRcOaLpYJv66okIbRmn/cbX3hJYTIfJ9YOTTZuUQRMm2NJ3Ugvu6jnbBcGkA4Vz5
ot8gHIomA699Qsv/z0sfWF0VIWrb7IGkTdPVQNNAp0lEtCXAU2dslpgE7z0RBwVy
U7wOHSMXLcP1FhQgy2pljDuRZZkcQgSlFHS5GZlJQ5kD1uoKwXgPuoJmKwaRRm1t
dA+5ohX4VUm8wDsixvSBQqz1arKWQyn3vo8vSN7O1ganR7Iz/xCz73tbaLPLiWHV
abZ3/yPgRpvNOTbF2da2K3mea6n6cXqObB67JHLcleeeV0Ikv0PDawk1CxJlvt5z
JGSEO3CHJC8HeJjZ1wuIptuNTdQ+duRXQXy1bSAuOSaoRiWnjfAzmTpmJoTH2IEl
yNXBhDOSwzOMv1O3Ow0+whDSBdcvf9teQuVjYLaYjO6a8yWtOQjA5zdmnFBt22cW
6GbJIPXtDQsurNbkPIPtR5IOxFkuFZu/eNow/39TJL3DHtrm4wCFe7NjtGR+bpHF
mVMyinM4o+Zn005a/SJZjjfqYsZ9wqmSnT7JIp/srdArdm/6QD+7xa/VZii0eH78
O8SPErdw+mJlHjlIWvVb
=oSfq
-----END PGP SIGNATURE-----

--YToU2i3Vx8H2dn7O--
