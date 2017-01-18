From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/vmw_pvrdma: Defer activating device until vmxnet3
 link is up
Date: Wed, 18 Jan 2017 11:42:36 -0700
Message-ID: <20170118184236.GA4864@obsidianresearch.com>
References: <cover.1484075557.git.aditr@vmware.com>
 <4b515ded56300f12cedc67253d42ab8fbc52134e.1484075557.git.aditr@vmware.com>
 <20170116073858.GA25853@mtr-leonro.local>
 <35f6cce2-00c8-16b6-e3e0-481f234bd9c9@vmware.com>
 <VI1PR0502MB30081629AE674E7F24337835D17F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <ad2f92cd-f120-b04a-0e94-b49915cadf02@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ad2f92cd-f120-b04a-0e94-b49915cadf02-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2017 at 10:30:20AM -0800, Adit Ranadive wrote:

> We do register for netdev events so we get callbacks for the
> link state. The problem happens when we call ib_register before the vmxnet3
> link is up. At this point the ib_core stack already has created the QP1, etc.
> Once the vmxnet3 link is up we would have to call ib_unregister/ib_register
> to recreate QP1. This might fail/stuck if the there is a user app thats created
> QPs and we're just waiting to free those resources.

Having to register/unregister on every link transition sounds like a
horrible design, you should fix that :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
