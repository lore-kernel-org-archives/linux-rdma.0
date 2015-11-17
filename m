From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-next 00/10] iSER support for remote invalidate
Date: Tue, 17 Nov 2015 01:35:10 -0800
Message-ID: <20151117093510.GA30398@infradead.org>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 16, 2015 at 06:37:31PM +0200, Sagi Grimberg wrote:
> This patchset adds remote invalidation support to iser initiator and
> target. The support negotiation for this feature is based on IBTA
> annex 12 "Support for iSCSI Extensions for RDMA" carried in rdma_cm
> private data.

Oh, okay - this answers my question where the private data comes from,
might be worth documenting it in the header what standard each bit
comes from.
