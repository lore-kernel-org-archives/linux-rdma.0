From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 iproute2-next 3/6] rdma: Add CM_ID resource tracking
 information
Date: Mon, 26 Mar 2018 08:17:13 -0600
Message-ID: <f6dd4255-69b2-bb90-de92-bb633f7248ef@gmail.com>
References: <cover.1520020530.git.swise@opengridcomputing.com>
 <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 2/27/18 9:07 AM, Steve Wise wrote:
> diff --git a/rdma/rdma.h b/rdma/rdma.h
> index 5809f70..e55205b 100644
> --- a/rdma/rdma.h
> +++ b/rdma/rdma.h
> @@ -18,10 +18,12 @@
>  #include <libmnl/libmnl.h>
>  #include <rdma/rdma_netlink.h>
>  #include <time.h>
> +#include <net/if_arp.h>
>  
>  #include "list.h"
>  #include "utils.h"
>  #include "json_writer.h"
> +#include <rdma/rdma_cma.h>
>  

did you forget to add rdma_cma.h? I don't see that file in my repo.
