From: Vlad Weinbaum <vlad.weinbaum-adSD+vzF2QdBDgjK7y7TUQ@public.gmane.org>
Subject: cq error timeout issue
Date: Sun, 30 Oct 2011 14:51:09 +0200
Message-ID: <CAFAcbYPXqcOc79fcWHK7iHkfEX0ecmg4CBSUgUk=C=xiScSRRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I try to use ibv_poll_cq to identify connectivity problems. The
scenario is following, based on modified rping example:

1) preliminary steps done and rdma connection established between
Client and Server, retry_count in rdma_conn_param is set 1;
2) Server lost its link (corresponding switch port disabled), Client
is still connected to the switch;
3) Client calls ibv_post_send
4) Client polls cq with ibv_poll_cq and gets expected
IBV_WC_RETRY_EXC_ERR after about 1 second.

Can this timeout be decreased? If it is impossible, can you suggest
something else?

Used software is Ofed-1.5.3.1, IB device is Mellanox MT26428.

Thanks,
Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
