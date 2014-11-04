From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 01/11] blk-mq: Add blk_mq_unique_tag()
Date: Tue, 4 Nov 2014 06:14:32 -0800
Message-ID: <20141104141432.GA446@infradead.org>
References: <545240AE.6060009@acm.org>
 <545240E7.5030206@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <545240E7.5030206@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

I've applied patches 1-3 to the core-for-3.19 branch.  Various srp
patches, including the first one fail to apply for me.  Can you
regenerate them against the drivers-for-3.19 branch?  Thanks!

