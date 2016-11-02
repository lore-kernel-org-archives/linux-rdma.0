From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 10/10] IB/mlx5: Simplify completion into a wait_event
Date: Wed, 2 Nov 2016 17:59:24 +0200
Message-ID: <20161102155924.GJ3617@leon.nu>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
 <1477551554-30349-11-git-send-email-binoy.jayan@linaro.org>
 <8ceb7dbf-d242-1427-199a-b6ec82876f23@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SprEMcskhUyF0lyO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8ceb7dbf-d242-1427-199a-b6ec82876f23-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--SprEMcskhUyF0lyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 30, 2016 at 11:17:57PM +0200, Sagi Grimberg wrote:
>
>
> On 27/10/16 09:59, Binoy Jayan wrote:
> >Convert the completion 'mlx5_ib_umr_context:done' to a wait_event as it
> >just waits for the return value to be filled.

On top of Sagi's response, I'm failing to understand why it is needed.
Can you elaborate more about it?

> >
> >Signed-off-by: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >---
> > drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
> > drivers/infiniband/hw/mlx5/mr.c      | 9 +++++----
> > include/rdma/ib_verbs.h              | 1 +
> > 3 files changed, 7 insertions(+), 5 deletions(-)
> >
> >diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> >index de31b5f..cf496b5 100644
> >--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> >+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> >@@ -524,7 +524,7 @@ struct mlx5_ib_mw {
> > struct mlx5_ib_umr_context {
> > 	struct ib_cqe		cqe;
> > 	enum ib_wc_status	status;
> >-	struct completion	done;
> >+	wait_queue_head_t	wq;
> > };
> >
> > struct umr_common {
> >diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> >index dfaf6f6..49ff2af 100644
> >--- a/drivers/infiniband/hw/mlx5/mr.c
> >+++ b/drivers/infiniband/hw/mlx5/mr.c
> >@@ -846,14 +846,14 @@ static void mlx5_ib_umr_done(struct ib_cq *cq, struct ib_wc *wc)
> > 		container_of(wc->wr_cqe, struct mlx5_ib_umr_context, cqe);
> >
> > 	context->status = wc->status;
> >-	complete(&context->done);
> >+	wake_up(&context->wq);
> > }
> >
> > static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
> > {
> > 	context->cqe.done = mlx5_ib_umr_done;
> >-	context->status = -1;
> >-	init_completion(&context->done);
> >+	context->status = IB_WC_STATUS_NONE;
> >+	init_waitqueue_head(&context->wq);
> > }
> >
> > static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
> >@@ -873,7 +873,8 @@ static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
> > 	if (err) {
> > 		mlx5_ib_warn(dev, "UMR post send failed, err %d\n", err);
> > 	} else {
> >-		wait_for_completion(&umr_context.done);
> >+		wait_event(umr_context.wq,
> >+			   umr_context.status != IB_WC_STATUS_NONE);
>
> How is this simpler?
>
>
> > enum ib_wc_status {
> >+	IB_WC_STATUS_NONE = -1,
> > 	IB_WC_SUCCESS,
> > 	IB_WC_LOC_LEN_ERR,
> > 	IB_WC_LOC_QP_OP_ERR,
> >
>
> Huh? Where did this bogus status came from? IMHO, this is polluting
> the verbs interface for no good reason at all, sorry.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--SprEMcskhUyF0lyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYGg1cAAoJEORje4g2clinsx0P/1IiGxfUSwjMotr+yz3U7F1G
A4av1lFSzcOje2T/mPM1JlGoT+P7Wp/k5cBXrL/71jY4xe7+Nr05Z3X0kCNqxdoe
LXa9Gyu3juEpePwgha6JNZ0kGnXQFwp36Ho8QnGjHSnXFeRW9yp5Xhh2TzlmSmKw
c94OGjST9emuIVaUy83Z1RjtBZCDL85nqGqfw2plF9GI74Crul+2DFQIW0n/CufR
iEyJYB/woCRiJCo2GYeFcZ1qiGBgzmVAnT+V0wS0XnTJD+rBr36HmMSGLTHu/x1l
427dP9qgRF+MshRqxyy/LRhyUH/2VlUJegahOm0FfI6nYU2ttMpBGtCG/2IfaGk/
N298p/TXv6lE4a+BgIHPPxzgUPo+bYivHqWGkICKLHPnu8ZyiUbw5kVa+UjkExV3
LJesf1e0rYKYVl5KvyuoUVH6EyfRmakN+3lwruvCkW8UmfqA308/WhSC923WurDy
om5tLkywxk+6JhYAruZjUqTd+grSrLLT4ZlqDqit008Ge6kcsXovT7opWmRyaaTE
Ikf7mpsYMMrbIdCR6bBvF4zhRJO9qRs9e3gNNhB+hkeWToAgy88gRO0Mblj5G3na
wD+dShxMGT0xYOnUNJjDNqmB6cZ9AMVM4G9UTXmvFhnEPr5BHTBpjbhmr+VWfpkd
/khOxY+DVsPsbVMa7PgI
=7P0M
-----END PGP SIGNATURE-----

--SprEMcskhUyF0lyO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
