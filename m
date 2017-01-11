From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] dma: Add dma_virt_ops
Date: Wed, 11 Jan 2017 00:56:25 -0800
Message-ID: <20170111085625.GA15575@infradead.org>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
 <20170111005648.14988-4-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111005648.14988-4-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>, Joerg Roedel <jroedel@suse.de>, Andy Lutomirski <luto@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>
List-Id: linux-rdma@vger.kernel.org

> +lib-$(CONFIG_HAS_DMA) += dma-virt.o

There probably should be a config option for it for two reasons:

 - do not bloat kernels that don't need it.
 - the feature can only work for 32-bit architectures or for
   64-bit architectures that set ARCH_DMA_ADDR_T_64BIT…
   Altenatiely this option would have to force
   ARCH_DMA_ADDR_T_64BIT when not yet set for 64-bit architectures.

And yes, this is currently broken already for, but we'd better fix it.
