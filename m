From: "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH 7/6] Documentation/infiniband: update from locked to
 pinned_vm
Date: Tue, 12 Feb 2019 00:35:08 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E79BCF60F@CRSMSX101.amr.corp.intel.com>
References: <20190206175920.31082-1-dave@stgolabs.net>
 <20190207013155.lq5diwqc2svyt3t3@linux-r8p5>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190207013155.lq5diwqc2svyt3t3@linux-r8p5>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "jgg@mellanox.com" <jgg@mellanox.com>, "jack@suse.cz" <jack@suse.cz>, "willy@infradead.org" <willy@infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Davidlohr Bueso [mailto:dave@stgolabs.net]
> Sent: Wednesday, February 06, 2019 5:32 PM
> To: jgg@ziepe.ca; akpm@linux-foundation.org
> Cc: dledford@redhat.com; jgg@mellanox.com; jack@suse.cz;
> willy@infradead.org; Weiny, Ira <ira.weiny@intel.com>; linux-
> rdma@vger.kernel.org; linux-mm@kvack.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 7/6] Documentation/infiniband: update from locked to
> pinned_vm
> 
> We are really talking about pinned_vm here.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  Documentation/infiniband/user_verbs.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/infiniband/user_verbs.txt
> b/Documentation/infiniband/user_verbs.txt
> index df049b9f5b6e..47ebf2f80b2b 100644
> --- a/Documentation/infiniband/user_verbs.txt
> +++ b/Documentation/infiniband/user_verbs.txt
> @@ -46,11 +46,11 @@ Memory pinning
>    I/O targets be kept resident at the same physical address.  The
>    ib_uverbs module manages pinning and unpinning memory regions via
>    get_user_pages() and put_page() calls.  It also accounts for the
> -  amount of memory pinned in the process's locked_vm, and checks that
> +  amount of memory pinned in the process's pinned_vm, and checks that
>    unprivileged processes do not exceed their RLIMIT_MEMLOCK limit.
> 
>    Pages that are pinned multiple times are counted each time they are
> -  pinned, so the value of locked_vm may be an overestimate of the
> +  pinned, so the value of pinned_vm may be an overestimate of the
>    number of pages pinned by a process.
> 
>  /dev files
> --
> 2.16.4
