From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Questions about inline-receive in Mellanox cards
Date: Thu, 26 Mar 2015 12:26:58 -0400
Message-ID: <CADPSxAgQviJLxfLRZ-oXSDQu_AE9z-cWpcyUO9M=WtXqhMrb6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi everyone.

I have been trying to get inline-receive functionality to work on
Connect-IB cards. However, it seems like libmlx5 (from Mellanox OFED
2.4) does not support inline-receive. libmlx4 seems to support it, but
I believe libmlx4 is not compatible with Connect-IB cards. Further,
the Mellanox OFED user manual says that Connect-IB cards provide
inline-receive - which makes it sound like ConnectX-3 cards do not,
but then libmlx4 supports it... Does this mean that ConnectX-3 cards
also provide inline-receive?

Can someone please help me with this confusion? Also, is
inline-receive supported with UD transport?

Thanks!
Anuj Kalia
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
