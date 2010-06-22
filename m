From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [ewg] [PATCH] pkey fix for ipoib - resubmission
Date: Tue, 22 Jun 2010 09:09:01 +0300
Message-ID: <4C20537D.5080903@Voltaire.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org>	<4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C6D@MNEXMB1.qlogic.org>	<20100618172216.GK4630@obsidianresearch.com>	<5AEC2602AE03EB46BFC16C6B9B200DA816B75308EF@MNEXMB2.qlogic.org>	<20100618174650.GL4630@obsidianresearch.com>	<5AEC2602AE03EB46BFC16C6B9B200DA816B75308F7@MNEXMB2.qlogic.org> <20100618181921.GM4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100618181921.GM4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> Be aware that mainline and OFED are different in this regard, OFED overrides 
> the pkey unconditionally for multicast addresses, while mainline doesn't
 
Can you clarify this, please?

> ipoib bonding had much the same problem with invalid maddrs, and a
> patch was put in that flushed the maddr table in certain bond scenarios. 

Yes, reading through this thread, I tend to agree with Jason that we're in the same boat (problem) that used to be for bonding/ipoib and was fixed in commit 75c78500ddad74b229cd0691496b8549490496a2  "bonding: remap multicast addresses without using dev_close() and dev_open()", so I assume a similar solution can/should be applied here as well, unless someone comes with a magic approach to eliminate the problem all together...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
