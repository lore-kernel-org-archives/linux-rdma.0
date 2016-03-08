From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4 6/9] IB/core: add a need_inval flag to struct ib_mr
Date: Tue, 8 Mar 2016 11:41:26 -0800
Message-ID: <56DF2AE6.5030906@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457461000-24088-7-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "sagig@mellanox.com" <sagig@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Steve Wise <swise@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

On 03/08/2016 10:16 AM, Christoph Hellwig wrote:
> From: Steve Wise <swise@chelsio.com>
>
> This is the first step toward moving MR invalidation decisions
> to the core.  It will be needed by the upcoming RW API.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
