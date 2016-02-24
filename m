From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] IB/isert: Convert to new CQ API
Date: Wed, 24 Feb 2016 19:43:48 +0100
Message-ID: <20160224184348.GA5241@lst.de>
References: <1456148958-27973-1-git-send-email-hch@lst.de> <1456148958-27973-4-git-send-email-hch@lst.de> <56CDD3D7.7060408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56CDD3D7.7060408@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 24, 2016 at 06:01:27PM +0200, Sagi Grimberg wrote:
> I don't find the wr_cqe address all that useful. I modified
> isert_print_wc to get a error type instead ("send", "recv", "rdma
> write"...) sounds fine?

Fine with me.
