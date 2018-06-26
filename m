From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH] IB/srpt: Support HCAs with more than two ports
Date: Tue, 26 Jun 2018 18:10:41 -0500
Message-ID: <023901d40da2$e77255c0$b6570140$@opengridcomputing.com>
References: <20180626222448.11411-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180626222448.11411-1-bart.vanassche@wdc.com>
Content-Language: en-us
Sender: stable-owner@vger.kernel.org
To: 'Bart Van Assche' <bart.vanassche@wdc.com>, 'Jason Gunthorpe' <jgg@ziepe.ca>
Cc: 'Doug Ledford' <dledford@redhat.com>, linux-rdma@vger.kernel.org, 'Christoph Hellwig' <hch@infradead.org>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH] IB/srpt: Support HCAs with more than two ports
> 
> Since there are adapters that have four ports, increase the size of
> the srpt_device.port[] array. This patch avoids that the following
> warning is hit with quad port Chelsio adapters:
> 
>     WARN_ON(sdev->device->phys_port_cnt > ARRAY_SIZE(sdev->port));
> 
> Reported-by: Steve Wise <swise@opengridcomputing.com>
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: <stable@vger.kernel.org>

Looks good.

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
