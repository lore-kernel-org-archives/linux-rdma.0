From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 02/10] IB/iser: Reuse ib_sg_to_pages
Date: Thu, 10 Dec 2015 06:49:31 -0800
Message-ID: <20151210144931.GA15756@infradead.org>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
 <1449663128-368-3-git-send-email-sagig@mellanox.com>
 <20151209192819.GA21477@infradead.org>
 <566937CB.80803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <566937CB.80803@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 10:28:59AM +0200, Sagi Grimberg wrote:
> We can do that. We'd need to add ib_mr a list member just for fmr
> routines.

We'll also need that for a FR pool abstraction that would be very
helpful.
