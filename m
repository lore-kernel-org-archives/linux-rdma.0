From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/2] Handle mlx4 max_sge_rd correctly
Date: Tue, 8 Dec 2015 09:01:39 -0800
Message-ID: <20151208170139.GA425@infradead.org>
References: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
 <5641C8BC.40507@dev.mellanox.co.il>
 <20151203142730.GA20520@infradead.org>
 <56605AB7.3000705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56605AB7.3000705@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@infradead.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 03, 2015 at 05:07:35PM +0200, Sagi Grimberg wrote:
> 
> >Did we ever make progress on this?
> 
> Just up to Doug to pull it in.

Doug, any chance to get this into the 4.4 queue?  It's annoying
having to work around this driver bug in every new ULP.
