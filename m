From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Question on mlx5-ib auto load
Date: Sun, 24 Sep 2017 16:43:58 +0300
Message-ID: <daab19a4-98c8-3115-065d-2c40c5843121@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Did anyone notice that mlx5_ib does not auto load at boot time?

While mlx5_core requests mlx5_ib, mlx5_ib still does not load
at boot time (only when reloading mlx5_core).

I noticed it today, and could only get around it by adding
mlx5_ib to /etc/modules-load.d/modules.conf

Is there something I'm missing?

Cheers,
Sagi
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
