From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/12] iser-target: Use ib_drain_qp
Date: Wed, 23 Mar 2016 00:48:26 -0700
Message-ID: <20160323074826.GA30916@infradead.org>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
 <1456334649-21437-13-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456334649-21437-13-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Now that ib_drain_qp and the iser patches in mainline it would be good
to get this one in as well through an update to either tree.
