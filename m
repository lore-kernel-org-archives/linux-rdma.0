From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] IB/isert: the kill ->isert_cmd back pointer in the
	struct iser_tx_desc
Date: Wed, 17 Feb 2016 15:19:10 +0100
Message-ID: <20160217141910.GB15646@lst.de>
References: <1455567060-18381-1-git-send-email-hch@lst.de> <1455567060-18381-5-git-send-email-hch@lst.de> <56C43DF3.8080509@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56C43DF3.8080509@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 17, 2016 at 11:31:31AM +0200, Max Gurtovoy wrote:
> maybe we can define it once as:
> static inline struct isert_cmd *
> isert_tx_to_cmd(iser_tx_desc *tx_desc)
> {
>    return container_of(tx_desc, struct isert_cmd, tx_desc);
> }
> in the .h file ?

Sure.
