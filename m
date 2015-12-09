From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 03/10] IB/iser: Don't register memory for all
 immediate data writes
Date: Wed, 9 Dec 2015 11:30:47 -0800
Message-ID: <20151209193047.GB21477@infradead.org>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
 <1449663128-368-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449663128-368-4-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

The iser_reg_rdma_mem calling conventions seem rather confusing,
and this patch doesn't help that.  But I think that's something
to be addressed in bigger cleanup later on.

Reviewed-by: Christoph Hellwig <hch@lst.de>
