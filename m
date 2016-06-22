From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 08/22] IB/hns: Add icm support
Date: Wed, 22 Jun 2016 08:27:00 +0300
Message-ID: <20160622052700.GD9762@leon.nu>
References: <20160617095834.GA5408@leon.nu>
 <57677314.70909@huawei.com>
 <20160620060614.GC1172@leon.nu>
 <5767A004.4060808@huawei.com>
 <20160620092719.GE1172@leon.nu>
 <5767BBDF.6010309@huawei.com>
 <20160620130422.GA4526@leon.nu>
 <5768C493.6000300@huawei.com>
 <20160621115554.GB9762@leon.nu>
 <576A0BAD.1070803@huawei.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <576A0BAD.1070803-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gongyangming-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xiaokun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tangchaofei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haifeng.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yankejian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2016 at 11:53:17AM +0800, Wei Hu (Xavier) wrote:

- netdev, lkml and Dave - it is unrelated to netdev and there is no
  need to SPAM them.

It will be great if next revision will have smaller list of TO/CC
participants than it has now.

>=20
>=20
> On 2016/6/21 19:55, Leon Romanovsky wrote:
> >On Tue, Jun 21, 2016 at 12:37:39PM +0800, Wei Hu (Xavier) wrote:
> >>
> >>On 2016/6/20 21:04, Leon Romanovsky wrote:
> >>>On Mon, Jun 20, 2016 at 05:48:15PM +0800, Wei Hu (Xavier) wrote:
> >>>>On 2016/6/20 17:27, Leon Romanovsky wrote:
> >>>>>On Mon, Jun 20, 2016 at 03:49:24PM +0800, Wei Hu (Xavier) wrote:
> >>>>>>On 2016/6/20 14:06, Leon Romanovsky wrote:
> >>>>>>>On Mon, Jun 20, 2016 at 12:37:40PM +0800, Wei Hu (Xavier) wrote:
> >>>>>>>>On 2016/6/17 17:58, Leon Romanovsky wrote:
> >>>>>>>>>On Thu, Jun 16, 2016 at 10:35:16PM +0800, Lijun Ou wrote:
> >>>>>>>>>>This patch mainly added icm support for RoCE. It initializes icm
> >>>>>>>>>>which managers the relative memory blocks for RoCE. The data
> >>>>>>>>>>structures of RoCE will be located in it. For example, CQ table,
> >>>>>>>>>>QP table and MTPT table so on.
> >>>>>>>>>>
> >>>>>>>>>>Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>>>>>>>>Signed-off-by: Nenglong Zhao <zhaonenglong-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> >>>>>>>>>>Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>>>>>>>>---
> >>>>>>>>><...>
> >>>>>>>>>
> >>>>>>>>>>+
> >>>>>>>Another question which you didn't answer [1].
> >>>>>>>
> >>>>>>>"I wonder if you have the same needs for ICM as it is in mlx4 devi=
ce.
> >>>>>>>Do you have firmware?"
> >>>>>>>
> >>>>>>>[1] http://marc.info/?l=3Dlinux-rdma&m=3D146545553104913&w=3D2
> >>>>>>Hi, Leon
> >>>>>>     Now we haven't firmware.
> >>>>>>     But hardware still need memory for QPC\CQC\MTPT\mtt etc.
> >>>>>ICM stands for InfiniHost (Interconnect) Context Memory is a specific
> >>>>>memory place to share between host <-> FW and host <-> HW if HW is
> >>>>>aware of specific structures.
> >>>>>
> >>>>>I assume that in your case, it is enough to allocate memory region a=
nd
> >>>>>supply it to HW. Am I right?
> >>>>For Our hardware,
> >>>>1. ICM has a memory management method, It's very good for QPC\CQC\MTP=
T\mtt
> >>>>etc. we need it.
> >>>You need special HW to leverage its. AFAIK it is Mellanox specific.
> >>For our hardware, we use ICM to memory management, the memory shared wi=
th
> >>host and HW.
> >>QPC\CQC\MTPT\mtt has specific memory requirement.
> >>QPC\CQC\MTPT need continuous memory. we use ICM to management the block=
 of
