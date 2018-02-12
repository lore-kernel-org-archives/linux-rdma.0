From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH v2] net: make getname() functions return length rather
 than use int* parameter
Date: Mon, 12 Feb 2018 14:36:48 -0500 (EST)
Message-ID: <20180212.143648.1353355347147054805.davem@davemloft.net>
References: <20180212190020.21536-1-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180212190020.21536-1-dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-decnet-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-x25-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Mon, 12 Feb 2018 20:00:20 +0100

> Changes since v1:
> Added changes in these files:
>     drivers/infiniband/hw/usnic/usnic_transport.c
>     drivers/staging/lustre/lnet/lnet/lib-socket.c
>     drivers/target/iscsi/iscsi_target_login.c
>     drivers/vhost/net.c
>     fs/dlm/lowcomms.c
>     fs/ocfs2/cluster/tcp.c
>     security/tomoyo/network.c
> 
> 
> Before:
> All these functions either return a negative error indicator,
> or store length of sockaddr into "int *socklen" parameter
> and return zero on success.
> 
> "int *socklen" parameter is awkward. For example, if caller does not
> care, it still needs to provide on-stack storage for the value
> it does not need.
> 
> None of the many FOO_getname() functions of various protocols
> ever used old value of *socklen. They always just overwrite it.
> 
> This change drops this parameter, and makes all these functions, on success,
> return length of sockaddr. It's always >= 0 and can be differentiated
> from an error.
> 
> Tests in callers are changed from "if (err)" to "if (err < 0)", where needed.
> 
> rpc_sockname() lost "int buflen" parameter, since its only use was
> to be passed to kernel_getsockname() as &buflen and subsequently
> not used in any way.
> 
> Userspace API is not changed.
> 
>     text    data     bss      dec     hex filename
> 30108430 2633624  873672 33615726 200ef6e vmlinux.before.o
> 30108109 2633612  873672 33615393 200ee21 vmlinux.o
> 
> Signed-off-by: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to net-next, thanks Denys.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
