From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Thu, 18 Jul 2013 02:32:05 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F727D11@xmb-rcd-x01.cisco.com>
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
 <1828884A29C6694DAF28B7E6B8A82373805B941D@ORSMSX109.amr.corp.intel.com>
 <51E71023.2060006@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51E71023.2060006-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Content-ID: <78DA122715C1D1409281A2DC2CA1D818-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jul 17, 2013, at 5:44 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:

> The iwarp drivers just report the nearest mtu enum.  Apps don't need it for iwarp like they do for ib.


For RC, it doesn't matter much.  So the fact that RoCE and iWARP lie about their MTU isn't a huge deal.  It's wrong, but it doesn't matter much.

We need it for UD for our upcoming device, however, because the MTU is the only way to get the max message size.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
