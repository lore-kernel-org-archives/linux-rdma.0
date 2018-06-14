From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] infiniband: fix a subtle race condition
Date: Thu, 14 Jun 2018 08:34:46 +0300
Message-ID: <20180614053446.GB18426@mtr-leonro.mtl.com>
References: <20180613234947.15767-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613234947.15767-1-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2018 at 04:49:47PM -0700, Cong Wang wrote:
> In ucma_event_handler() we lock the mutex like this:
>
> mutex_lock(&ctx->file->mut);
> ...
> mutex_unlock(&ctx->file->mut);
>
> which seems correct, but we could translate it into this:
>
> f = ctx->file;
> mutex_lock(&f->mut);
> ...
> f = ctx->file;
> mutex_unlock(&f->mut);
>
> as the compiler does. And, because ucma_event_handler() is
> called in a workqueue so it could race with ucma_migrate_id(),
> so the following race condition could happen:
>
> CPU0			CPU1
> f = ctx->file;
> 			ucma_lock_files(f, new_file);
> 			ctx->file = new_file
> 			ucma_lock_files(f, new_file);
> mutex_lock(&f->mut); // still the old file!
> ...
> f = ctx->file; // now the new one!!
> mutex_unlock(&f->mut); // unlock new file!
>
> Fix this by reading ctx->file once before mutex_lock(), so we
> won't unlock a different mutex any more.

Hi Cong,

If the compiler optimizes the first line (mutex_lock) as you wrote,
it will reuse "f" for the second line (mutex_unlock) too.

You need to ensure that ucma_modify_id() doesn't run in parallel to
anything that uses "ctx->file" directly and indirectly.

Thanks

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbIf52AAoJEORje4g2clingTYP/2XQ/+vf4MVPCPrygtLQtMMC
3Wl229zSPmitY7vcmOEDxZRmf+rKPsrAIvJzhTOFg7KI4JFEzu4xRTx4xSHafTsF
LNhO6uTqkbWYim06ORL2+YTwYQuR7bcvRA0CdO6bhWaPaMTDKcodwKzMfhFLh5ST
fQ+O224B5mKvfRGPE76JWHKrT97PqpXNLzwSVeva4xazRo0IOPJ3AQqHRGUoe8Nx
a9TY2/uY/qxvDUlTLayk1hFoTYyhGMURZfswGta+eQGhDxoFcIpOv0aI4GlbxVUY
TjQVXMd+TAngmhq85hFg6uhhQfFugnMiTWSVkbEiODUUNf/rG/O98T/zEph3SsEm
dolpvRjXYvzCE+zNpW47Bly6P5Ymgqkwnn9hgUs7tGWR8Ac7ghARv7DPXgUmccZh
hRi5XreJpBgVeVwmVi7PiCsbf5lRiYmVA4m97szuNfFXfoMa0LMBPpnd9+EVJiIg
M5m4jWcRxK1RHloaAQlO812a1VMDLmq1wsBHykSCH240paF1YKuokR6ifOQVjQNf
40mIUleXtuRE+d5qOVCC/x0qM/E1xHz0pVpdV9Wgr3wkoK9llnKSkmcCblU27Dlf
TujtZafMUCBU86QGlNoZMoxdRB6UCnioCH0l1J3eb6bFdS8Z/KIhwlRU5wjGhxru
Xk7aGdHsqg77fQ97OW/L
=SGVL
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
