From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [iproute2] ipaddress: correctly print a VF hw address in the
 IPoIB case
Date: Tue, 18 Jun 2019 09:51:44 -0700
Message-ID: <20190618095144.4ef794a9@hermes.lan>
References: <20190615114056.100808-1-dkirjanov@suse.com>
        <20190615114056.100808-2-dkirjanov@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190615114056.100808-2-dkirjanov@suse.com>
Sender: netdev-owner@vger.kernel.org
To: Denis Kirjanov <kda@linux-powerpc.org>
Cc: dledford@redhat.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, mkubecek@suse.cz
List-Id: linux-rdma@vger.kernel.org

On Sat, 15 Jun 2019 13:40:56 +0200
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> diff --git a/include/uapi/linux/netdevice.h b/include/uapi/linux/netdevice.h
> index 86d961c9..aaa48818 100644
> --- a/include/uapi/linux/netdevice.h
> +++ b/include/uapi/linux/netdevice.h
> @@ -30,7 +30,7 @@
>  #include <linux/if_ether.h>
>  #include <linux/if_packet.h>
>  #include <linux/if_link.h>
> -
> +#include <linux/if_infiniband.h>

You can't modify kernel headers in iproute.
These are updated by a script and your change will get overwritten.

I did go ahead and put if_link.h and if_infiniband.h in already.
