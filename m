From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Sat, 12 Jan 2019 18:37:58 +0000
Message-ID: <20190112183752.GC16457@mellanox.com>
References: <20190104223531.GA1705@ziepe.ca>
 <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <DAC65A5B3277C34FAF842AB1917DE54E@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Yong Zhi <yong.zhi@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Bingbu Cao <bingbu.cao@intel.com>, Tian Shu Qiu <tian.shu.qiu@intel.com>, Jian Xu Zheng <jian.xu.zheng@intel.com>, Sinclair Yeh <syeh@vmware.com>, Thomas Hellstrom <thellstrom@vmware.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 12, 2019 at 12:27:05PM -0600, Shiraz Saleem wrote:
> On Fri, Jan 04, 2019 at 10:35:43PM +0000, Jason Gunthorpe wrote:
> > Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w=
/o
> > backing pages") introduced the sg_page_iter_dma_address() function with=
out
> > providing a way to use it in the general case. If the sg_dma_len is not
> > equal to the dma_length callers cannot safely use the
> > for_each_sg_page/sg_page_iter_dma_address combination.
> >=20
> > Resolve this API mistake by providing a DMA specific iterator,
> > for_each_sg_dma_page(), that uses the right length so
> > sg_page_iter_dma_address() works as expected with all sglists. A new
> > iterator type is introduced to provide compile-time safety against wron=
gly
> > mixing accessors and iterators.
> [..]
>=20
> > =20
> > +/*
> > + * sg page iterator for DMA addresses
> > + *
> > + * This is the same as sg_page_iter however you can call
> > + * sg_page_iter_dma_address(@dma_iter) to get the page's DMA
> > + * address. sg_page_iter_page() cannot be called on this iterator.
> > + */
> Does it make sense to have a variant of sg_page_iter_page() to get the
> page descriptor with this dma_iter? This can be used when walking DMA-map=
ped
> SG lists with for_each_sg_dma_page.

I think that would be a complicated cacluation to find the right
offset into the page sg list to get the page pointer back. We can't
just naively use the existing iterator location.

Probably places that need this are better to run with two iterators,
less computationally expensive.

Did you find a need for this?=20

Jason
