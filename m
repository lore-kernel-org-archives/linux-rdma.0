From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Tue, 17 Nov 2015 02:15:55 -0800
Message-ID: <20151117101555.GB2569@infradead.org>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-11-git-send-email-sagig@mellanox.com>
 <564ADFCC.4030109@mellanox.com>
 <564AF929.60209@dev.mellanox.co.il>
 <564AFB93.9010602@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564AFB93.9010602@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 17, 2015 at 12:04:03PM +0200, Or Gerlitz wrote:
> Also, do we refuse to queuecommand a bidi? where?

Or, can you please do the basic research first?  Thanks! (Hint: check
how few drivers support bidi commands, and how it's enabled)
