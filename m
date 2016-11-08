From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: FW: [Bug 185551] New: rxe_rdma: RTNL: assertion failed at
 net/core/ethtool.c (550)
Date: Tue, 8 Nov 2016 11:41:58 +0200
Message-ID: <298c5d8d-bd58-c31f-9340-ee190268f495@mellanox.com>
References: <bug-185551-11804@https.bugzilla.kernel.org/>
 <HE1PR05MB157874BECC0B171C75933E1BA7A40@HE1PR05MB1578.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB157874BECC0B171C75933E1BA7A40-eBadYZ65MZ/9T9KkpKWrANqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: v.badalyan-mR0gyJWGnJgvJsYlp49lxw@public.gmane.org
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/6/2016 1:08 PM, Majd Dibbiny wrote:

>
> https://bugzilla.kernel.org/show_bug.cgi?id=185551
>
>             Bug ID: 185551
>            Summary: rxe_rdma: RTNL: assertion failed at net/core/ethtool.c
>                     (550)
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 4.8.5-1.el7.elrepo.x86_64
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Infiniband/RDMA
>           Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
>           Reporter: v.badalyan-mR0gyJWGnJgvJsYlp49lxw@public.gmane.org
>         Regression: No
>
> #rxe_cfg start
> #rxe_cfg add eno1.4004
> #rxe_cfg
>
> [root@intel2-i5 ~]# rxe_cfg
>   Name       Link  Driver  Speed  NMTU  IPv4_addr  RDEV  RMTU
>   DevNet     yes   bridge
>   eno1       yes   e1000e
>   eno1.4003  yes   802.1Q
>   eno1.4004  yes   802.1Q                          rxe0  4096  (5)
>   enp2s1     yes   r8169
>   ovirtmgmt  yes   bridge
>
>
how do i reproduce this ?
was rxe device coupled with a bridge-interface  ?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
