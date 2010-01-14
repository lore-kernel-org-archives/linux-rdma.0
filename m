From: Frank Leers <Frank.Leers-UdXhSnd/wVw@public.gmane.org>
Subject: Re: mode connected infiniband
Date: Thu, 14 Jan 2010 08:06:18 -0800
Message-ID: <92A5895F-F6BC-4916-B915-64643A2F51DF@sun.com>
References: <8fd3bb681001140011k5ec9492eg19b59b110e45a2b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <8fd3bb681001140011k5ec9492eg19b59b110e45a2b5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nico <parpandet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Jan 14, 2010, at 12:11 AM, Nico wrote:

> Hello,
> 
> I'am using an infiniband kernel 2.6.32-trunk-686 from debian,
> and it seems /sys/class/net/ib0/mode is missing :
> 

It might be that when OFED was built, the "CONFIG_INFINIBAND_IPOIB_CM=y" was set to 'n' in your 'configure.mk.kernel' or on the command line during the ./configure step - 

--with-ipoib-cm    make CONFIG_INFINIBAND_IPOIB_CM=y [yes]
--without-ipoib-cm   [no]

-frank


> vza:/sys/class/net/ib0# ls -l
> total 0
> -r--r--r-- 1 root root 4096 janv. 14 08:55 address
> -r--r--r-- 1 root root 4096 janv. 14 08:55 addr_len
> -r--r--r-- 1 root root 4096 janv. 14 08:55 broadcast
> -r--r--r-- 1 root root 4096 janv. 14 08:55 carrier
> --w--w--w- 1 root root 4096 janv. 14 08:55 create_child
> --w--w--w- 1 root root 4096 janv. 14 08:55 delete_child
> lrwxrwxrwx 1 root root    0 janv. 14 08:55 device -> ../../../0000:05:00.0
> -r--r--r-- 1 root root 4096 janv. 14 08:55 dev_id
> -r--r--r-- 1 root root 4096 janv. 14 08:55 dormant
> -r--r--r-- 1 root root 4096 janv. 14 08:55 features
> -rw-r--r-- 1 root root 4096 janv. 14 08:55 flags
> -rw-r--r-- 1 root root 4096 janv. 14 08:55 ifalias
> -r--r--r-- 1 root root 4096 janv. 14 08:55 ifindex
> -r--r--r-- 1 root root 4096 janv. 14 08:55 iflink
> -r--r--r-- 1 root root 4096 janv. 14 08:55 link_mode
> -rw-r--r-- 1 root root 4096 janv. 14 08:55 mtu
> -r--r--r-- 1 root root 4096 janv. 14 08:55 operstate
> -r--r--r-- 1 root root 4096 janv. 14 08:55 pkey
> drwxr-xr-x 2 root root    0 janv. 14 08:55 power
> drwxr-xr-x 2 root root    0 janv. 14 08:55 statistics
> lrwxrwxrwx 1 root root    0 janv. 14 08:55 subsystem ->
> ../../../../../../../../class/net
> -rw-r--r-- 1 root root 4096 janv. 14 08:55 tx_queue_len
> -r--r--r-- 1 root root 4096 janv. 14 08:55 type
> -rw-r--r-- 1 root root 4096 janv. 14 08:55 uevent
> -rw-r--r-- 1 root root 4096 janv. 14 08:55 umcast
> 
> as I am doing some benchs and wanted to size up MTU with connected mode,
> 
> * is there another way to use connected mode ?
> * is it related to debian packaging ?
> 
> Regards.
> 
> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
