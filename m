From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Need to set if_index in ib_init_ah_from_wc() ?
Date: Sun, 29 Jan 2017 17:21:43 -0800
Message-ID: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I recently debugged an issue where an RDMA-CM / RoCE connection to a
link-local IPv6 address takes 1 second to establish.  The delay comes
when the passive side cm_req_handler() calls
cm_init_av_for_response(), which calls ib_init_ah_from_wc().

That calls into rdma_addr_find_l2_eth_by_grh() with the link-local
address, but with 0 passed in through the if_index parameter.  So
resolving the link-local routing fails (since we don't give the
network stack a device scope).  We end up in the ENODATA case in
rdma_resolve_ip(), so we queue a request to try again with a timeout
of 1000 msec.  Of course, that still fails, so we return failure.  The
CM ignores the return value, but we've delayed sending the REP for a
second.

The fix seems as simple as adding

    if_index = idev->ifindex;

to ib_init_ah_from_wc() before the call to
rdma_addr_find_l2_eth_by_grh() - this can't fail, since we return an
error if finding idev fails.

However, I'm not sure if it's quite that simple - how does this
interact with RoCEv2, or other addressing like IPv4 or non-link-local
IPv6? I'm not sure I understand what the cases where resolved_dev will
be != idev, or if passing in idev->ifindex will break this.

Do I need to add a conditional to limit when I assign if_index?

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
