From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: cq error timeout issue
Date: Mon, 31 Oct 2011 06:51:11 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8B236@ORSMSX101.amr.corp.intel.com>
References: <CAFAcbYPXqcOc79fcWHK7iHkfEX0ecmg4CBSUgUk=C=xiScSRRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFAcbYPXqcOc79fcWHK7iHkfEX0ecmg4CBSUgUk=C=xiScSRRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlad Weinbaum <vlad.weinbaum-adSD+vzF2QdBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I try to use ibv_poll_cq to identify connectivity problems. The
> scenario is following, based on modified rping example:
> 
> 1) preliminary steps done and rdma connection established between
> Client and Server, retry_count in rdma_conn_param is set 1;
> 2) Server lost its link (corresponding switch port disabled), Client
> is still connected to the switch;
> 3) Client calls ibv_post_send
> 4) Client polls cq with ibv_poll_cq and gets expected
> IBV_WC_RETRY_EXC_ERR after about 1 second.
> 
> Can this timeout be decreased? If it is impossible, can you suggest
> something else?

I don't believe easily.  The timeout is based on the path record returned by the SM, which is really what an app should use.  If you can adjust the timeout at the SM, that would be best.

If you can use a newer kernel, another alternative is to use rdma_set_option to provide your own path record as input in place of calling rdma_resolve_route.

Btw, with a small timeout and few retries, if you're not using QoS, you may want to enable that to prevent false timeouts.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
