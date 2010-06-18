From: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [ewg] [PATCH] pkey fix for ipoib - resubmission
Date: Fri, 18 Jun 2010 13:38:13 -0500
Message-ID: <5AEC2602AE03EB46BFC16C6B9B200DA816B7530901@MNEXMB2.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C6D@MNEXMB1.qlogic.org>
 <20100618172216.GK4630@obsidianresearch.com>
 <5AEC2602AE03EB46BFC16C6B9B200DA816B75308EF@MNEXMB2.qlogic.org>
 <20100618174650.GL4630@obsidianresearch.com>
 <5AEC2602AE03EB46BFC16C6B9B200DA816B75308F7@MNEXMB2.qlogic.org>
 <20100618181921.GM4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100618181921.GM4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason,

> Fixing the maddr table, and dealing with race issues with ongoing
> joins my not be straightforward, but, IMHO, necessary for this patch
> to be acceptable.
> 

So you are pointing out an existing bug, which is no worse with this patch than without it.  Namely that pkey changes with IPv6 may have issues.  IPv4 pkey changes should be ok.

In any case, this patch still successfully addresses the most important requirement of having a rebooted server come up with the correct MGID.

In at least the HPC world, PKey changes are extremely rare, however having server's reliably boot is important.

> ipoib bonding had much the same problem with invalid maddrs, and a
> patch was put in that flushed the maddr table in certain bond
> scenarios. Perhaps something like that is a straightforward solution
> here as well?
Perhaps that could be a second patch which would build on top of this initial fix for the most important requirement.  It would seem that using the PKEY change and/or re-registration HCA events to trigger a maddr flush in IPoIB would be straightforward.  If that approach worked well for bonding, it should work equally well in these cases.

Todd Rimmer
Chief Architect 
QLogic Network Systems Group
Voice: 610-233-4852     Fax: 610-233-4777
Todd.Rimmer-8votvDbAKxjQT0dZR+AlfA@public.gmane.org  www.QLogic.com
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
