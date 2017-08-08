From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH] IB/core: fix memory leak on ah on error return path
Date: Tue, 8 Aug 2017 19:48:01 +0000
Message-ID: <VI1PR0502MB30082DCBDA1C4B0F071D3DABD18A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170808101054.13800-1-colin.king@canonical.com>
 <20170808102026.GG3926@linux-x5ow.site>
 <866a49ab-6f7b-4b46-062b-6230e48da725@canonical.com>
 <20170808125927.GK3926@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170808125927.GK3926@linux-x5ow.site>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Colin Ian King <colin.king@canonical.com>
Cc: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I need to top post because comments are unrelated to past discussion.

rdma_ah_retrieve_dmac() can never fail for RoCE as its returning pointer fr=
om structure ah_attr.
Provider driver doesn't need to check for null pointer as ib/core would nev=
er call provider if it's not RoCE provider.
So this memory leak only exist in theory.

When its null, driver should WARN_ON/BUG_ON in extreme case, but that's not=
 necessary either.

I have patch is progress under internal review that does nice small cleanup=
 in many provider drivers that eliminates the check completely.
Waiting for Moni to finish the review.

Parav

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Johannes Thumshirn
> Sent: Tuesday, August 08, 2017 7:59 AM
> To: Colin Ian King <colin.king@canonical.com>
> Cc: Lijun Ou <oulijun@huawei.com>; Wei Hu <xavier.huwei@huawei.com>;
> Doug Ledford <dledford@redhat.com>; Sean Hefty <sean.hefty@intel.com>;
> Hal Rosenstock <hal.rosenstock@gmail.com>; linux-rdma@vger.kernel.org;
> kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] IB/core: fix memory leak on ah on error return path
>=20
> On Tue, Aug 08, 2017 at 11:28:16AM +0100, Colin Ian King wrote:
> > I was using the same subject start as the patch that introduced the
> > memory leak and touched the same portion of code. I can resend if neces=
sary.
>=20
> I think having the hns prefix makes it clearer, as the patch doesn't touc=
h IB core
> code but hns code. The reference to the patch which introduced the leak i=
s given
> byu the fixes line.
>=20
> Thanks,
> 	Johannes
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton HRB 21284 (AG N=FCr=
nberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in =
the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> https://emea01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fvger.=
ke
> rnel.org%2Fmajordomo-
> info.html&data=3D02%7C01%7Cparav%40mellanox.com%7C4b396976866648806
> a1008d4de5d512c%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C63
> 6377939837218186&sdata=3Dl9u%2Bc6N9E31L2I%2BRDBLNh7KuPi%2Fb49yAlbvw
> qZvGruk%3D&reserved=3D0
