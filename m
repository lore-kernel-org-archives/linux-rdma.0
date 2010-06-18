From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] [PATCH] pkey fix for ipoib - resubmission
Date: Fri, 18 Jun 2010 15:46:01 -0600
Message-ID: <20100618214601.GN4630@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org> <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C6D@MNEXMB1.qlogic.org> <20100618172216.GK4630@obsidianresearch.com> <5AEC2602AE03EB46BFC16C6B9B200DA816B75308EF@MNEXMB2.qlogic.org> <20100618174650.GL4630@obsidianresearch.com> <5AEC2602AE03EB46BFC16C6B9B200DA816B75308F7@MNEXMB2.qlogic.org> <20100618181921.GM4630@obsidianresearch.com> <5AEC2602AE03EB46BFC16C6B9B200DA816B7530901@MNEXMB2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5AEC2602AE03EB46BFC16C6B9B200DA816B7530901-e4KNYiSEog6Xx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 18, 2010 at 01:38:13PM -0500, Todd Rimmer wrote:
> Jason,
> 
> > Fixing the maddr table, and dealing with race issues with ongoing
> > joins my not be straightforward, but, IMHO, necessary for this patch
> > to be acceptable.

> So you are pointing out an existing bug, which is no worse with this
> patch than without it.  Namely that pkey changes with IPv6 may have
> issues.  IPv4 pkey changes should be ok.

No.. It is my understanding, that today, the pkey of an IPOIB
interface can never change once it is established.

This patch changes that invariant without actually addressing all
the complexity of making it work.

> In at least the HPC world, PKey changes are extremely rare, however
> having server's reliably boot is important.

Various IPv6 multicast joins occur as soon as the interface is up'd,
using the pkey in-place at that time. Changing the pkey while the
interface is down might work OK, but changing it while it is up'd will
break all multicast joins that were started before, ie IPv6.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
