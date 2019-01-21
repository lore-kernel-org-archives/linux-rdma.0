From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 6/6] drivers/IB,core: reduce scope of mmap_sem
Date: Mon, 21 Jan 2019 18:32:26 +0000
Message-ID: <20190121183218.GK25149@mellanox.com>
References: <20190121174220.10583-1-dave@stgolabs.net>
 <20190121174220.10583-7-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190121174220.10583-7-dave@stgolabs.net>
Content-Language: en-US
Content-ID: <AF6C19A4E2A59848B1BBD303F838CD25@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "dledford@redhat.com" <dledford@redhat.com>, "jack@suse.de" <jack@suse.de>, "ira.weiny@intel.com" <ira.weiny@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 21, 2019 at 09:42:20AM -0800, Davidlohr Bueso wrote:
> ib_umem_get() uses gup_longterm() and relies on the lock to
> stabilze the vma_list, so we cannot really get rid of mmap_sem
> altogether, but now that the counter is atomic, we can get of
> some complexity that mmap_sem brings with only pinned_vm.
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  drivers/infiniband/core/umem.c | 41 ++----------------------------------=
-----
>  1 file changed, 2 insertions(+), 39 deletions(-)

I think this addresses my comment..

Considering that it is almost all infiniband, I'd rather it go it go
through the RDMA tree with an ack from mm people? Please advise..

Thanks,
Jason
