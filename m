From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [ewg] [PATCH] pkey fix for ipoib - resubmission
Date: Wed, 23 Jun 2010 09:58:39 +0300
Message-ID: <4C21B09F.3000704@voltaire.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org>	<4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C6D@MNEXMB1.qlogic.org>	<20100618172216.GK4630@obsidianresearch.com>	<5AEC2602AE03EB46BFC16C6B9B200DA816B75308EF@MNEXMB2.qlogic.org>	<20100618174650.GL4630@obsidianresearch.com>	<5AEC2602AE03EB46BFC16C6B9B200DA816B75308F7@MNEXMB2.qlogic.org>	<20100618181921.GM4630@obsidianresearch.com> <4C20537D.5080903@Voltaire.com> <20100622144607.GA7767@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100622144607.GA7767-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> OFED works on kernels that have compiled-in inline'd multicast map functions that do not include the pkey copy, while mainline's multicast map functions do. So to work around this there is a bit of code in OFED to overwrite the pkey in the multicast hw address. This means on OFED with those kernels ip maddr returns the wrong hw address sometimes..
okay, got it. Anyway, with this not being the essence of the patch nor 
the discussion here, I would wait to hear what  Todd and Mike think 
about your suggestion to apply the approach taken for the bonding 
problem and solution.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
