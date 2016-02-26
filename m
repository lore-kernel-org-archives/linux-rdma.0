From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 09/12] iser-target: Convert to new CQ API
Date: Thu, 25 Feb 2016 22:03:52 -0800
Message-ID: <1456466632.32369.56.camel@haakon3.risingtidesystems.com>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
	 <1456334649-21437-10-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456334649-21437-10-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2016-02-24 at 19:24 +0200, Sagi Grimberg wrote:
> From: Christoph Hellwig <hch@lst.de>
>=20
> Use the workqueue based CQ type similar to what isert was using previ=
ously,
> and properly split up the completion handlers.
>=20
> Note that this also takes special care to handle the magic login WRs
> separately, and also renames the submission functions so that it's cl=
ear
> that they are only to be used for the login buffers.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [sagig: added iscsi conn reinstatement in non-flush
>  error completions and added error completion type print]
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 405 +++++++++++++---------=
----------
>  drivers/infiniband/ulp/isert/ib_isert.h |  22 +-
>  2 files changed, 184 insertions(+), 243 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infini=
band/ulp/isert/ib_isert.c
> index ac3e80c55965..76ff3388890d 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c

<SNIP>

> @@ -3303,14 +3224,26 @@ isert_wait4cmds(struct iscsi_conn *conn)
>  }
> =20
>  static void
> +isert_beacon_done(struct ib_cq *cq, struct ib_wc *wc)
> +{
> +	struct isert_conn *isert_conn =3D wc->qp->qp_context;
> +
> +	isert_print_wc(wc);
> +
> +	isert_info("conn %p completing wait_comp_err\n", isert_conn);
> +	complete(&isert_conn->wait_comp_err);
> +}
> +

drivers/infiniband/ulp/isert/ib_isert.c: In function =E2=80=98isert_bea=
con_done=E2=80=99:
drivers/infiniband/ulp/isert/ib_isert.c:3221:2: error: too few argument=
s to function =E2=80=98isert_print_wc=E2=80=99
drivers/infiniband/ulp/isert/ib_isert.c:1538:1: note: declared here
make[4]: *** [drivers/infiniband/ulp/isert/ib_isert.o] Error 1
make[3]: *** [drivers/infiniband/ulp/isert] Error 2

=46ixing up the build breakage here.
