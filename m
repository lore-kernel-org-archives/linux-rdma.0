From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK DEVICE (IBNBD)
Date: Fri, 24 Mar 2017 09:20:00 -0500
Message-ID: <03bc01d2a4a9$b8b69f10$2a23dd30$@opengridcomputing.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Content-Language: en-us
Sender: linux-block-owner@vger.kernel.org
To: 'Jack Wang' <jinpu.wang@profitbricks.com>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: dledford@redhat.com, axboe@kernel.dk, hch@lst.de, mail@fholler.de, Milind.dumbare@gmail.com, yun.wang@profitbricks.com
List-Id: linux-rdma@vger.kernel.org

> 
> From: Jack Wang <jinpu.wang@profitbricks.com>
> 
> This series introduces IBNBD/IBTRS kernel modules.
> 
> IBNBD (InfiniBand network block device) allows for an RDMA transfer of block
IO
> over InfiniBand network. The driver presents itself as a block device on
client
> side and transmits the block requests in a zero-copy fashion to the
server-side
> via InfiniBand. The server part of the driver converts the incoming buffers
back
> into BIOs and hands them down to the underlying block device. As soon as IO
> responses come back from the drive, they are being transmitted back to the
> client.

Hey Jack, why is this IB specific?  Can it work over iWARP transports as well?

Steve.
