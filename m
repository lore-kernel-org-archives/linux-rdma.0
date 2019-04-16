From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH for-rc] IB/rdmavt: Fix frwr memory registration
Date: Tue, 16 Apr 2019 10:15:24 +0000
Message-ID: <20190416101521.GA18792@mellanox.com>
References: <20190415183415.24136.56776.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190415183415.24136.56776.stgit@scvm10.sc.intel.com>
Content-Language: en-US
Content-ID: <44A88D06D421E24288BCDFD3D9FC08A2@eurprd05.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Josh Collier <josh.d.collier@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 15, 2019 at 11:34:22AM -0700, Dennis Dalessandro wrote:
> From: Josh Collier <josh.d.collier@intel.com>
>=20
> Current implementation was not properly handling frwr memory
> registrations. This was uncovered by:
>   commit 27f26cec761das
>   xprtrdma: Plant XID in on-the-wire RDMA offset (FRWR)
> in which xprtrdma, which is used for NFS over RDMA, started
> failing as it was the first ULP to modify the ib_mr iova
> resulting in the NFS server getting REMOTE ACCESS ERROR
> when attempting to perform RDMA Writes to the client.
>=20
> The fix is to properly capture the true iova, offset, and length
> in the call to ib_map_mr_sg, and then update the iova when
> processing the IB_WR_REG_MEM on the send queue.
>=20
> Fixes: a41081aa5936 ("IB/rdmavt: Add support for ib_map_mr_sg")
> Cc: stable@vger.kernel.org
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> Signed-off-by: Josh Collier <josh.d.collier@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> ---
>  drivers/infiniband/sw/rdmavt/mr.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)

Applied to for-rc

Thanks,
Jason
