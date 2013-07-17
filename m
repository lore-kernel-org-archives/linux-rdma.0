From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Wed, 17 Jul 2013 21:41:24 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373805B941D@ORSMSX109.amr.corp.intel.com>
References: <1372768306-6786-1-git-send-email-jsquyres@cisco.com>
 <CAL1RGDVU9otyMtoit1PJR5JkVy4XvU=4xjL1rN1QB7pq0rVcxA@mail.gmail.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F6F31A6@xmb-rcd-x01.cisco.com>
 <CAL1RGDU+4CSJyF0TAfAv-YYcjA4FG+XNeg5pGCHPeW5iqhvwpA@mail.gmail.com>
 <20130708172621.GA3852@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F70BF83@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373805AAB74@ORSMSX109.amr.corp.intel.com>
 <20130716144747.GA7304@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F7211E6@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373805AECC0@ORSMSX109.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F725B8C@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F725B8C-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I hadn't looked at the kernel side yet; I was waiting for the userspace side to
> sort itself out first.

I think it makes sense to start with how user space can get the data.  Without eating up reserved fields, we're starting with 8 bit values.

> Hmm.  16 bits is probably enough for the MTU values, but still, changing kern-
> abi.h will be problematic from an ABI perspective.  Do people care about the
> kernel ABI, or is that mainly a userspace issue?

Well, we definitely care about the kernel to user ABI.

I can't imagine that we're dealing with more than a handful of actual MTU values.  Maybe the simplest thing is to extend the mtu enum to include what new values are needed, plus add a function to convert it.  (Can we call mulligan?)

I don't know how iwarp handles this.  Does it just report the wrong mtu, since it doesn't necessarily matter?  Steve - any idea here?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
