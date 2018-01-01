From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/ocrdma: Use zeroing memory allocator than allocator/memset
Date: Mon, 1 Jan 2018 13:45:44 +0530
Message-ID: <CA+sbYW3pUM+T-5CYGS4f1DdwxKy8kOtrCeNFqcKhRf7Vn4bgoA@mail.gmail.com>
References: <1514648396-6964-1-git-send-email-himanshujha199640@gmail.com> <20171231121209.GW3494@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171231121209.GW3494-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 31, 2017 at 5:42 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Sat, Dec 30, 2017 at 09:09:56PM +0530, Himanshu Jha wrote:
>> Use dma_zalloc_coherent for allocating zeroed
>> memory and remove unnecessary memset function.
>>
>> Done using Coccinelle.
>> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
>> 0-day tested with no failures.
>>
>> Suggested-by: Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 19 +++++++------------
>>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  6 ++----
>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  8 +++-----
>>  3 files changed, 12 insertions(+), 21 deletions(-)
>>
>
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Acked-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
