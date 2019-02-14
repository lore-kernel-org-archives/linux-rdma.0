From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [rdma-rc PATCH 2/2] iw_cxgb4: cq/qp mask depends on bar2 pages in
 a host page
Date: Thu, 14 Feb 2019 15:41:34 +0000
Message-ID: <20190214154127.GD1725@mellanox.com>
References: <20190214121054.11693-1-rajur@chelsio.com>
 <20190214121054.11693-3-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190214121054.11693-3-rajur@chelsio.com>
Content-Language: en-US
Content-ID: <71B9D036799BE642AE1FFFBBFF1456CE@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Raju Rangoju <rajur@chelsio.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 14, 2019 at 05:40:54PM +0530, Raju Rangoju wrote:
> Adjust the cq/qp mask based on no.of bar2 pages in a host page.
>=20
> For user-mode rdma, the granularity of the BAR2 memory mapped
> to a user rdma process during queue allocation must be based
> on the host page size. The lld attributes udb_density and
> ucq_density are used to figure out how many sge contexts are
> in a bar2 page. So the rdev->qpmask and rdev->cqmask in
> iw_cxgb4 need to now be adjusted based on how many sge bar2
> pages are in a host page.

Why is this rc? Do certain arches fail to work or something?

Jason
