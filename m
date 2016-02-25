From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH 2/5] IB/isert: Split and properly type the login buffer
Date: Thu, 25 Feb 2016 17:19:11 +0200
Message-ID: <56CF1B6F.6000303@mellanox.com>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
 <1456148958-27973-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456148958-27973-3-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 2/22/2016 3:49 PM, Christoph Hellwig wrote:
> The login receive buffer is used as a iser_rx_desc, so type it as such
> in struct isert_conn and allocate the exactly right space for it.  The
> TX buffer is moved to a separate variable and properly sized as well.

looks good.

Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
