From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH net-next] qed: Add srq core support for RoCE and iWARP
Date: Mon, 9 Jul 2018 10:42:04 -0600
Message-ID: <20180709164204.GB13496@ziepe.ca>
References: <20180530131137.4653-1-yuval.bason@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530131137.4653-1-yuval.bason@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Yuval Bason <yuval.bason@cavium.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, dledford@redhat.com, linux-rdma@vger.kernel.org, Michal Kalderon <michal.kalderon@cavium.com>, Ariel Elior <ariel.elior@cavium.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 30, 2018 at 04:11:37PM +0300, Yuval Bason wrote:
> This patch adds support for configuring SRQ and provides the necessary
> APIs for rdma upper layer driver (qedr) to enable the SRQ feature.
> 
> Signed-off-by: Michal Kalderon <michal.kalderon@cavium.com>
> Signed-off-by: Ariel Elior <ariel.elior@cavium.com>
> Signed-off-by: Yuval Bason <yuval.bason@cavium.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_cxt.c   |   5 +-
>  drivers/net/ethernet/qlogic/qed/qed_cxt.h   |   1 +
>  drivers/net/ethernet/qlogic/qed/qed_hsi.h   |   2 +
>  drivers/net/ethernet/qlogic/qed/qed_iwarp.c |  23 ++++
>  drivers/net/ethernet/qlogic/qed/qed_main.c  |   2 +
>  drivers/net/ethernet/qlogic/qed/qed_rdma.c  | 179 +++++++++++++++++++++++++++-
>  drivers/net/ethernet/qlogic/qed/qed_rdma.h  |   2 +
>  drivers/net/ethernet/qlogic/qed/qed_roce.c  |  17 ++-
>  include/linux/qed/qed_rdma_if.h             |  12 +-
>  9 files changed, 235 insertions(+), 8 deletions(-)

Is this a pre-requisite for your related RDMA patches?

If yes, are you proposing that this patch should go via the RDMA tree?

Jason
