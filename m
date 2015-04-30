From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Thu, 30 Apr 2015 16:56:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC929B@ORSMSX109.amr.corp.intel.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <9f65de5e-ed5f-48d2-bff2-03ffbe4f4876@CMEXHTCAS2.ad.emulex.com>
 <CAJ3xEMhBNt-VNNds37sXnJi3nP9ZTMd6mC3s+qZWh0XsO1n_Nw@mail.gmail.com>
 <553DF294.4070507@mellanox.com>
 <CAJ3xEMjzgS_uR1VaeGzW+jcfG2oiVo4=fCctX6o4OVbKRX2n0Q@mail.gmail.com>
 <553F931F.6000302@mellanox.com> <20150428174312.GB5497@obsidianresearch.com>
 <5540F8F4.5010906@dev.mellanox.co.il>
 <20150429164847.GA12781@obsidianresearch.com> <5541E5ED.7000606@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5541E5ED.7000606-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> roce_gid_cache_client_cleanup_one ->
> >> roce_gid_cache_client_cleanup_one_work -> *work* ->
> >> roce_gid_cache_client_cleanup_work_handler ->
> >> roce_gid_cache_cleanup_one -> free_roce_gid_cache -> write_gid ->
> >> modify_gid
> >
> > Ah, this wasn't there in the earlier versions. Good.
> >
> >>> However, all the other async work launched doesn't look safe at all.
> >
> >> I think it's safe - roce_gid_cache_client_cleanup_one deactivates
> >> the cache (no new events are handled on the cache). Ongoing events
> >> are flushed in roce_gid_cache_client_cleanup_one_work
> >
> > Do you mean roce_gid_cache_client_cleanup_work_handler?
> >
> 
> Yeah, the flush_workqueue is done in
> roce_gid_cache_client_cleanup_work_handler

This entire cache seems completely over-architected.  Why is this complexity needed?  How frequently do we really expect these "GIDs" to change?

I still don't even buy that a cache is needed at all.  The RDMA CM can accept as input UDP/IP addresses.  RoCEv2 puts UDP/IP addresses on the wire.  Why should there be a conversion from an IP address to a GID to get back to the same IP address?  Why aren't IP addresses passed directly to the drivers?  Just change how the RDMA CM associates an IP address with the RDMA device.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
