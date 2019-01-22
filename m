From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH 1/6] mm: make mm->pinned_vm an atomic64 counter
Date: Tue, 22 Jan 2019 10:45:33 -0500
Message-ID: <20190122154533.qivmjnburamqi4ut@ca-dmjordan1.us.oracle.com>
References: <20190121174220.10583-1-dave@stgolabs.net>
 <20190121174220.10583-2-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190121174220.10583-2-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, dledford@redhat.com, jgg@mellanox.com, jack@suse.de, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 21, 2019 at 09:42:15AM -0800, Davidlohr Bueso wrote:
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 6976e17dba68..640ae8a47c73 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -59,7 +59,7 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
>  	SEQ_PUT_DEC("VmPeak:\t", hiwater_vm);
>  	SEQ_PUT_DEC(" kB\nVmSize:\t", total_vm);
>  	SEQ_PUT_DEC(" kB\nVmLck:\t", mm->locked_vm);
> -	SEQ_PUT_DEC(" kB\nVmPin:\t", mm->pinned_vm);
> +	SEQ_PUT_DEC(" kB\nVmPin:\t", atomic64_read(&mm->pinned_vm));
>  	SEQ_PUT_DEC(" kB\nVmHWM:\t", hiwater_rss);
>  	SEQ_PUT_DEC(" kB\nVmRSS:\t", total_rss);
>  	SEQ_PUT_DEC(" kB\nRssAnon:\t", anon);

This is signed on 64b but printed as unsigned, so if some bug made pinned_vm go
negative, it would appear as an obviously wrong, gigantic number.  Seems ok.

For this patch, you can add

Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
