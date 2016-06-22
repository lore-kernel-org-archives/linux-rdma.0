From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 06/22] IB/hns: Add initial cmd operation
Date: Wed, 22 Jun 2016 10:28:45 +0300
Message-ID: <20160622072845.GE9762@leon.nu>
References: <1466087730-54856-1-git-send-email-oulijun@huawei.com>
 <1466087730-54856-7-git-send-email-oulijun@huawei.com>
 <20160620133310.GB4526@leon.nu>
 <57691C0B.8090509@huawei.com>
 <20160621112808.GA9762@leon.nu>
 <57693AC4.1070306@huawei.com>
 <20160622045450.GC9762@leon.nu>
 <576A352F.8000700@huawei.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IU5/I01NYhRvwH70"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <576A352F.8000700-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gongyangming-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xiaokun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tangchaofei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haifeng.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yankejian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--IU5/I01NYhRvwH70
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2016 at 02:50:23PM +0800, Wei Hu (Xavier) wrote:
>=20
>=20
> On 2016/6/22 12:54, Leon Romanovsky wrote:
> >On Tue, Jun 21, 2016 at 09:01:57PM +0800, Wei Hu (Xavier) wrote:
> >>
> >>On 2016/6/21 19:28, Leon Romanovsky wrote:
> >>>On Tue, Jun 21, 2016 at 06:50:51PM +0800, Wei Hu (Xavier) wrote:
> >>>>On 2016/6/20 21:33, Leon Romanovsky wrote:
> >>>>>On Thu, Jun 16, 2016 at 10:35:14PM +0800, Lijun Ou wrote:
> >>>>>>This patch added the operation for cmd, and added some functions
> >>>>>>for initializing eq table and selecting cmd mode.
> >>>>>>
> >>>>>>Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>>>>Signed-off-by: Nenglong Zhao <zhaonenglong-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> >>>>>>Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>>>>---
> >>>>>>PATCH v9/v8/v7/v6:
> >>>>>>- No change over the PATCH v5
> >>>>>>
> >>>>>>PATCH v5:
> >>>>>>- The initial patch which was redesigned based on the second patch
> >>>>>>   in PATCH v4
> >>>>>>---
> >>>>><...>
> >>>>>
> >>>>>>+#define CMD_MAX_NUM		32
> >>>>>>+
> >>>>>>+int hns_roce_cmd_init(struct hns_roce_dev *hr_dev)
> >>>>>>+{
> >>>>>>+	struct device *dev =3D &hr_dev->pdev->dev;
> >>>>>>+
> >>>>>>+	mutex_init(&hr_dev->cmd.hcr_mutex);
> >>>>>>+	sema_init(&hr_dev->cmd.poll_sem, 1);
> >>>>>>+	hr_dev->cmd.use_events =3D 0;
> >>>>>>+	hr_dev->cmd.toggle =3D 1;
> >>>>>>+	hr_dev->cmd.max_cmds =3D CMD_MAX_NUM;
> >>>>><...>
> >>>>>
> >>>>>>+	for (hr_cmd->token_mask =3D 1; hr_cmd->token_mask < hr_cmd->max_c=
mds;
> >>>>>>+	     hr_cmd->token_mask <<=3D 1)
> >>>>>>+		;
> >>>>>>+	--hr_cmd->token_mask;
> >>>>>It doesn't look that you dynamically change max_cmds supported.
> >>>>>Why do you need to calculate token_mask dynamically?
> >>>>Hi, Leon
> >>>>
> >>>>     1. The four lines above are in the function named
> >>>>hns_roce_cmd_use_events.
> >>>>          and now this function is only called once in hns_roce_probe.
> >>>>     2. In hns_roce_cmd_use_events,
> >>>>         we use these 4 lines to achieve the value of hr_cmd->token_m=
ask
> >>>>according to hr_cmd->max_cmds dynamically,
> >>>>         then we only define one marco for hr_cmd->max_cmds as below:
> >>>>
> >>>>	#define CMD_MAX_NUM		32
> >>>>
> >>>>        And it looks more flexible.
> >>>It is called over engineering.
> >>>I would recommend to you to remove it.
> >>>
> >>>We don't need over complicated code which is executed
> >>>once with need to maintain with zero benefit.
> >>>
> >>>The other places need such simplification too.
> >>Hi, Leon
> >>
> >>         We will modify this place as below:
> >>         In hns_roce_hw_v1.c(for hip06 soc) file:
> >>
> >>             void hns_roce_v1_profile(struct hns_roce_dev *hr_dev)
> >>             {
> >>                 <snip>
> >>                 caps->max_cmds =3D 32;
> >>                 <snip>
> >>             }
> >>
> >>         In hns_roce_cmd.c file:
> >>
> >>   	  int hns_roce_cmd_init(struct hns_roce_dev *hr_dev)
> >>	  {
> >>	     <snip>
> >>	     hr_dev->cmd.max_cmds =3D hr_dev->caps->max_cmds;
> >>      		<snip>
> >>           }
> >>
> >>        Can you give more suggestions?
> >I would be happy to do it if I had enough time to review this code.
> >
> >General suggestion will be to ask yourself, if value is going to be
> >changed during the runtime. In case the answer is no, there is no room
> >to additional logic which translate constant to different value which
> >will be other constant.
> >
> >You should do it across all the patchset.
> >
> >So, in this specific case, the proposed change is not enough, you are
> >not solving an issue, but hiding it.
> >
> >Thanks
> We will modify this place as below=EF=BC=9A
>=20
>     #define CMD_TOKEN_MASK      0x1f
>=20
>    hr_cmd->token_mask =3D CMD_TOKEN_MASK;
>=20
>    delete these four lines:
>=20
> 	for (hr_cmd->token_mask =3D 1; hr_cmd->token_mask < hr_cmd->max_cmds;
> 	     hr_cmd->token_mask <<=3D 1)
> 		;
> 	--hr_cmd->token_mask;

Thanks,

While you are changing that file, please remove hns_roce_status_to_errno
function and embed it directly into hns_roce_cmd_event, so it will look
more compact.

	context->result =3D (status =3D=3D HNS_ROCE_CMD_SUCCESS)?0:-EIO;

>=20
>  =09
> Thanks
>=20
> >>
> >>Regards
> >>Wei Hu
> >>>>Regards
> >>>>Wei Hu
> >>>>
> >>>>
> >>>>
> >>
>=20
>=20

--IU5/I01NYhRvwH70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXaj4tAAoJEORje4g2cliny6kP/1Nfg58xhd75JI/XqXsj4Aa0
mN+KD/o8OVrmTQVDWKx6cWI0Lb4MNwMBR6qkX6PkNJ6j6SEpvNmR9iJvTG8Mkpog
6lmdW5vIg60s2M2Qbh90CS++xDCAVcm8yZzBpTIiWKiWyKk2o+MA/JzoEiXi94zE
nyyGK7m4SZms3pAPa7ImbK5xWxq0goe1JdmVZD9TltW301HFSaEmZNjU+fYqP1wv
dZ0M/vOa1bJDg/jyHHHf2j35CL5W1bGDAhNGtRSSjE/P5onDqhx7vrwdPH0hwedw
LyMdp28mrQ+hcGF+xp4jcrE59vR3jp8dUgLHsK/TlvwXF6QRqT9/FXqz5fehWnly
E6MFhiVKhPkNyC+G2MKW7QiVTNmTdSIEBO5TG7pOY5e+aMVZsipgLVYMXR35tWT3
nNIsx55l+rZ0qFTb6A2WX8/3Zo/2WEDfFdl7gCiH90ixiLpc25xdozq1pFMAl/YI
P50XAIdqDEHytr4PtI1o5crl0jt6KFaJbMfv0MLqEKTKKysrd3ALvd7q+DsveaQz
ZnMXovqSSyYTu9TvcVdW2dQ9A3SnMA+fNNprd+BuE9NrbG8kWImNtH2FP0qGSqjs
Re5Xq+YV8KmSRGoAN4VBYTtgnGECCzU0SlVRR03SJIC8jXP3B7hThIP4S7FC4CBD
ZaQUctLyzVzb/kuGZ44K
=z7iD
-----END PGP SIGNATURE-----

--IU5/I01NYhRvwH70--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
