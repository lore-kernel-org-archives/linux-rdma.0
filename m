From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 09/13] IB/cma: Add net_dev and private data checks to
 RDMA CM
Date: Mon, 27 Jul 2015 23:07:24 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A901F99B@ORSMSX109.amr.corp.intel.com>
References: <1437924832-18327-1-git-send-email-haggaie@mellanox.com>
 <1437924832-18327-10-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437924832-18327-10-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -1040,6 +1040,181 @@ static int cma_save_net_info(struct sockaddr
> *src_addr,
>  	return cma_save_ip_info(src_addr, dst_addr, ib_event, service_id);
>  }
> 
> +struct cma_req_info {
> +	struct ib_device *device;
> +	int port;
> +	const union ib_gid *local_gid;

The use of a pointer to some gid inside some other structure looks questionable.  There's no reference count held on another structure.  We would be better off copying the GID or setting an index into the device GID table.

> +	__be64 service_id;
> +	u16 pkey;
> +};

Please relocate to the top of the source file to group it with other structure definitions.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
