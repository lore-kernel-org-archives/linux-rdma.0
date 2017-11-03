From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: =?UTF-8?B?44CQYXNrIGZvciBoZWxw44CR?=
Date: Fri, 3 Nov 2017 17:14:05 +0800
Message-ID: <757dcf37-4fb3-c6e9-c915-de10b4e2326f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, everyone
 I met a problem when debug the CM. the kernel version is 4.14.0-rc5

I am sure that the CM is ok on kernel 4.12

Have you met the same problem?


unhandled level 2 translation fault (11) at 0x00000000, esr 0x92000006, in librdmacm.so.1.1.11
[ffff9a6e8000+11000]
[  371.181100] CPU: 0 PID: 1295 Comm: pv660_roce_test Not tainted 4.14.0-rc5-g25886d7-dirty #34
[  371.200931] task: ffff800007f09c00 task.stack: ffff000009ae8000
[  371.212790] PC is at 0xffff9a6ef4e4
[  371.224472] LR is at 0xffff9a6ef4d4
[  371.232445] pc : [<0000ffff9a6ef4e4>] lr : [<0000ffff9a6ef4d4>] pstate: 40000000
[  371.248317] sp : 0000ffffd193b3c0
[  371.256451] x29: 0000ffffd193b3c0 x28: 0000000000407d58
[  371.268457] x27: 0000ffff9a6f8628 x26: 0000ffffd193b710
[  371.280381] x25: 000000001b652ff0 x24: 0000ffff9a6f88b0
[  371.292672] x23: 0000ffff9a7092f8 x22: 0000000000000010
[  371.308683] x21: 0000ffffd193b558 x20: 0000ffffd193b420
[  371.320611] x19: 000000001b6552d0 x18: 0000ffff9a53ecd8
[  371.332527] x17: 0000ffff9a5f00c0 x16: 0000ffff9a708de0
[  371.344443] x15: 0000ffff9a53de08 x14: 000000000000004c
[  371.360383] x13: 000000000000004c x12: 0000000000000018
[  371.372664] x11: 0101010101010101 x10: 0000000000000003
[  371.384522] x9 : 0000000000000004 x8 : 8020080280200802
[  371.396388] x7 : 6401a8c060ea0002 x6 : 000000001b653100
[  371.408650] x5 : 0000000000000110 x4 : 0000000000000000
[  371.420493] x3 : 0000000000000010 x2 : 0000000000000000
[  371.436434] x1 : 0000000000000000 x0 : 000000001b653050

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
