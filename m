From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] IB/cq: Don't process more than the given budget
Date: Wed, 8 Mar 2017 23:44:47 +0000
Message-ID: <1489016674.2813.11.camel@sandisk.com>
References: <1489014358-13638-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489014358-13638-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <7A414D33FB829C48A060BF4568611825-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-03-09 at 01:05 +0200, Sagi Grimberg wrote:
> The caller might not want this overhead.
>=20
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/infiniband/core/cq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
> index 2746d2eb3d52..21d1a38af489 100644
> --- a/drivers/infiniband/core/cq.c
> +++ b/drivers/infiniband/core/cq.c
> @@ -29,7 +29,8 @@ static int __ib_process_cq(struct ib_cq *cq, int budget=
)
>  {
>  	int i, n, completed =3D 0;
> =20
> -	while ((n =3D ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
> +	while ((n =3D ib_poll_cq(cq, min_t(u32, IB_POLL_BATCH,
> +			budget - completed), cq->wc)) > 0) {
>  		for (i =3D 0; i < n; i++) {
>  			struct ib_wc *wc =3D &cq->wc[i];
> =20

A comment that explains why min_t(u32, ...) is used would have been
welcome. Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
