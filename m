From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Problems trying to bridge/route RoCE
Date: Thu, 3 Nov 2016 11:02:10 -0600
Message-ID: <CAANLjFqXH+BbsGmH5=DQd-Btsd8kCsSWTNDKCAc89tuigCdbeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm trying to do some testing of RoCE v2 and so I put a LInux box
between two RoCE  machines. I think the ConnectX-4 Lx card in the
bridge/router is intercepting the RoCE traffic and so it is not being
bridged/routed. I don't see any traffic using tcpdump which seems to
confirm this. I thought I could change the UDP port that the card is
looking for RoCE traffic to something not in use [0], but rr_proto is
not a valid parameter for the inbox mlx5_core module on 4.8.5. I can
ping across the bridge/router so I know that it is setup correctly,
just RDMA is not working.

Any ideas on how to pass RoCE traffic like normal traffic? The reason
we are using a Linux box is that we can use netem to understand how
RoCE behaves in different situations.

[0] https://community.mellanox.com/docs/DOC-1444

Thank you
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
