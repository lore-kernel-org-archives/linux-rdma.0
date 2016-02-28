From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/13] IB/core: allow passing mapping an offset into
	the SG in ib_map_mr_sg
Date: Sun, 28 Feb 2016 17:20:12 +0100
Message-ID: <20160228162012.GA23791@lst.de>
References: <1456596631-19418-1-git-send-email-hch@lst.de> <1456596631-19418-3-git-send-email-hch@lst.de> <56D30AF7.1060205@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D30AF7.1060205@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 28, 2016 at 04:57:59PM +0200, Sagi Grimberg wrote:
> This looks wrong...
>
> The SG offset should not be taken into account in the address
> translation vector that is given to the HW. The sg_offset needs to
> be accounted in the mr->iova:
>
> mr->iova = sg_dma_address(&sgl[0]) + sg_offset;
>
> I think the page mappings should stay as the are.

I think you're right.  Do you have any good suggestion how to trigger
iSER first burst data, as apparently my normal testing didn't hit
this?