> >>memory. It's very good=EF=BC=81
> >I wasn't convinced why do you need to copy whole ICM logic which is
> >specific to Mellanox. Your requirements can be implemented by standard C=
MA
> >and/or DMA.
> Hi, Leon
>=20
> In hip06 soc,
> Hardware need multiple memory blocks for QPC\CQC\MTPT, every block has
> continuous memory xxKbyte (like 128Kbyte),
> We need to configure the first address of 128Kbyte to hardware.
>=20
> For example:
> //------------------------------------------------------------------------
> example 1:
> In create qp,
> 1. If the xx Kbyte memory that include QPC related with qpn, has not been
> allocated, do step 2.
>    else do step 3.
> 2. dma_alloc xx Kbyte memory for QPC,  and configure the first address of=
 xx
> Kbyte to hardware.
> 3. find the QPC memory in xx Kbyte, get the dma_addr.
> 4. send mailbox command to hardware to create QP.
>=20
> In step 2, we call xx_table_get function as below to perform logic.
> int hns_roce_table_get(struct hns_roce_dev *hr_dev,
>                struct hns_roce_icm_table *table, unsigned long obj)
> {
>     <snip>
>     //dma_alloc_coherent 128Kbyte memory
>     hns_roce_alloc_icm(hr_dev,
>                   HNS_ROCE_TABLE_CHUNK_SIZE >> PAGE_SHIFT, xxxx);
>     <snip>
>     /*configure the first address of xx Kbyte to hardware*/
>     hns_roce_map_icm(hr_dev, table, obj);
>     <snip>
> }
>=20
> In step 3, we call xx_table_find function to perform logic.
> void *hns_roce_table_find(struct hns_roce_icm_table *table, unsigned long
> obj,
>               dma_addr_t *dma_handle);
>=20
>=20
> example 2:
> In modify qp:
> 1. find the QPC memory,  get the virtual addr.
> 2. modify the fields of QPC.
> 3. send mailbox command to hardware to modify QP.
>=20
> In step 1,  we call xx_table_find function to perform logic.
> //-----------------------------------------------------------------------=
---
>=20
>=20
> so, now we haven't a firmware, but ICM algorithm still suitable for hip06
> soc perfectly.

Sure it works and you have billion other solutions in kernel which will
work too. The thing is to chose simplest possible solution and ICM is
overkill for the goal you are trying to achieve. ICM designed in mind
that this memory is owned by HW, requested by HCA and can shrink/grow
as a response to this request.

Thanks

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXaiGkAAoJEORje4g2clinna4QAIXtxLRYpLOlHAyqaKcuiMaG
+RwAQ4ok+QptLGz6wa4Ivd3+9wxqV0N+jFU7Obi6QmO7rnwuhEQOtJKbInUXoOvJ
+c+IGclMNdac+QGJi7FqKvqzeo97v4OoGMfYWfbCjY1zHn3A6iLiAYZ1JW5OX+ZW
aaUdeNYIrrzzEu9V9kSKetnqq2czMwVU266cnHu3fnkqiskkyRt2XOjTJLUjW/tB
23RWvHvfCoojGfJjonOlq7iCRKs/GlKNEQ4CXvYxLD+rWaZUkmZ+cjIUIs7yHVgZ
B9xG/P8XpMflza7/nq2504VftOT4NxykpB5PO9J/P461gxqrSkt4EaE78UgCu/p0
JVXSlchVVqmWrwmGrDTXioH234V/A3zM5hWkAYHndGf7JT7oyBysaird0yl5qdzF
t1T+/dRFYZFv7oYLRLK2WnpT4BXt7krZwNEp+dpL6NX/pcdhjqn6sTZa4JvIkqVD
hh0WcIuhWQIirvQ8S50Rb6T4x/JUezEn0XGjIq/jNYAW/8XptOQ88EVibrEV54mG
I6yEXe600k8r7rmMyzt4592MVxV1nsgqwMysPi6MAlOdxf3z+DnTWitLCX045mE5
WPzRLLVTkvj7FM3KnQYXBNyE+fN+aC9soypWojnEGyZsVCbmtsqsAubAmLegrQ23
N1KTvtTVncqFEb3qWyyn
=hYXs
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
