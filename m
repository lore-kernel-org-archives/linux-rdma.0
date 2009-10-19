From: Brian Cain <brian.cain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx4_en - Inconsistent TCP throughput
Date: Sun, 18 Oct 2009 22:48:27 -0500
Message-ID: <17e3a31c0910182048y79df833ek100ef8955eb30d85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm trying to aggregate 10GbE ports for a realtime data acquisition
application.  I need to be able to get consistently high throughput to
satisfy my application's demands.

I have a dual-X58 host with a MT26448 on each IOH.  I can acquire >
39Gb/s in aggregate across four TCP streams (one per port).  This
throughput remains consistent across many consecutive netperf
TCP_STREAM trials, but trying the same experiment hours or days later,
I'll find that the performance suffers (< 30Gb/s).

irq_balancer is disabled and all of the IRQs' affinity masks for one
card are set to the same core, the other card's IRQs are set to a core
on the other socket.  I'm using 9000 byte MTUs.  The majority of the
system settings are at their defaults.  I'm keeping the task affinity
among the netserver processes static as well.  I don't see any error
messages from mlx* in dmesg.

Can anyone suggest some parameters that might be able to help me find
consistently high performance?

~~~~
$  sudo ethtool -i eth16
driver: mlx4_en (MT_0BD0110010)
version: 1.4.2 (Sep 24 2009)
firmware-version: 2.6.0
bus-info: 0000:28:00.0

$  lsb_release -a
LSB Version:
core-2.0-noarch:core-3.2-noarch:core-2.0-x86_64:core-3.2-x86_64:desktop-3.2-amd64:desktop-3.2-noarch:graphics-2.0-amd64:graphics-2.0-noarch:graphics-3.2-amd64:graphics-3.2-noarch
Distributor ID: SUSE LINUX
Description:    openSUSE 11.1 (x86_64)
Release:        11.1
Codename:       n/a

$  cat /proc/version
Linux version 2.6.29.6-9-debug (root@z800-revo-0) (gcc version 4.3.2
[gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Tue Sep 15
11:02:15 CDT 2009

$ sudo grep . /sys/module/mlx4_en/parameters/*
/sys/module/mlx4_en/parameters/inline_thold:104
/sys/module/mlx4_en/parameters/ip_reasm:1
/sys/module/mlx4_en/parameters/num_lro:32
/sys/module/mlx4_en/parameters/pfcrx:0
/sys/module/mlx4_en/parameters/pfctx:0
/sys/module/mlx4_en/parameters/rss_mask:5
/sys/module/mlx4_en/parameters/rss_xor:0

$ sudo grep . /sys/module/mlx4_core/parameters/*
/sys/module/mlx4_core/parameters/block_loopback:1
/sys/module/mlx4_core/parameters/debug_level:0
/sys/module/mlx4_core/parameters/enable_qos:N
/sys/module/mlx4_core/parameters/internal_err_reset:1
/sys/module/mlx4_core/parameters/log_mtts_per_seg:3
/sys/module/mlx4_core/parameters/log_num_cq:0
/sys/module/mlx4_core/parameters/log_num_mac:2
/sys/module/mlx4_core/parameters/log_num_mcg:0
/sys/module/mlx4_core/parameters/log_num_mpt:0
/sys/module/mlx4_core/parameters/log_num_mtt:0
/sys/module/mlx4_core/parameters/log_num_qp:0
/sys/module/mlx4_core/parameters/log_num_srq:0
/sys/module/mlx4_core/parameters/log_num_vlan:0
/sys/module/mlx4_core/parameters/log_rdmarc_per_qp:0
/sys/module/mlx4_core/parameters/msi_x:1
/sys/module/mlx4_core/parameters/set_4k_mtu:0
/sys/module/mlx4_core/parameters/use_prio:N

-- 
-Brian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
