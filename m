From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 7/7] NVMe: CMB on DMA-BUF
Date: Mon, 1 Aug 2016 08:52:06 -0700
Message-ID: <20160801155206.GA23224@infradead.org>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
 <1470034653-9097-8-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470034653-9097-8-git-send-email-haggaie@mellanox.com>
Sender: linux-pci-owner@vger.kernel.org
To: Haggai Eran <haggaie@mellanox.com>
Cc: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, Liran Liss <liranl@mellanox.com>, linux-pci@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>, Stephen Bates <stephen.bates@microsemi.com>, Leon Romanovsky <leonro@mellanox.com>, Artemy Kovalyov <artemyko@mellanox.com>, Jerome Glisse <j.glisse@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 01, 2016 at 09:57:33AM +0300, Haggai Eran wrote:
> Allocate a CMB region to user-space as a DMA-BUF object.

NACK.  Absolutely no way we're going to export a low-level device
specific feature to userspace like that.  If you want to DMA to
the CMB do it from the kernel, and for that we'll need a proper
block device level API.
