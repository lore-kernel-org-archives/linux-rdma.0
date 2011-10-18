From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: drivers/net separation change - impact on 3.2 mlx4 patches
Date: Wed, 19 Oct 2011 01:40:43 +0200
Message-ID: <CAJZOPZJfO5hkVaBNYWa52Y_RgiixNaGS7JWc7PEsML7agxPeBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

I just recalled that once the 3.2 merge window opens Dave is going to
push that drivers/net separation change done by Jeff K. which moves
drivers/net/mlx4 to drivers/net/ethernet/mellanox/mlx4 see
https://github.com/davem330/net-next/tree/master/drivers/net/ethernet/mellanox/mlx4
- is this going to introduce problem with mlx4 patches you gonna push
from your net-next or the git creature can pass that safely? if
there's an issue here, what would be the correct method to resolve
that? maybe wait a day or two for Dave's pull request and the actual
pull by Linus and then rebase the infiniband/for-next tree/branch on a
snapshot of Linus tree and then send a pull request?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
