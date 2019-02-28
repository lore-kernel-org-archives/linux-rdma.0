From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] at12: use pci_zalloc instead of pci_alloc
Date: Thu, 28 Feb 2019 06:00:45 -0800
Message-ID: <20190228140045.GA24819@infradead.org>
References: <cover.1551246708.git.bobbyeshleman@gmail.com>
 <485f61fd135d56e6e0c66ec41770ce7e5b8b219e.1551246708.git.bobbyeshleman@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <485f61fd135d56e6e0c66ec41770ce7e5b8b219e.1551246708.git.bobbyeshleman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Eshleman <bobbyeshleman@gmail.com>
Cc: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>, "David S. Miller" <davem@davemloft.net>, Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 26, 2019 at 10:09:52PM -0800, Robert Eshleman wrote:
> This patch replaces a pci_alloc and memset(,0) call
> with a single call to pci_zalloc.

Please don't move from one deprecated API to another one.  If you feel
like cleaning up DMA API calls please move to dma_alloc_coherent,
and do that for the whole DMA API usage.
