From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4 8/9] target: enhance and export
 target_alloc_sgl/target_free_sgl
Date: Tue, 8 Mar 2016 13:37:41 -0800
Message-ID: <56DF4625.6080807@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457461000-24088-9-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "sagig@mellanox.com" <sagig@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 03/08/2016 10:16 AM, Christoph Hellwig wrote:
> The SRP target driver will need to allocate and chain it's own SGLs soon.
> For this export target_alloc_sgl, and add a new argument to it so that it
> can allocate an additional chain entry that doesn't point to a page.  Also
> export transport_free_sgl after renaming it to target_free_sgl to free
> these SGLs again.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
