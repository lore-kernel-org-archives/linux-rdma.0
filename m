From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 9/9] Samples: Peer memory client example
Date: Tue, 7 Oct 2014 17:09:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DE6BE2@ORSMSX109.amr.corp.intel.com>
References: <1412176717-11979-1-git-send-email-yishaih@mellanox.com>
 <1412176717-11979-10-git-send-email-yishaih@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237399DE5096@ORSMSX109.amr.corp.intel.com>
 <54347E5A035A054EAE9D05927FB467F977CC9244@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54347E5A035A054EAE9D05927FB467F977CC9244-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Coffman, Jerrie L" <jerrie.l.coffman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > Adds an example of a peer memory client which implements the peer
> > > memory API as defined under include/rdma/peer_mem.h.
> > > It uses the HOST memory functionality to implement the APIs and can be
> > > a good reference for peer memory client writers.
> >
> > Is there a real user of these changes?
> 
> CCL (co-processor communication link) Direct for Intel Xeon Phi, included
> in
> OFED 3.12-1 and OFED-3.5-2-MIC, uses the peer-direct interface.

And where are the upstream patches for this?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
