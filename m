From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 07:55:50 -0700
Message-ID: <20140624145550.GA25526@infradead.org>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
 <1402477799-24610-2-git-send-email-sagig@mellanox.com>
 <53A920B2.9060503@cs.wisc.edu>
 <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
 <53A97849.8060509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53A97849.8060509@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 24, 2014 at 04:08:25PM +0300, Sagi Grimberg wrote:
> >Oh, I see. So things break because iSCSI uses scsi_transfer_length()
> >where the scatterlist length was used in the past.
> 
> Ohhh, didn't notice this one and sent out a duplicate...
> 
> The patch looks good to me obviously.

Can you give me a real reviewed-by?

> 
> Sagi.
---end quoted text---
