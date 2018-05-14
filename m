From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] IB/srpt: Increase port count
Date: Mon, 14 May 2018 05:03:28 -0700
Message-ID: <20180514120328.GA5081@infradead.org>
References: <20180510223209.10277-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180510223209.10277-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 10, 2018 at 03:32:09PM -0700, Bart Van Assche wrote:
> Since there are adapters that have four ports, increase the size of
> the srpt_device.port[] array. This patch avoids that the following
> warning is hit with quad port Chelsio adapters:
> 
>     WARN_ON(sdev->device->phys_port_cnt > ARRAY_SIZE(sdev->port));

Should we add a IB_MAX_PORTS define that ULPs can rely on in the core?
