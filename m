From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 06/22] IB/hns: Add initial cmd operation
Date: Wed, 22 Jun 2016 10:41:08 +0300
Message-ID: <20160622074108.GF9762@leon.nu>
References: <1466087730-54856-1-git-send-email-oulijun@huawei.com>
 <1466087730-54856-7-git-send-email-oulijun@huawei.com>
 <20160620133310.GB4526@leon.nu>
 <57691C0B.8090509@huawei.com>
 <20160621112808.GA9762@leon.nu>
 <57693AC4.1070306@huawei.com>
 <20160622045450.GC9762@leon.nu>
 <576A352F.8000700@huawei.com>
 <20160622072845.GE9762@leon.nu>
 <576A3F49.6040305@huawei.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ls2Gy6y7jbHLe9Od"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <576A3F49.6040305-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gongyangming-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xiaokun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tangchaofei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haifeng.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yankejian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Ls2Gy6y7jbHLe9Od
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2016 at 03:33:29PM +0800, Wei Hu (Xavier) wrote:
>=20
>=20
> On 2016/6/22 15:28, Leon Romanovsky wrote:
> >On Wed, Jun 22, 2016 at 02:50:23PM +0800, Wei Hu (Xavier) wrote:
> >>
> >>On 2016/6/22 12:54, Leon Romanovsky wrote:
> >>>On Tue, Jun 21, 2016 at 09:01:57PM +0800, Wei Hu (Xavier) wrote:
> >>>>On 2016/6/21 19:28, Leon Romanovsky wrote:
> >>>>>On Tue, Jun 21, 2016 at 06:50:51PM +0800, Wei Hu (Xavier) wrote:
> >>>>>>On 2016/6/20 21:33, Leon Romanovsky wrote:
> >>>>>>>On Thu, Jun 16, 2016 at 10:35:14PM +0800, Lijun Ou wrote:
> >>>>>>>>This patch added the operation for cmd, and added some functions
> >>>>>>>>for initializing eq table and selecting cmd mode.
> >>>>>>>>
> >>>>>>>>Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>>>>>>Signed-off-by: Nenglong Zhao <zhaonenglong-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> >>>>>>>>Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>>>>>>---
> >>>>>>>>PATCH v9/v8/v7/v6:
> >>>>>>>>- No change over the PATCH v5
> >>>>>>>>
> >>>>>>>>PATCH v5:
> >>>>>>>>- The initial patch which was redesigned based on the second patch
> >>>>>>>>   in PATCH v4
> >>>>>>>>---
> >>>>>>><...>
> >>>>>>>
> >>>>>>>>+#define CMD_MAX_NUM		32
> >>>>>>>>+
> >>>>>>>>+int hns_roce_cmd_init(struct hns_roce_dev *hr_dev)
> >>>>>>>>+{
> >>>>>>>>+	struct device *dev =3D &hr_dev->pdev->dev;
> >>>>>>>>+
> >>>>>>>>+	mutex_init(&hr_dev->cmd.hcr_mutex);
> >>>>>>>>+	sema_init(&hr_dev->cmd.poll_sem, 1);
> >>>>>>>>+	hr_dev->cmd.use_events =3D 0;
> >>>>>>>>+	hr_dev->cmd.toggle =3D 1;
> >>>>>>>>+	hr_dev->cmd.max_cmds =3D CMD_MAX_NUM;
> >>>>>>><...>
> >>>>>>>
> >>>>>>>>+	for (hr_cmd->token_mask =3D 1; hr_cmd->token_mask < hr_cmd->max=
_cmds;
> >>>>>>>>+	     hr_cmd->token_mask <<=3D 1)
> >>>>>>>>+		;
> >>>>>>>>+	--hr_cmd->token_mask;
> >>>>>>>It doesn't look that you dynamically change max_cmds supported.
> >>>>>>>Why do you need to calculate token_mask dynamically?
> >>>>>>Hi, Leon
> >>>>>>
> >>>>>>     1. The four lines above are in the function named
> >>>>>>hns_roce_cmd_use_events.
> >>>>>>          and now this function is only called once in hns_roce_pro=
be.
> >>>>>>     2. In hns_roce_cmd_use_events,
> >>>>>>         we use these 4 lines to achieve the value of hr_cmd->token=
_mask
> >>>>>>according to hr_cmd->max_cmds dynamically,
> >>>>>>         then we only define one marco for hr_cmd->max_cmds as belo=
w:
> >>>>>>
> >>>>>>	#define CMD_MAX_NUM		32
> >>>>>>
> >>>>>>        And it looks more flexible.
> >>>>>It is called over engineering.
> >>>>>I would recommend to you to remove it.
> >>>>>
> >>>>>We don't need over complicated code which is executed
> >>>>>once with need to maintain with zero benefit.
> >>>>>
> >>>>>The other places need such simplification too.
> >>>>Hi, Leon
> >>>>
> >>>>         We will modify this place as below:
> >>>>         In hns_roce_hw_v1.c(for hip06 soc) file:
> >>>>
> >>>>             void hns_roce_v1_profile(struct hns_roce_dev *hr_dev)
> >>>>             {
> >>>>                 <snip>
> >>>>                 caps->max_cmds =3D 32;
> >>>>                 <snip>
> >>>>             }
> >>>>
> >>>>         In hns_roce_cmd.c file:
> >>>>
> >>>>   	  int hns_roce_cmd_init(struct hns_roce_dev *hr_dev)
> >>>>	  {
> >>>>	     <snip>
> >>>>	     hr_dev->cmd.max_cmds =3D hr_dev->caps->max_cmds;
> >>>>      		<snip>
> >>>>           }
> >>>>
> >>>>        Can you give more suggestions?
> >>>I would be happy to do it if I had enough time to review this code.
> >>>
> >>>General suggestion will be to ask yourself, if value is going to be
> >>>changed during the runtime. In case the answer is no, there is no room
> >>>to additional logic which translate constant to different value which
> >>>will be other constant.
> >>>
> >>>You should do it across all the patchset.
> >>>
> >>>So, in this specific case, the proposed change is not enough, you are
> >>>not solving an issue, but hiding it.
> >>>
> >>>Thanks
> >>We will modify this place as below=EF=BC=9A
> >>
> >>     #define CMD_TOKEN_MASK      0x1f
> >>
> >>    hr_cmd->token_mask =3D CMD_TOKEN_MASK;
> >>
> >>    delete these four lines:
> >>
> >>	for (hr_cmd->token_mask =3D 1; hr_cmd->token_mask < hr_cmd->max_cmds;
> >>	     hr_cmd->token_mask <<=3D 1)
> >>		;
> >>	--hr_cmd->token_mask;
> >Thanks,
> >
> >While you are changing that file, please remove hns_roce_status_to_errno
> >function and embed it directly into hns_roce_cmd_event, so it will look
> >more compact.
> >
> >	context->result =3D (status =3D=3D HNS_ROCE_CMD_SUCCESS)?0:-EIO;
> ok, we will do it.
> Thanks very much for your suggestions!

Please don't resubmit till next week, I'll try to do review on this
weekend.

And please don't forget to get rid of ICM logic.

Thanks.

--Ls2Gy6y7jbHLe9Od
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXakEUAAoJEORje4g2cliniZMP/2i2jUl05EHw8rbqHH8C2OTd
glnlRRJqLsyV4GLaKUFJIF5pE/6V9TpvXnrBDEzDXsSxxVcF+6ZYZCEklBVTnR1g
18esauhiZY0YlDQqANjWdFxIR9Wa32CwgrY3HYrlvewJpuAT3/tKd8PdNgy8V9+i
iQ2Zf3qipvcF7iuL6AsiJC8Q+kZPFBBsNGYSmr2lM2UNoj6FwuoAG/n92oEHHLMw
6LYrRAQMOn6RYMLF4l0XFheECVPDc7TePzyvUziIsbCQDTG8SA9zXquXjXP2HcsK
F24DCOdUmkgR2MJGcs5te2BhPlFgJ/ktfRxRMBfenQC8zBdrabzBuW5k1hOz7n2F
gA4unrgGhl4js+IbMz/X9nM4FQ1X+vfbBo7dR8Rn8Y47WhbbXy94YEzbj6zNyl1h
Vryn2Xf5yaCYIIL+0RB1xyYNX+mlxflGSwNplq1RwX3xwSm375q/UEv8ACgZicQu
59e47QPWyJx/3NiQgvLKfegaEYxPBCX74tGae5KE4+ZHKY+xjyaJwrJRNzPdRrRu
xkRBA0orYIV9FOQdcdPMonemS0YiuNmkOeJwq7Xi2n8H8ezPaAJsz8zHX3jefiQu
Fv0FgtRz11QD1XepRm/hUJmVZjSrJBzuPMkr8qCY8sd/Kuq0OrLI3I+1hGf3x1zN
z+RNGYs+3l6YPI+T7ZAN
=nzfX
-----END PGP SIGNATURE-----

--Ls2Gy6y7jbHLe9Od--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
