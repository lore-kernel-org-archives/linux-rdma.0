From: 'Christoph Hellwig' <hch@lst.de>
Subject: Re: [PATCH 7/9] IB/core: generic RDMA READ/WRITE API
Date: Thu, 3 Mar 2016 19:05:29 +0100
Message-ID: <20160303180529.GA28371@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-8-git-send-email-hch@lst.de> <56D81790.8090305@dev.mellanox.co.il> <20160303120209.GC20543@lst.de> <56D8293C.1050306@dev.mellanox.co.il> <00b401d17561$854cb790$8fe626b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00b401d17561$854cb790$8fe626b0$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Sagi Grimberg' <sagig@dev.mellanox.co.il>, 'Christoph Hellwig' <hch@lst.de>, linux-rdma@vger.kernel.org, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 03, 2016 at 09:29:47AM -0600, Steve Wise wrote:
> Are there hard limits for iSER and NVMEF/RDMA?  If so, then perhaps
> the caller should pass that in and the RDMA-RW will choose the
> min(passed_in_max, device_max)?

Nope, no hard limit in the general case. 
