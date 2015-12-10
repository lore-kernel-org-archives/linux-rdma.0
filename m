From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 02/13] irq_poll: don't disable new irq_poll instances
Date: Thu, 10 Dec 2015 10:41:46 -0800
Message-ID: <5669C76A.5050609@sandisk.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 12/07/2015 12:51 PM, Christoph Hellwig wrote:
> There is no good reason to start out disabled - drivers can control if
> the poll instance can be scheduled by simply not scheduling it yet.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
