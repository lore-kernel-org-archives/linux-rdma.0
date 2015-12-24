From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 00/10] iSER support for remote invalidate
Date: Thu, 24 Dec 2015 02:15:14 -0800
Message-ID: <20151224101514.GB6438@infradead.org>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
 <1450671628.25674.27.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450671628.25674.27.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

> Applied to target-pending/for-next as v4.5-rc1 material, along with
> Reviewed-by tags from HCH.

So this is both in your and Dougs now it seems.  Given the non-trivial
merge with the other RDMA updates I'd suggest to drop it from the
target tree as Doug already sorted out the merge.
