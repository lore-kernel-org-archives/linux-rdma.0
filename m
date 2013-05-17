From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: MLX4 Cq Question
Date: Fri, 17 May 2013 14:25:44 -0500
Message-ID: <51968438.7070907@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

I'm looking at the Linux MLX4 net driver and found something that confuses 
me mightily. In particular in the file net/ethernet/mellanox/mlx4/cq.c, 
the mlx4_ib_completion function does not take any kind of lock when 
looking up the SW CQ in the radix tree, however, the mlx4_cq_event 
function does. In addition if I go look at the code paths where cq are 
removed from this tree, they are protected by spin_lock_irq. So I am 
baffled at this point as to what the locking strategy is and how this is 
supposed to work. I'm sure I'm missing something and would greatly 
appreciate it if someone would explain this.

Thanks,
Tom

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
