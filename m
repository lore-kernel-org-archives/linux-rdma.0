From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH] infiniband:Fix error handling in the function
 cm_init_av_by_path
Date: Tue, 8 Sep 2015 16:42:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A903951C@ORSMSX109.amr.corp.intel.com>
References: <1441655267-1462-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441655267-1462-1-git-send-email-xerofoify@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "Weiny, Ira" <ira.weiny@intel.com>, "yun.wang@profitbricks.com" <yun.wang@profitbricks.com>, "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>, "david.ahern@oracle.com" <david.ahern@oracle.com>, "erezsh@mellanox.com" <erezsh@mellanox.com>, "ted.h.kim@oracle.com" <ted.h.kim@oracle.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> This fixes error handling in the function cm_init_av_by_path
> to properly check if the internal call to the function
> ib_init_ah_from_path has failed by returning a error code and
> if so return immediately to the caller with this error code in
> order to signal/allow the caller to handle the error in its own
> intended error paths.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Acked-by: Sean Hefty <sean.hefty@intel.com>

> ---
>  drivers/infiniband/core/cm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index 3a972eb..cb021fd 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -379,8 +379,10 @@ static int cm_init_av_by_path(struct ib_sa_path_rec
> *path, struct cm_av *av)
>  		return ret;
> 
>  	av->port = port;
> -	ib_init_ah_from_path(cm_dev->ib_device, port->port_num, path,
> -			     &av->ah_attr);
> +	ret = ib_init_ah_from_path(cm_dev->ib_device, port->port_num, path,
> +				   &av->ah_attr);
> +	if (ret)
> +		return ret;
>  	av->timeout = path->packet_life_time + 1;
>  	memcpy(av->smac, path->smac, sizeof(av->smac));
> 
> --
> 2.1.4
