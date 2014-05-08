From: Jesus Camacho Villanueva <jecavil-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: missing port number(s) in trap 128?
Date: Thu, 8 May 2014 13:51:01 +0200
Message-ID: <CAA8OkbuY4F9N1RkNQFgDCYveWkzDVzcRmqK4F=CBdSC+Hv5APg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Everyone,

When OpenSM receives a trap 128 indicating a "Link state of at least
one port of switch at <LIDADDR> has changed", it seems there is not
any information about the port number(s) of the affected link(s).

Do you know if there is any chance to retrieve this information from
this trap or through other incoming MAD(s)?

Any ideas or suggestions would be greatly appreciated.

Kind regards,
Jesus Camacho
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
