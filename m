From: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx4 kernel parameters
Date: Wed, 3 Feb 2010 11:02:07 +0100
Message-ID: <6978b4af1002030202h431384c4ub6de0313e51c4500@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi list,

on trying to change the mlx4_core parameters log_num_mtt and
log_num_mpt to 21 and 18 respectively, I see the following message:

mlx4_core 0000:07:00.0: Failed to initialize memory region table, aborting.

The objective is to be able to memory-pin large portion of a machine
with lots of RAM, otherwise we are limited to about 16GB.
Does anyone has an hint or thoughts on what might be the problem?

Thanks in advance,
Rui
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
