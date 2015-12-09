From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 04/10] IB/iser: set intuitive values for mr_valid
Date: Wed, 9 Dec 2015 11:32:15 -0800
Message-ID: <20151209193215.GC21477@infradead.org>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
 <1449663128-368-5-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449663128-368-5-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2015 at 02:12:02PM +0200, Sagi Grimberg wrote:
> From: Jenny Derzhavetz <jennyf@mellanox.com>
> 
> This parameter is described as "is mr valid indicator".
> In other words, it indicates whether memory registration
> is valid or not. So intuitive values would be:
> mr_valid=True, when memory registration is valid and
> mr_valid=False otherwise.

Might be worth to rename it to 'bool need_invalidate', but otherwise
looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
