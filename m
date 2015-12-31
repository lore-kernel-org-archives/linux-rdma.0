From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Expose ioctl command to retrieve SGID of a
 given socket
Date: Thu, 31 Dec 2015 17:31:44 +0200
Message-ID: <56854A60.6040202@mellanox.com>
References: <1451572875-24961-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451572875-24961-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/31/2015 4:41 PM, Yuval Shaia wrote:
> To support security applications, that need to filter out connections based
> on SGID, an ioctl command to retrieve SGID of a given socket is added.
[...]

+
+found:
+	if (!(neigh->nud_state & NUD_VALID))
+		return -EINVAL;
+
+	gid = (union ib_gid *)(neigh->ha + 4);
+	*sgid = be64_to_cpu(gid->global.interface_id);
+	*subnet_prefix = be64_to_cpu(gid->global.subnet_prefix);


wait (1st)

the neighbour holds a destination address, not source address, so why 
are you talking on SGID?!

wait (2nd)

what prevents you from getting this info in user space through netlink 
from the kernel rtnl routing/neighbour services?

> root@r-dcs54 ~]# ip r s  | grep 192.168.20.0/24
> 192.168.20.0/24 dev ib0  proto kernel  scope link  src 192.168.20.17

> [root@r-dcs54 ~]# ip n s  | grep ib0
> 192.168.20.18 dev ib0 lladdr 
> 80:00:00:48:fe:80:00:00:00:00:00:00:f4:52:14:03:00:01:da:81 DELAY


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
