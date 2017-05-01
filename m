From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: net/smc and the RDMA core
Date: Mon, 1 May 2017 16:04:53 -0500
Message-ID: <03b101d2c2be$945c7df0$bd1579d0$@opengridcomputing.com>
References: <20170501163311.GA22209@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170501163311.GA22209@lst.de>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>, 'Ursula Braun' <ubraun@linux.vnet.ibm.com>, "'David S. Miller'" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> 
> Hi Ursual, hi netdev reviewers,
> 
> how did the smc protocol manage to get merged without any review
> on linux-rdma at all?  As the results it seems it's very substandard
> in terms of RDMA API usage, e.g. it neither uses the proper CQ API
> nor the RDMA R/W API, and other will probably find additional issues
> as well.
> --

And it only supports RoCE (and maybe IB).
