From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] pkey fix for ipoib - resubmission
Date: Fri, 18 Jun 2010 11:22:16 -0600
Message-ID: <20100618172216.GK4630@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org> <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C6D@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C6D-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 18, 2010 at 12:09:25PM -0500, Mike Heinz wrote:

> 1. Suppress activation of interface and join multicast group queries
> (it will fail anyway) until hca port is initialized. When port
> becomes active - update pkey value and move on.

> 2. Update broadcast mgid based on actual pkey, then issue join
> broadcast group request.

What happens if the SM reprograms the pkey table later?

I'm not sure this is the right approach.. See the recent dicussion
about using pkey indexes at all.

Each ipoib interface is assigned a pkey, by number, not index. If the
SM has not supplied that pkey to the port then the ipoib should not
come up. If the SM adds it later then it should come up, if it the SM
removes it later then it should go down.

The default ipoib interface uses the default pkey. If your network
need ipoib to use a different pkey then you have to change the pkey
number assignment when the ipoib interface is created, not magically
attempt to autoconfigure.

I believe you cannot safely change the broadcast GID once the ipoib
interface has started.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
