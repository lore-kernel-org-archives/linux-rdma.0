From: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next 1/2] ipoib: correcly show a VF hardware address
Date: Wed, 12 Jun 2019 14:09:09 +0200
Message-ID: <20190612120909.GI31797@unicorn.suse.cz>
References: <20190612113348.59858-1-dkirjanov@suse.com>
 <20190612113348.59858-3-dkirjanov@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190612113348.59858-3-dkirjanov@suse.com>
Sender: netdev-owner@vger.kernel.org
To: Denis Kirjanov <kda@linux-powerpc.org>
Cc: davem@davemloft.net, dledford@redhat.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 12, 2019 at 01:33:47PM +0200, Denis Kirjanov wrote:
> in the case of IPoIB with SRIOV enabled hardware
> ip link show command incorrecly prints
> 0 instead of a VF hardware address. To correcly print the address
> add a new field to specify an address length.
> 
> Before:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0 MAC 00:00:00:00:00:00, spoof checking off, link-state disable,
> trust off, query_rss off
> ...
> After:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
> checking off, link-state disable, trust off, query_rss off
> ...
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
...
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 5b225ff63b48..904ee1a7330b 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -702,6 +702,7 @@ enum {
>  struct ifla_vf_mac {
>  	__u32 vf;
>  	__u8 mac[32]; /* MAX_ADDR_LEN */
> +	__u8 addr_len;
>  };

This structure is part of userspace API, adding a member would break
compatibility between new kernel and old iproute2 and vice versa. Do we
need to pass MAC address length for each VF if (AFAICS) it's always the
same as dev->addr_len?

Michal
