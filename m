From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] [PATCH] pkey fix for ipoib - resubmission
Date: Fri, 18 Jun 2010 12:19:21 -0600
Message-ID: <20100618181921.GM4630@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org> <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C6D@MNEXMB1.qlogic.org> <20100618172216.GK4630@obsidianresearch.com> <5AEC2602AE03EB46BFC16C6B9B200DA816B75308EF@MNEXMB2.qlogic.org> <20100618174650.GL4630@obsidianresearch.com> <5AEC2602AE03EB46BFC16C6B9B200DA816B75308F7@MNEXMB2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5AEC2602AE03EB46BFC16C6B9B200DA816B75308F7-e4KNYiSEog6Xx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 18, 2010 at 12:56:56PM -0500, Todd Rimmer wrote:
> Jason wrote:
> > You cannot easily change the broadcast GID after starting. It gets
> > into places, and this patch does not address that. I suspect that
> > un-doing all the places the GID gets into is fairly hard..
> 
> We have successfully tested this patch by bouncing the SM with a new
> partition table config and IPoIB successfully moved to the new Pkey
> and continued working.  Within IPoIB this code was the only
> remaining place which incorrectly used the stale Pkey which the
> hardware initialized to prior to the SM programming the PKey table.

Uhm, no... the pkey is copied from the broadcast GID into many other
places. For instance it is used by the kernel to construct the
hwardware address for all IP/IPv6 joins. Without fixing up the maddr
table you break all existing multicast joins, which will completely
break IPv6, and breaks corner cases for IPv4..

Be aware that mainline and OFED are different in this regard, OFED
overrides the pkey unconditionally for multicast addresses, while
mainline does not.

Fixing the maddr table, and dealing with race issues with ongoing
joins my not be straightforward, but, IMHO, necessary for this patch
to be acceptable.

ipoib bonding had much the same problem with invalid maddrs, and a
patch was put in that flushed the maddr table in certain bond
scenarios. Perhaps something like that is a straightforward solution
here as well?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
