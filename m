From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 02/10] IB/iser: Reuse ib_sg_to_pages
Date: Wed, 9 Dec 2015 11:28:19 -0800
Message-ID: <20151209192819.GA21477@infradead.org>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
 <1449663128-368-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449663128-368-3-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2015 at 02:12:00PM +0200, Sagi Grimberg wrote:
> We have in iser iser_sg_to_page_vec which has exactly
> the same role as ib_sg_to_pages. Customize the page_vec
> to hold a fake MR so we can reuse ib_sg_to_pages.

Looks good.  In the long run we should simply kill struct ib_fmr
and make FRMs operate on struct ib_mr so that it can use
ib_sg_to_pages directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
