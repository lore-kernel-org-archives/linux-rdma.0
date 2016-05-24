From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC ABI 8/8] IB/core: Implement device_create with the new ABI
Date: Tue, 24 May 2016 20:04:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0500F1@ORSMSX109.amr.corp.intel.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1464100526-31730-9-git-send-email-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464100526-31730-9-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +	filp = ib_uverbs_alloc_event_file(file, ib_dev, 1);
> +	if (IS_ERR(filp)) {
> +		ret = PTR_ERR(filp);
> +		goto err_fd;
> +	}

I was considering events being reported directly on the file that's already opened.  Any objects opened through a file would report their events on that file, with possibly a way to redirect events to a different file (similar to rdma_migrate_id processing).

I want to limit the number of open files that are needed -- to reduce resources and simplify things for apps. 

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
