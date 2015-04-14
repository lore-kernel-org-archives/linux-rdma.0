From: Erez Shitrit <erezsh@dev.mellanox.co.il>
Subject: Re: [PATCH linux-next 1/4] infiniband/ipoib: fix possible NULL
 pointer dereference in ipoib_get_iflink
Date: Tue, 14 Apr 2015 19:30:03 +0300
Message-ID: <CAAk-MO-O9sjHQvDfCEuzJJPvUMXJTuRaCzrCkB0xc1DUfK8Aew@mail.gmail.com>
References: <1429024817-21561-1-git-send-email-honli@redhat.com>
	<1429024817-21561-2-git-send-email-honli@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1429024817-21561-2-git-send-email-honli@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Honggang Li <honli@redhat.com>
Cc: Roland Dreier <roland@kernel.org>, sean.hefty@intel.com, hal.rosenstock@gmail.com, kaber@trash.net, davem@davemloft.net, Alex Estrin <alex.estrin@intel.com>, Doug Ledford <dledford@redhat.com>, edumazet@google.com, Erez Shitrit <erezsh@mellanox.com>, nicolas.dichtel@6wind.com, maheshb@google.com, jbenc@redhat.com, ebiederm@xmission.com, elfring@users.sourceforge.net, f.fainelli@gmail.com, linux@roeck-us.net, andrew@lunn.ch, sfeldma@gmail.com, alexander.h.duyck@intel.com, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 14, 2015 at 6:20 PM, Honggang Li <honli@redhat.com> wrote:
>

[...]

Hi,

> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 657b89b..11ea6e2 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -846,7 +846,10 @@ static int ipoib_get_iflink(const struct net_device *dev)
>  {
>         struct ipoib_dev_priv *priv = netdev_priv(dev);
>
> -       return priv->parent->ifindex;
> +       if (priv && priv->parent)
> +               return priv->parent->ifindex;
> +       else
> +               return 0;
This will make parent interface to return 0 instead of its own ifindex.
I would suggest write something like that:

+       /* parent interface */
+       if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
+               return dev->ifindex;
+
+       /* child/vlan interface */
+       if (!priv->parent)
+               return -1;
+
        return priv->parent->ifindex;

Thanks,
Erez.

>  }
>
>  static u32 ipoib_addr_hash(struct ipoib_neigh_hash *htbl, u8 *daddr)
> --
> 1.8.3.1
>
