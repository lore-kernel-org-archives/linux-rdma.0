From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/9] IB/core: add a helper to check for READ WITH
 INVALIDATE support
Date: Tue, 1 Mar 2016 11:02:50 +0200
Message-ID: <56D55ABA.6070007@dev.mellanox.co.il>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456784410-20166-4-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: swise@opengridcomputing.com, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> +/*
> + * Check if the device supports READ W/ INVALIDATE.
> + */
> +static inline bool rdma_has_read_invalidate(struct ib_device *dev, u32 port_num)

Is rdma_device_sup_read_inv() a better name?
