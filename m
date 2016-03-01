From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/9] IB/core: generic RDMA READ/WRITE API
Date: Tue, 1 Mar 2016 07:50:07 +0100
Message-ID: <20160301065007.GB31969@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-8-git-send-email-hch@lst.de> <56D4D077.9020706@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D4D077.9020706@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 29, 2016 at 03:12:55PM -0800, Bart Van Assche wrote:
> Hi Christoph,
>
> Are you aware that using max_sge is safe for some but not for all HCAs? See 
> also http://thread.gmane.org/gmane.linux.drivers.rdma/22043.

It should be safe, and the mlx4 bug has been fixed by Sagi a while ago
in commit a5e14b ("mlx4: Expose correct max_sge_rd limit").
