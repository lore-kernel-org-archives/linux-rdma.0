From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 02/11] IB/isert: seperate connection protection domains
 and dma MRs
Date: Mon, 13 Jan 2014 11:44:27 -0800
Message-ID: <1389642267.5567.448.camel@haakon3.risingtidesystems.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
	 <1389285658-7037-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1389285658-7037-3-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

On Thu, 2014-01-09 at 18:40 +0200, Sagi Grimberg wrote:
> It is more correct to seperate connections protection domains
> and dma_mr handles. protection information support requires to
> do so.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c |   46 ++++++++++++++++---------------
>  drivers/infiniband/ulp/isert/ib_isert.h |    2 -
>  2 files changed, 24 insertions(+), 24 deletions(-)
> 

Applied to for-next, given this patch does not depend on the proposed
VERBS protection changes.

--nab 


