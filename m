From: Sumeet Lahorani <sumeet.lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: root owned writeable files under /sys
Date: Thu, 03 Jun 2010 14:58:48 -0700
Message-ID: <4C082598.8000809@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi All,

With ofed 1.5.1 (and it appears to be the case in prior versions as 
well), I see the following files created under /sys which are world 
writeable

# find /sys -type f -perm 222 -ls
  6834    0 --w--w--w-   1 root     root            0 Jun  3 14:50 
/sys/class/infiniband/mlx4_0/diag_counters/clear_diag
  8344    0 --w--w--w-   1 root     root         4096 Jun  3 14:43 
/sys/class/net/ib1/delete_child
  8343    0 --w--w--w-   1 root     root         4096 Jun  3 14:43 
/sys/class/net/ib1/create_child
  8295    0 --w--w--w-   1 root     root         4096 Jun  3 14:43 
/sys/class/net/ib0/delete_child
  8294    0 --w--w--w-   1 root     root            0 Jun  3 14:39 
/sys/class/net/ib0/create_child
  6017    0 --w--w--w-   1 root     root         4096 Jun  3 14:43 
/sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/port_trigger

ib0 & ib1 are slave interfaces corresponding to the 2 ports on a 
ConnectX HCA.

At least the create_child & delete_child files appear to be dangerous to 
leave as world writeable because they result in resources allocations. 
I'm not sure about the others. Do these have to be world writeable?

- Sumeet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
