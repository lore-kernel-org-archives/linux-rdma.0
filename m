From: Anton Volkov <avolkov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Subject: Possible race in mlx5_ib.ko
Date: Fri, 18 Aug 2017 18:17:15 +0300
Message-ID: <64936cc7-12b2-3a8f-b6dc-54f6f7cf7d6a@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ldv-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org, Alexey Khoroshilov <khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello.

While searching for races in the Linux kernel I've come across
"drivers/infiniband/hw/mlx5/mlx5_ib.ko" module. Here are questions that 
I came up with while analyzing results. Lines are given using the info 
from Linux v4.12.

Consider the following case:

Thread 1:              Thread 2:
size_write
->remove_keys          limit_write
     ent->cur--;          if (ent->cur < ent->limit)
     (mr.c: line 234)     (mr.c: line 335)
                             err = add_keys(... ent->limit - ent->cur);

If size_write and limit_write are able to work concurrently with the 
same ent then there is a possibility of a race between the accesses to 
ent->cur. In worst case in limit_write new keys wouldn't be added. Is it 
feasible from your point of view? If so, is it a benign race or a 
serious one?

Thank you for your time.

-- Anton Volkov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org
e-mail: avolkov-ufN2psIa012HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
