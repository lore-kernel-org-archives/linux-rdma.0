From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] ucma: fix a use-after-free in ucma_resolve_ip()
Date: Thu, 13 Sep 2018 08:49:15 +0300
Message-ID: <20180913054915.GF5257@mtr-leonro.mtl.com>
References: <20180912232744.12693-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180912232744.12693-1-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 12, 2018 at 04:27:44PM -0700, Cong Wang wrote:
> There is a race condition between ucma_close() and ucma_resolve_ip():
>
> CPU0				CPU1
> ucma_resolve_ip():		ucma_close():
>
> ctx = ucma_get_ctx(file, cmd.id);
>
>         list_for_each_entry_safe(ctx, tmp, &file->ctx_list, list) {
>                 mutex_lock(&mut);
>                 idr_remove(&ctx_idr, ctx->id);
>                 mutex_unlock(&mut);
> 		...
>                 mutex_lock(&mut);
>                 if (!ctx->closing) {
>                         mutex_unlock(&mut);
>                         rdma_destroy_id(ctx->cm_id);
> 		...
>                 ucma_free_ctx(ctx);
>
> ret = rdma_resolve_addr();
> ucma_put_ctx(ctx);
>
> Before idr_remove(), ucma_get_ctx() could still find the ctx
> and after rdma_destroy_id(), rdma_resolve_addr() may still
> access id_priv pointer. Also, ucma_put_ctx() may use ctx after
> ucma_free_ctx() too.
>
> ucma_close() should call ucma_put_ctx() too which tests the
> refcnt and waits for the last one releasing it. The similar
> pattern is already used by ucma_destroy_id().
>
> Reported-and-tested-by: syzbot+da2591e115d57a9cbb8b@syzkaller.appspotmail.com
> Reported-by: syzbot+cfe3c1e8ef634ba8964b@syzkaller.appspotmail.com
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  drivers/infiniband/core/ucma.c | 2 ++
>  1 file changed, 2 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbmfpbAAoJEORje4g2clinQaUP/0d6dV3SRWyPjtGDleFGTWZG
xSFbQte4gMTtF2PODzDPFz8TsNinHYzq/8x7Vxpabx0h9eOPkJiIqp9Wo6oEaysm
XB63Pw6+3FPRJWpDJyy365N80cNb0TMSQGs1gtbduU+Gpa4x7UapF4swstpSxsrd
9+2pGr+OcrQhq6kVwVxxrUF9dEiHFXbaA1aUZvcA400ISTjfZYCpoprB39g3DtwQ
tmBKo6kaKjZaHSEE6Du18FwqTSYB2DU+MlsU5w3AJzEIGfj422dSMBwgeHz9KCJL
vSfdXXoj3Se02NuVD3ccaxkI+mabscOx/jPUkqRnd29Uc0Y8oJW9xvu63yy4NlX3
uCeoSmdpA2gmukIFSj0VUyxBIYlaLPjhpuzIg4H1YWl//OlFNHEle4b5JVeL7ley
lZzmLHY6aYHaat8lUtTZtoaIyam9o6tjgRheA4jK4QhLqdjtDptvJalI0QZWwY7c
tp0cMEnyNNNNGBV98fg/eXznXdozi/v77XML+i9YjvPWRsfuZECFwXKKt1YC9O2e
Fpsa5XBlYEc1/upWffiGhORLY5tbjYXDDlD8E6nWHRBG8wkBZUkBbNqLKtdISB+J
VccJI+9/O7TxW8XSXqLvBzq1VEH1f7K6po0X0wTK5qqdcKXFTs+YWxPl8XidgcXc
zgp5ff7BE5wDRapJJbYe
=iuSW
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
