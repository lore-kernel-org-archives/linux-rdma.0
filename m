From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] Move dma_ops from archdata into struct device
Date: Fri, 9 Dec 2016 19:22:30 +0100
Message-ID: <20161209182230.GC16622@lst.de>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com>
	<58a325aa-8df7-6a2e-fadb-5d9031d8a1a0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <58a325aa-8df7-6a2e-fadb-5d9031d8a1a0@sandisk.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-arch@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Doug Ledford <dledford@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

We'll need a bit of a wieder audience for this I think..

On Wed, Dec 07, 2016 at 05:11:28PM -0800, Bart Van Assche wrote:
> Additionally, introduce set_dma_ops(). A later patch will introduce a
> call to that function in the RDMA drivers that will be modified to use
> dma_noop_ops.

This looks good to me, and we had a lot of talk about this for other
purposes for a while. 
