From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] RXE checkpatch cleanup
Date: Thu, 15 Jun 2017 11:53:57 +0300
Message-ID: <20170615085356.GB3066@yuvallap>
References: <20170615082907.5658-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170615082907.5658-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 15, 2017 at 11:29:02AM +0300, Leon Romanovsky wrote:
> This patchset from Kamal cleanups some of the warnings
> and errors that he got from applying checkpatch.pl script
> on RXE files.
> 
> Kamal Heib (5):
>   IB/rxe: Use "foo *bar" instead of "foo * bar"
>   IB/rxe: Prefer 'unsigned int' to bare use of 'unsigned'
>   IB/rxe: Use DEVICE_ATTR_RO macro to show parent field
>   IB/rxe: Use __func__ to print function's name
>   IB/rxe: Constify static rxe_vm_ops

Besides some minor comment for #4.

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
>  drivers/infiniband/sw/rxe/rxe.h       |  2 +-
>  drivers/infiniband/sw/rxe/rxe_loc.h   |  2 +-
>  drivers/infiniband/sw/rxe/rxe_mmap.c  |  2 +-
>  drivers/infiniband/sw/rxe/rxe_pool.c  |  2 +-
>  drivers/infiniband/sw/rxe/rxe_req.c   |  2 +-
>  drivers/infiniband/sw/rxe/rxe_task.c  |  4 ++--
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 12 ++++++------
>  7 files changed, 13 insertions(+), 13 deletions(-)
> 
> --
> 2.12.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
