From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH] packet: Do not leak dev refcounts on error exit
Date: Tue, 8 Jan 2019 18:48:08 -0500
Message-ID: <CAF=yD-LfFfJHgkNESkNZ-RgXLQ6=Ag9TsOCppnvCyWT6oeMmcQ@mail.gmail.com>
References: <20190108232658.GA1911@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190108232658.GA1911@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: "David S. Miller" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Willem de Bruijn <willemb@google.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 8, 2019 at 6:41 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> 'dev' is non NULL when the addr_len check triggers so it must goto a label
> that does the dev_put otherwise dev will have a leaked refcount.
>
> This bug causes the ib_ipoib module to become unloadable when using
> systemd-network as it triggers this check on InfiniBand links.
>
> Fixes: 99137b7888f4 ("packet: validate address length")
> Reported-by: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Argh, indeed. Thanks for the fix.
