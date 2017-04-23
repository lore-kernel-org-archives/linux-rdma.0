From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 0/6] Automatic affinity settings for nvme over rdma
Date: Sun, 23 Apr 2017 15:01:45 +0300
Message-ID: <d0b188f2-9acd-5be8-8539-0428f67a5c57@grimberg.me>
References: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

> This patch set is aiming to automatically find the optimal
> queue <-> irq multi-queue assignments in storage ULPs (demonstrated
> on nvme-rdma) based on the underlying rdma device irq affinity
> settings.
>
> Changes from v1:
> - Removed mlx5e_get_cpu as Christoph suggested
> - Fixed up nvme-rdma queue comp_vector selection to get a better match
> - Added a comment on why we limit on @dev->num_comp_vectors
> - rebased to Jens's for-4.12/block
> - Collected review tags

Saeed, any comments on this?
