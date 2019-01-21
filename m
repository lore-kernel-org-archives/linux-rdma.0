From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 1/6] mm: make mm->pinned_vm an atomic64 counter
Date: Mon, 21 Jan 2019 21:51:47 +0000
Message-ID: <010001687265e644-49af6f45-e29b-41a7-9cd4-50ff8d64b9f9-000000@email.amazonses.com>
References: <20190121174220.10583-1-dave@stgolabs.net> <20190121174220.10583-2-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190121174220.10583-2-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, dledford@redhat.com, jgg@mellanox.com, jack@suse.de, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

On Mon, 21 Jan 2019, Davidlohr Bueso wrote
> Taking a sleeping lock to _only_ increment a variable is quite the
> overkill, and pretty much all users do this. Furthermore, some drivers
> (ie: infiniband and scif) that need pinned semantics can go to quite
> some trouble to actually delay via workqueue (un)accounting for pinned
> pages when not possible to acquire it.

Reviewed-by: Christoph Lameter <cl@linux.com>
