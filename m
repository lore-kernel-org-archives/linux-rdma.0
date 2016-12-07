From: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/28] bnxt_re: register with the NIC driver
Date: Wed, 7 Dec 2016 18:21:48 -0500
Message-ID: <ad3d577c-760f-c003-394a-d80efe96400c@redhat.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
 <1480919912-1079-11-git-send-email-selvin.xavier@broadcom.com>
Reply-To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480919912-1079-11-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/05/2016 01:38 AM, Selvin Xavier wrote:
> This patch handles the registration with bnxt_en driver. The driver registers
> with netdev notifier chain. Upon receiving NETDEV_REGISTER event, the driver
> in turn registers with bnxt_en driver.
> 	1. bnxt_en's ulp_probe function returns a structure that contains information
> 	   about the device and additional entry points.
> 	2. bnxt_en driver returns 'struct bnxt_eth_dev' that contains set of operation
> 	   vectors that RocE driver invokes later.
> 	3. bnxt_request_msix() allows the RoCE driver to specify the number of MSI-X
> 	   vectors that are needed.
> 	4. bnxt_send_fw_msg () can be used to send messages to the FW
> 	5. bnxt_register_async_events() can be used to register for async event
> 	   callbacks.
> 
> Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxtre/Makefile       |   1 +
>  drivers/infiniband/hw/bnxtre/bnxt_re.h      |  48 +++
>  drivers/infiniband/hw/bnxtre/bnxt_re_main.c | 460 ++++++++++++++++++++++++++++
>  3 files changed, 509 insertions(+)
> 

[...]

> diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
> index 4c377dc..1c8171c 100644
> --- a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
> +++ b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
> @@ -13,10 +13,24 @@
>  
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
> +#include <linux/ethtool.h>
>  #include <linux/mutex.h>
>  #include <linux/list.h>
>  #include <linux/rculist.h>
> +#include <linux/spinlock.h>
> +#include <linux/pci.h>
> +#include <net/ipv6.h>
> +#include <net/addrconf.h>
> +
> +#include <rdma/ib_verbs.h>
> +#include <rdma/ib_user_verbs.h>
> +#include <rdma/ib_umem.h>
> +#include <rdma/ib_addr.h>
> +
> +#include "bnxt_ulp.h"
> +#include "bnxt_re_hsi.h"
>  #include "bnxt_re.h"
> +#include "bnxt.h"
>  static char version[] =
>  		BNXT_RE_DESC " v" ROCE_DRV_MODULE_VERSION "\n";
>  
> @@ -30,6 +44,396 @@ MODULE_VERSION(ROCE_DRV_MODULE_VERSION);
>  struct list_head bnxt_re_dev_list = LIST_HEAD_INIT(bnxt_re_dev_list);
>  DEFINE_MUTEX(bnxt_re_dev_lock);
>  static struct workqueue_struct *bnxt_re_wq;
> +
> +const char *bnxt_re_event2str[] = {"NONE", "UP", "DOWN", "REBOOT",
> +				   "CHANGE", "REGISTER", "UNREGISTER",
> +				   "CHANGEMTU", "CHANGEADDR", "GOING_DOWN",
> +				   "CHANGENAME", "FEAT_CHANGE",
> +				   "BONDING_FAILOVER", "PRE_UP",
> +				   "PRE_TYPE_CHANGE", "POST_TYPE_CHANGE",
> +				   "POST_INIT", "UNREGISTER_FINAL", "RELEASE",
> +				   "NOTIFY_PEERS", "JOIN", "CHANGEUPPER",
> +				   "RESEND_IGMP", "PRECHANGEMTU",
> +				   "CHANGEINFODATA", "BONDING_INFO",
> +				   "UNKNOWN"};
> +
> +#define NETDEV_UNKNOWN	25
> +

[...]

> +
> +static inline const char *bnxt_re_netevent(unsigned long event)
> +{
> +	if (event >= ARRAY_SIZE(bnxt_re_event2str))
> +		event = NETDEV_UNKNOWN;
> +	return bnxt_re_event2str[(event)];
> +}

Where is this function ever used in the series?

$ git log -1 --oneline
8b8b72dd6226 bnxt_re: Add QP event handling
$ git grep "bnxt_re_netevent"
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:static inline const char
*bnxt_re_netevent(unsigned long event)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
