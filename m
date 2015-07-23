From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Thu, 23 Jul 2015 00:43:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A9001297@ORSMSX109.amr.corp.intel.com>
References: <559CD174.4040901@dev.mellanox.co.il>
 <20150708081320.GB24203@infradead.org> <559CF5E8.6080000@dev.mellanox.co.il>
 <20150708102035.GA28421@infradead.org> <559D0498.9050809@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373A8FFD4C0@ORSMSX109.amr.corp.intel.com>
 <559E34F8.4080507@dev.mellanox.co.il>
 <2189DB0A-DD00-4818-AC17-020FCE42D39B@oracle.com>
 <20150710193409.GA9815@infradead.org> <55A21BF4.7090601@dev.mellanox.co.il>
 <20150713165007.GD23832@obsidianresearch.com>
 <55A4C2FA.9060707@dev.mellanox.co.il> <55A4FF93.4090406@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A4FF93.4090406-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > This just emphasizes why we need to converge to a single method.
> 
> In my opinion, we already have it.
> 
> For local registrations, ib_reg_phys_mr()/ib_get_dma_mr(). These are not
> quite equivalent, btw.

Personally, I would work to eliminate local registration as part of the API.

> For remote registrations, ib_post_send(FRMR).

I slightly agree here.  IMO, the rkey should be obtained by associating the memory buffer with the QP, but not explicitly as a 'send' operation.

If queuing is a concern, we could expose max_active_registrations/max_total_registrations QP attributes.

I would hide the protection domain concept entirely.  If needed, a provider can allocate one PD per QP, with memory registration going to the PD.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
