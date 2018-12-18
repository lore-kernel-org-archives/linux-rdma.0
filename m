From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [RFC PATCH] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Tue, 18 Dec 2018 16:32:10 +0000
Message-ID: <20181218163202.GJ21949@mellanox.com>
References: <20181214233254.5860-1-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181214233254.5860-1-swarren@wwwdotorg.org>
Content-Language: en-US
Content-ID: <0F2054FFB39AA04BBB05692EB2A9E788@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tariq Toukan <tariqt@mellanox.com>, "Wei@wwwdotorg.org" <Wei@wwwdotorg.org>, "Hu@wwwdotorg.org" <Hu@wwwdotorg.org>, "\\ (Xavier\\)" <xavier.huwei@huawei.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 14, 2018 at 04:32:54PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> This is a port of commit 378efe798ecf ("RDMA/hns: Get rid of page
> operation after dma_alloc_coherent") to the mlx4 driver. That change was
> described as:
>=20
> > In general, dma_alloc_coherent() returns a CPU virtual address and
> > a DMA address, and we have no guarantee that the underlying memory
> > even has an associated struct page at all.
> >
> > This patch gets rid of the page operation after dma_alloc_coherent,
> > and records the VA returned form dma_alloc_coherent in the struct
> > of hem in hns RoCE driver.
>=20
> Differences in this port relative to the hns patch:
>=20
> 1) The hns patch only needed to fix a dma_alloc_coherent path, but this
> patch also needs to fix an alloc_pages path. This appears to be simple
> except for the next point.
>=20
> 2) The hns patch converted a bunch of code to consistently use
> sg_dma_len(mem) rather than a mix of that and mem->length However, it
> seems that sg_dma_len(mem) can be modified or zeroed at runtime, and so
> using it when calling e.g. __free_pages is problematic.

dma_len should only ever be used when programming a HW device to do
DMA. It certainly should never be used for anything else, so I'm not
sure why this description veered off into talking about alloc_pages?

If pages were allocated and described in a sg list then the CPU side
must use the pages/len part of the SGL to walk that list of pages.

I also don't really see a practical problem with putting the virtual
address pointer of DMA coherent memory in the SGL, so long as it is
never used in a DMA map operation or otherwise.

.. so again, what is it this is actually trying to fix in mlx4?

Jason
