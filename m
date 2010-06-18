From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] [PATCH] pkey fix for ipoib - resubmission
Date: Fri, 18 Jun 2010 11:46:50 -0600
Message-ID: <20100618174650.GL4630@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org> <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C6D@MNEXMB1.qlogic.org> <20100618172216.GK4630@obsidianresearch.com> <5AEC2602AE03EB46BFC16C6B9B200DA816B75308EF@MNEXMB2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5AEC2602AE03EB46BFC16C6B9B200DA816B75308EF-e4KNYiSEog6Xx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 18, 2010 at 12:32:52PM -0500, Todd Rimmer wrote:

> For IB, the centralized tool is the SM and a "VLAN" is an IB
> Partition.  The present capability of using the 1st PKey table entry
> is a nice simple and powerful way to mimic the ease of use of
> Ethernet VLANs.  Only when a user wants IPoIB to run on two
> different partitions (which is rare) is a server specific
> configuration needed.

I agree that automatic configuration is desirable, but this isn't how
the Linux ipoib implementation is designed.

You cannot easily change the broadcast GID after starting. It gets
into places, and this patch does not address that. I suspect that
un-doing all the places the GID gets into is fairly hard..

Certainly, changing the pkey once the interface has been running for
awhile is involved, and 'auto configuration' that works once at boot
is, IMHO, evil.

So.. to go down this path, I think the first patch should be: 'here
is a patch that lets us change the pkey on a running interface, and
here is a detailed discussion of why it is correct and race
free'.

With the current code the simplest approach to this would be to
destroy the entire interface and make a new one with the pkey you
want. Since doing this requires preserving a lot of net state this is
best done from user space using the existing APIs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
