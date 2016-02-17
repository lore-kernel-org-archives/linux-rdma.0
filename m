From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] IB/isert: properly type the login buffer
Date: Wed, 17 Feb 2016 02:33:25 -0800
Message-ID: <20160217103325.GB23954@infradead.org>
References: <1455567060-18381-1-git-send-email-hch@lst.de>
 <1455567060-18381-2-git-send-email-hch@lst.de>
 <56C35A17.6050305@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56C35A17.6050305@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 16, 2016 at 07:19:19PM +0200, Max Gurtovoy wrote:
> Hi Christoph,
> I have noticed that we are allocating login_req_buf sized
> ISCSI_DEF_MAX_RECV_SEG_LEN but the sge.lenth we post_recv is
> ISER_RX_LOGIN_SIZE, thus the rx_buflen in the recv completion is also
> ISER_RX_LOGIN_SIZE in case we are in login stage.
> I think we might crash here in case the initiator send request bigger than
> ISCSI_DEF_MAX_RECV_SEG_LEN, won't we ?

I just distangled the allocations..  But I think your are right, and
the existing code is already confused about the RX vs TX allocations.

I'll respin the patch to fix this issue and add a stable tag.
