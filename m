From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH 4/4] IB/isert: the kill ->isert_cmd back pointer in the
 struct iser_tx_desc
Date: Wed, 17 Feb 2016 11:31:31 +0200
Message-ID: <56C43DF3.8080509@mellanox.com>
References: <1455567060-18381-1-git-send-email-hch@lst.de>
 <1455567060-18381-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1455567060-18381-5-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi,

On 2/15/2016 10:11 PM, Christoph Hellwig wrote:
> We only use the pointer when processing regular iSER commands, and it then
> always points to the struct iser_cmd that contains the TX descriptor.
>
> Remove it and rely on container_of to save a little space and avoid a
> pointer that is updated multiple times per processed command.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c | 14 ++++++--------
>   drivers/infiniband/ulp/isert/ib_isert.h |  1 -
>   2 files changed, 6 insertions(+), 9 deletions(-)
>

maybe we can define it once as:
static inline struct isert_cmd *
isert_tx_to_cmd(iser_tx_desc *tx_desc)
{
    return container_of(tx_desc, struct isert_cmd, tx_desc);
}
in the .h file ?


cheers,
Max.
