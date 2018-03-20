From: "Kalderon, Michal" <Michal.Kalderon@cavium.com>
Subject: RE: [PATCH v4 6/6] RDMA/qedr: eliminate duplicate barriers on
 weakly-ordered archs #2
Date: Tue, 20 Mar 2018 07:38:48 +0000
Message-ID: <CY1PR0701MB20128974717898F2D399431688AB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <1521514068-8856-1-git-send-email-okaya@codeaurora.org>
 <1521514068-8856-7-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521514068-8856-7-git-send-email-okaya@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "sulrich@codeaurora.org" <sulrich@codeaurora.org>
Cc: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "Elior, Ariel" <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> From: Sinan Kaya [mailto:okaya@codeaurora.org]
> Sent: Tuesday, March 20, 2018 4:48 AM
>=20
> Code includes wmb() followed by writel() in multiple places. writel() alr=
eady
> has a barrier on some architectures like arm64.
>=20
> This ends up CPU observing two barriers back to back before executing the
> register write.
>=20
> Since code already has an explicit barrier call, changing writel() to
> writel_relaxed().
>=20
> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qedr/verbs.c
> b/drivers/infiniband/hw/qedr/verbs.c
> index ccd55f4..db60360 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -860,7 +860,7 @@ static void doorbell_cq(struct qedr_cq *cq, u32 cons,
> u8 flags)
>  	wmb();
>  	cq->db.data.agg_flags =3D flags;
>  	cq->db.data.value =3D cpu_to_le32(cons);
> -	writeq(cq->db.raw, cq->db_addr);
> +	writeq_relaxed(cq->db.raw, cq->db_addr);
>=20
>  	/* Make sure write would stick */
>  	mmiowb();
> @@ -3338,7 +3338,7 @@ int qedr_post_recv(struct ib_qp *ibqp, struct
> ib_recv_wr *wr,
>=20
>  		qp->rq.db_data.data.value++;
>=20
> -		writel(qp->rq.db_data.raw, qp->rq.db);
> +		writel_relaxed(qp->rq.db_data.raw, qp->rq.db);
>=20
>  		/* Make sure write sticks */
>  		mmiowb();
> --
> 2.7.4
Acked-by: Michal Kalderon <Michal.Kalderon@cavium.com>
