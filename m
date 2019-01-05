From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Sat, 5 Jan 2019 03:21:50 +0000
Message-ID: <20190105032142.GN28204@mellanox.com>
References: <20190104223531.GA1705@ziepe.ca>
 <201901051046.ew7HAHfl%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201901051046.ew7HAHfl%fengguang.wu@intel.com>
Content-Language: en-US
Content-ID: <82C95609B764554287F500BCF927501B@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Shiraz Saleem <shiraz.saleem@intel.com>, Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Yong Zhi <yong.zhi@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Bingbu Cao <bingbu.cao@intel.com>, Tian Shu Qiu <tian.shu.qiu@intel.com>, Jian Xu Zheng <jian.xu.zheng@intel.com>, Sinclair Yeh <syeh@vmware.com>, Thomas Hellstrom <thellstrom@vmware.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 05, 2019 at 10:37:17AM +0800, kbuild test robot wrote:
> Hi Jason,
>=20
> I love your patch! Yet something to improve:
>=20
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.20 next-20190103]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]
>=20
> url:    https://github.com/0day-ci/linux/commits/Jason-Gunthorpe/lib-scat=
terlist-Provide-a-DMA-page-iterator/20190105-081739
> config: x86_64-randconfig-x017-201900 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=3Dx86_64=20
>=20
> All error/warnings (new ones prefixed by >>):
>=20
>    In file included from lib/scatterlist.c:9:0:
> >> include/linux/export.h:81:20: error: redefinition of '__kstrtab___sg_p=
age_iter_next'
>      static const char __kstrtab_##sym[]    \
>                        ^
>    include/linux/export.h:120:25: note: in expansion of macro '___EXPORT_=
SYMBOL'
>     #define __EXPORT_SYMBOL ___EXPORT_SYMBOL
>                             ^~~~~~~~~~~~~~~~
>    include/linux/export.h:124:2: note: in expansion of macro '__EXPORT_SY=
MBOL'
>      __EXPORT_SYMBOL(sym, "")
>      ^~~~~~~~~~~~~~~
> >> lib/scatterlist.c:652:1: note: in expansion of macro 'EXPORT_SYMBOL'
>     EXPORT_SYMBOL(__sg_page_iter_next);
>     ^~~~~~~~~~~~~

Woops, should be __sg_page_dma_iter_next.. Will resend after getting
some feedback.

Jason
