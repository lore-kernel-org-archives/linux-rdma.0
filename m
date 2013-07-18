From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Thu, 18 Jul 2013 10:50:03 -0600
Message-ID: <20130718165003.GB9237@obsidianresearch.com>
References: <20130708172621.GA3852@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F70BF83@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373805AAB74@ORSMSX109.amr.corp.intel.com>
 <20130716144747.GA7304@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F7211E6@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373805AECC0@ORSMSX109.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F725B8C@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373805B941D@ORSMSX109.amr.corp.intel.com>
 <51E71023.2060006@opengridcomputing.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F727D11@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F727D11-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 18, 2013 at 02:32:05AM +0000, Jeff Squyres (jsquyres) wrote:
> On Jul 17, 2013, at 5:44 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> 
> > The iwarp drivers just report the nearest mtu enum.  Apps don't need it for iwarp like they do for ib.

> For RC, it doesn't matter much.  So the fact that RoCE and iWARP lie
> about their MTU isn't a huge deal.  It's wrong, but it doesn't
> matter much.
> 
> We need it for UD for our upcoming device, however, because the MTU
> is the only way to get the max message size.

.. and UD is the least abstracted transport, so existing apps won't
support Jeff's new NIC anyhow, MTU is the least of their problems.

Existing apps with existing transports see the same old values.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
