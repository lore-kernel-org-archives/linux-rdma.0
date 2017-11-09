From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH for-next] iw_cxgb4: Fix possible circular dependency locking warning
Date: Thu, 9 Nov 2017 08:44:45 -0600
Message-ID: <012b01d35969$48d7d9a0$da878ce0$@opengridcomputing.com>
References: <1510229853-25875-1-git-send-email-bharat@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510229853-25875-1-git-send-email-bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Locking sequence of iw_cxgb4 and RoCE drivers in ib_register_device() is
> slightly different and this leads to possible circular dependency locking
> warning when both the devices are brought up.
> 
> Here is the locking sequence upto ib_register_device():
> iw_cxgb4: rtnl_mutex(net stack) --> uld_mutex --> device_mutex
> RoCE drivers: device_mutex --> rtnl_mutex
> 
> Here is the possibility of cross locking:
> 
> 	CPU #0 (iw_cxgb4) 		     CPU #1 (RoCE drivers)
> 
> -> on interface up cxgb4_up()
> executed with rtnl_mutex held
> -> hold uld_mutex and try
> registering ib device
> 					-> In ib_register_device() hold
> 					   device_mutex
> -> hold device mutex in
> ib_register_device
> 					-> try acquiring rtnl_mutex in
> 					   ib_enum_roce_netdev()
> 
> Current patch schedules the ib_register_device() functionality of
> iw_cxgb4 to a workqueue to prevent the possible cross-locking.
> Also rename the labels in c4iw_reister_device().
> 
> Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
