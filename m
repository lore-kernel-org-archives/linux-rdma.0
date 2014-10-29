From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 03/12] scsi-mq: Add support for multiple hardware queues
Date: Wed, 29 Oct 2014 13:27:53 +0100
Message-ID: <5450DD49.6090108@acm.org>
References: <5433E43D.3010107@acm.org> <5433E4AB.8030306@acm.org> <yq1k33losu7.fsf@sermon.lab.mkp.net> <5450DC05.1010907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <5450DC05.1010907@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 10/29/14 13:22, Bart Van Assche wrote:
> Regarding nr_hw_queues and the SCSI host template: setting that
> parameter in the host template is supported.

(replying to my own e-mail)

Let me correct this: setting nr_hw_queues in the host template is not 
yet supported. If anyone would consider this useful, such functionality 
would be easy to add.

Bart.

