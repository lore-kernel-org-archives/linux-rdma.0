From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: mlx4: kernel 3.4-rc1 breaks libumad
Date: Mon, 02 Apr 2012 07:42:56 +0000
Message-ID: <4F795880.4070306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Apparently applications based on libumad can find local ports with
kernel 3.2.x but not with kernel 3.4-rc1.

# uname -r
3.4.0-rc1
# ls /sys/class/infiniband/mlx4_0/ports/1/rate
/sys/class/infiniband/mlx4_0/ports/1/rate
# cat /sys/class/infiniband/mlx4_0/ports/1/rate
cat: /sys/class/infiniband/mlx4_0/ports/1/rate: Invalid argument

This breaks libumad because this makes sys_read_string() fail and hence
also get_port().

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
