From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 6/6] drivers/IB,core: reduce scope of mmap_sem
Date: Mon, 21 Jan 2019 21:53:24 +0000
Message-ID: <01000168726760d6-6c4f2b48-870e-4a46-846b-3bb3d324000d-000000@email.amazonses.com>
References: <20190121174220.10583-1-dave@stgolabs.net> <20190121174220.10583-7-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190121174220.10583-7-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, dledford@redhat.com, jgg@mellanox.com, jack@suse.de, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

On Mon, 21 Jan 2019, Davidlohr Bueso wrote:

> ib_umem_get() uses gup_longterm() and relies on the lock to
> stabilze the vma_list, so we cannot really get rid of mmap_sem
> altogether, but now that the counter is atomic, we can get of
> some complexity that mmap_sem brings with only pinned_vm.

Reviewd-by: Christoph Lameter <cl@linux.com>
