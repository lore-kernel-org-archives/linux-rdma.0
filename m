From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] ib_srp: initialize dma_length in srp_map_idb
Date: Mon, 16 Nov 2015 09:52:47 -0800
Message-ID: <564A17EF.8060205@sandisk.com>
References: <1447610393-2899-1-git-send-email-hch@lst.de>
 <564A0F56.8060408@sandisk.com> <20151116172249.GA576@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20151116172249.GA576@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "sagig@dev.mellanox.co.il" <sagig@dev.mellanox.co.il>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 11/16/2015 09:22 AM, Christoph Hellwig wrote:
> the code in this area changed enough since 4.3 that it won't easily
> apply.  But a backport would still be very useful!

In that case:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
