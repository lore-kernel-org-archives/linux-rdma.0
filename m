From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/5] IB/srp patches for kernel v4.10
Date: Mon, 21 Nov 2016 13:56:14 -0800
Message-ID: <ba32b251-135f-c57d-44cc-658ae35a49ca@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

The patches in this series are what I came up with while testing the 
v4.9-rc5 IB/srp driver. Please consider these patches for inclusion in 
kernel v4.10. The individual patches in this series are:

0001-IB-srp-Fix-CONFIG_DYNAMIC_DEBUG-n-build.patch
0002-IB-srp-Introduce-a-local-variable-in-srp_add_one.patch
0003-IB-srp-Make-login-failures-easier-to-debug.patch
0004-IB-srp-Make-mapping-failures-easier-to-debug.patch
0005-IB-srp-Make-writing-into-the-add_target-sysfs-attrib.patch

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
