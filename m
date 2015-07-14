From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 08:24:51 -0400
Message-ID: <55A4FF93.4090406@talpey.com>
References: <559CD174.4040901@dev.mellanox.co.il> <20150708081320.GB24203@infradead.org> <559CF5E8.6080000@dev.mellanox.co.il> <20150708102035.GA28421@infradead.org> <559D0498.9050809@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FFD4C0@ORSMSX109.amr.corp.intel.com> <559E34F8.4080507@dev.mellanox.co.il> <2189DB0A-DD00-4818-AC17-020FCE42D39B@oracle.com> <20150710193409.GA9815@infradead.org> <55A21BF4.7090601@dev.mellanox.co.il> <20150713165007.GD23832@obsidianresearch.com> <55A4C2FA.9060707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A4C2FA.9060707-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/14/2015 4:06 AM, Sagi Grimberg wrote:
> All protocols cares about transferring data and sending messages, so
> it's not a good enough reason for a poor registration method choice.
> This just emphasizes why we need to converge to a single method.

In my opinion, we already have it.

For local registrations, ib_reg_phys_mr()/ib_get_dma_mr(). These are not
quite equivalent, btw.

For remote registrations, ib_post_send(FRMR).

Unfortunately, there exist ancient adapters in-tree that don't support
FRMR, and some ULPs have attempted to work on them. That's why the
situation is confusing.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
