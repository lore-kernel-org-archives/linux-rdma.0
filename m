From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [PATCH] infiniband: i40iw, nes: don't use wall time for TCP
 sequence numbers
Date: Fri, 22 Jun 2018 19:01:37 -0500
Message-ID: <20180623000137.GA17264@ssaleem-MOBL4.amr.corp.intel.com>
References: <20180618144443.137068-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180618144443.137068-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Latif, Faisal" <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "David S. Miller" <davem@davemloft.net>, "y2038@lists.linaro.org" <y2038@lists.linaro.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Orosco, Henry" <henry.orosco@intel.com>, "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, Jia-Ju Bai <baijiaju1990@gmail.com>, Yuval Shaia <yuval.shaia@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>, Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 18, 2018 at 08:44:17AM -0600, Arnd Bergmann wrote:
> The nes infiniband driver uses current_kernel_time() to get a nanosecond
> granunarity timestamp to initialize its tcp sequence counters. This is
> one of only a few remaining users of that deprecated function, so we
> should try to get rid of it.
> 
> Aside from using a deprecated API, there are several problems I see here:
> 
> - Using a CLOCK_REALTIME based time source makes it predictable in
>   case the time base is synchronized.
> - Using a coarse timestamp means it only gets updated once per jiffie,
>   making it even more predictable in order to avoid having to access
>   the hardware clock source
> - The upper 2 bits are always zero because the nanoseconds are at most
>   999999999.
> 
> For the Linux TCP implementation, we use secure_tcp_seq(), which appears
> to be appropriate here as well, and solves all the above problems.
> 
> I'm doing the same change in both versions of the nes driver, with
> i40iw being a later copy of the same code.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Thanks Arnd for the patch!

[...]

> @@ -2164,7 +2165,6 @@ static struct i40iw_cm_node *i40iw_make_cm_node(
>  				   struct i40iw_cm_listener *listener)
>  {
>  	struct i40iw_cm_node *cm_node;
> -	struct timespec ts;
>  	int oldarpindex;
>  	int arpindex;
>  	struct net_device *netdev = iwdev->netdev;
> @@ -2214,8 +2214,10 @@ static struct i40iw_cm_node *i40iw_make_cm_node(
>  	cm_node->tcp_cntxt.rcv_wscale = I40IW_CM_DEFAULT_RCV_WND_SCALE;
>  	cm_node->tcp_cntxt.rcv_wnd =
>  			I40IW_CM_DEFAULT_RCV_WND_SCALED >> I40IW_CM_DEFAULT_RCV_WND_SCALE;
> -	ts = current_kernel_time();
> -	cm_node->tcp_cntxt.loc_seq_num = ts.tv_nsec;
> +	cm_node->tcp_cntxt.loc_seq_num = secure_tcp_seq(htonl(cm_node->loc_addr[0]),
> +							htonl(cm_node->rem_addr[0]),
> +							htons(cm_node->loc_port),
> +							htons(cm_node->rem_port));

Should we not be using secure_tcpv6_seq() when we are ipv6?

Shiraz

>  	cm_node->tcp_cntxt.mss = (cm_node->ipv4) ? (iwdev->vsi.mtu - I40IW_MTU_TO_MSS_IPV4) :
>  				 (iwdev->vsi.mtu - I40IW_MTU_TO_MSS_IPV6);
>  
> 
