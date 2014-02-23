From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/srp: Fix crash when unmapping data loop
Date: Sun, 23 Feb 2014 23:47:56 +0200
Message-ID: <CAJZOPZJv6FO6kEypn79QeeEZFyJW+YcMpfQ8xpMYW_zE1z3KZw@mail.gmail.com>
References: <1393157990-25020-1-git-send-email-sagig@mellanox.com>
	<1393157990-25020-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393157990-25020-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 23, 2014 at 2:19 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> When unmapping request data, it is unsafe automatically
> decrement req->nfmr regardless of it's value since IO and
> reconnect flow may run concurrently resulting in req->nfmr = -1
> and falsely call ib_fmr_pool_unmap.

punctuation... I think 1-2 commas are missing here

>
> Fix the loop condition to to be greater then zero (which
> explicitely means that FMRs were used on this request)
> and only increment when needed.

s/then/than/
s/explicitely/explicitly/

>
> This crash is easily reproduceable with SRIOV OR Connect-IB
> (where FMRs are not supported)

s/SRIOV/ConnectX VFs/

>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 529b6bc..0e20bfb 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -766,8 +766,11 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
>                 return;
>
>         pfmr = req->fmr_list;
> -       while (req->nfmr--)
> +
> +       while (req->nfmr > 0) {
>                 ib_fmr_pool_unmap(*pfmr++);
> +               req->nfmr--;
> +       }
>
>         ib_dma_unmap_sg(ibdev, scsi_sglist(scmnd), scsi_sg_count(scmnd),
>                         scmnd->sc_data_direction);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
