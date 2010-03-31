From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/srp: use IB_CQ_REPORT_MISSED_EVENTS to avoid
	missed CQ callbacks
Date: Wed, 31 Mar 2010 20:11:40 +0200
Message-ID: <y2ie2e108261003311111uec1ec00g746ba0ffe3d98799@mail.gmail.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
	 <20100331175752.24522.66519.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100331175752.24522.66519.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 31, 2010 at 7:57 PM, Ralph Campbell
<ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
>
> ib_req_notify_cq(IB_CQ_NEXT_COMP) is not guaranteed to generate
> a callback for the next completion entered since there is a race
> between arming the callback and another CQE being added to the queue.
> The IB_CQ_REPORT_MISSED_EVENTS flag was added to detect this
> race and allow the verbs consumer to call ib_poll_cq() and
> ib_req_notify_cq() again to avoid delays in processing the CQE.
>
> Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
> ---
>
> =A0drivers/infiniband/ulp/srp/ib_srp.c | =A0 =A07 ++++++-
> =A01 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
> index ed3f9eb..b0376f1 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -921,8 +921,9 @@ static void srp_recv_completion(struct ib_cq *cq,=
 void *target_ptr)
> =A0{
> =A0 =A0 =A0 =A0struct srp_target_port *target =3D target_ptr;
> =A0 =A0 =A0 =A0struct ib_wc wc;
> + =A0 =A0 =A0 int ret;
>
> - =A0 =A0 =A0 ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
> +again:
> =A0 =A0 =A0 =A0while (ib_poll_cq(cq, 1, &wc) > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (wc.status) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shost_printk(KERN_ERR,=
 target->scsi_host,
> @@ -934,6 +935,10 @@ static void srp_recv_completion(struct ib_cq *cq=
, void *target_ptr)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0srp_handle_recv(target, &wc);
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 ret =3D ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
IB_CQ_REPORT_MISSED_EVENTS);
> + =A0 =A0 =A0 if (ret > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto again;
> =A0}
>
> =A0static void srp_send_completion(struct ib_cq *cq, void *target_ptr=
)

NAK.

The SRP initiator works fine without this patch, and this patch slows
down the SRP initiator.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
