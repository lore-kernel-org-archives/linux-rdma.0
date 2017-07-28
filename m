From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] RXE checkpatch cleanup
Date: Fri, 28 Jul 2017 13:35:15 -0400
Message-ID: <1501263315.2593.19.camel@redhat.com>
References: <20170615082907.5658-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170615082907.5658-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-06-15 at 11:29 +0300, Leon Romanovsky wrote:
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
> 
>  drivers/infiniband/sw/rxe/rxe.h       |  2 +-
>  drivers/infiniband/sw/rxe/rxe_loc.h   |  2 +-
>  drivers/infiniband/sw/rxe/rxe_mmap.c  |  2 +-
>  drivers/infiniband/sw/rxe/rxe_pool.c  |  2 +-
>  drivers/infiniband/sw/rxe/rxe_req.c   |  2 +-
>  drivers/infiniband/sw/rxe/rxe_task.c  |  4 ++--
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 12 ++++++------
>  7 files changed, 13 insertions(+), 13 deletions(-)

Series applied, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
