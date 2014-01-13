From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 07/11] IB/isert: pass scatterlist instead of cmd to
 fast_reg_mr routine
Date: Mon, 13 Jan 2014 11:45:51 -0800
Message-ID: <1389642351.5567.451.camel@haakon3.risingtidesystems.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
	 <1389285658-7037-8-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1389285658-7037-8-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Thu, 2014-01-09 at 18:40 +0200, Sagi Grimberg wrote:
> This routine may help for protection registration as well.
> This patch does not change any functionality.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c |   28 ++++++++++++----------------
>  1 files changed, 12 insertions(+), 16 deletions(-)

Also applied to for-next.

--nab

