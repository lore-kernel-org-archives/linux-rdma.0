From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 09/10] IB/iser: Increment the rkey when registering
 and not when invalidating
Date: Wed, 9 Dec 2015 11:38:06 -0800
Message-ID: <20151209193806.GG21477@infradead.org>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
 <1449663128-368-10-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449663128-368-10-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2015 at 02:12:07PM +0200, Sagi Grimberg wrote:
> With remote invalidate we won't local invalidate
> but we still want to increment the rkey.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
