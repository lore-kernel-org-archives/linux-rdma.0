From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v1 iproute2-next 2/4] Sync up rdma_netlink.h
Date: Thu, 21 Feb 2019 10:56:31 -0800
Message-ID: <20190221105631.7dfa5217@shemminger-XPS-13-9360>
References: <cover.1550773362.git.swise@opengridcomputing.com>
        <ff4f692bee0d683c0638cf88cbf14faf94ea87af.1550773362.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <ff4f692bee0d683c0638cf88cbf14faf94ea87af.1550773362.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 21 Feb 2019 08:19:07 -0800
Steve Wise <swise@opengridcomputing.com> wrote:

> Pull in the latest rdma_netlink.h to get the RDMA_NLDEV_CMD_NEWLINK /
> RDMA_NLDEV_CMD_DELLINK API.
> 
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/include/uapi/rdma/rdma_netlink.h | 74 +++++++++++++++++++++++++++--------
>  1 file changed, 58 insertions(+), 16 deletions(-)
> 
> diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
> index 04c80cebef49..23a90ad52485 100644
> --- a/rdma/include/uapi/rdma/rdma_netlink.h
> +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> @@ -5,8 +5,7 @@
>  #include <linux/types.h>
>  
>  enum {
> -	RDMA_NL_RDMA_CM = 1,
> -	RDMA_NL_IWCM,
> +	RDMA_NL_IWCM = 2,
>  	RDMA_NL_RSVD,
>  	RDMA_NL_LS,	/* RDMA Local Services */
>  	RDMA_NL_NLDEV,	/* RDMA device interface */

You can't just drop elements from user ABI headers.
That is a break of kernel ABI guarantee.

Instead, mark unused elements:
enum {
	RDMA_NL_RDMA_CM = 1, /* deprecated */
	RDMA_NL_IWCM, 
...
