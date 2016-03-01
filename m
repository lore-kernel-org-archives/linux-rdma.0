From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/9] IB/core: add a helper to check for READ WITH
	INVALIDATE support
Date: Tue, 1 Mar 2016 10:14:17 +0100
Message-ID: <20160301091417.GB2208@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-4-git-send-email-hch@lst.de> <56D55ABA.6070007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D55ABA.6070007@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, swise@opengridcomputing.com, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 01, 2016 at 11:02:50AM +0200, Sagi Grimberg wrote:
>
>> +/*
>> + * Check if the device supports READ W/ INVALIDATE.
>> + */
>> +static inline bool rdma_has_read_invalidate(struct ib_device *dev, u32 port_num)
>
> Is rdma_device_sup_read_inv() a better name?

I'm fine with any name.  Let's find some consensus before chaning it,
though.
