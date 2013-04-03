From: Erik Hugne <erik.hugne@ericsson.com>
Subject: Re: [PATCH 4/5] tipc: add InfiniBand media type
Date: Wed, 3 Apr 2013 16:41:40 +0200
Message-ID: <20130403144140.GA19219@eerihug-hybrid.ki.sw.ericsson.se>
References: <1364993010-15515-1-git-send-email-kaber@trash.net>
 <1364993010-15515-5-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1364993010-15515-5-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Cc: jon.maloy@ericsson.com, allan.stephens@windriver.com, netdev@vger.kernel.org, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 03, 2013 at 02:43:29PM +0200, Patrick McHardy wrote:
> diff --git a/net/tipc/Kconfig b/net/tipc/Kconfig
> index 4f99600..900ee66 100644
> --- a/net/tipc/Kconfig
> +++ b/net/tipc/Kconfig
> @@ -31,3 +31,10 @@ config TIPC_PORTS
>  
>  	  Setting this to a smaller value saves some memory,
>  	  setting it to higher allows for more ports.
> +
> +config TIPC_MEDIA_IB
> +	bool "InfiniBand media type support"
> +	depends on INFINIBAND_IPOIB
> +	help
> +	  Saying Y here will enable support for running TIPC on
> +	  IP-over-InfiniBand devices.
> diff --git a/net/tipc/Makefile b/net/tipc/Makefile
> index 6cd55d6..4df8e02 100644
> --- a/net/tipc/Makefile
> +++ b/net/tipc/Makefile
> @@ -9,3 +9,5 @@ tipc-y	+= addr.o bcast.o bearer.o config.o \
>  	   name_distr.o  subscr.o name_table.o net.o  \
>  	   netlink.o node.o node_subscr.o port.o ref.o  \
>  	   socket.o log.o eth_media.o
> +
> +tipc-$(CONFIG_TIPC_MEDIA_IB)	+= ib_media.o

The TIPC_MEDIA_IB option shows up directly under networking options,
instead of under "TIPC". I think "depends on TIPC" is missing?


//E
