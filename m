From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ewg] [PATCH] ipoib: Fix lockup of the tx queue
Date: Thu, 11 Mar 2010 13:45:37 -0800
Message-ID: <1268343937.2255.46.camel@chromite.mv.qlogic.com>
References: <20100303122752.GA29784@mtldesk030.lab.mtl.com>
	 <adaiq92czdt.fsf@roland-alpha.cisco.com>
	 <1268343670.2255.44.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268343670.2255.44.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry, I was referring to my patch not Eli's.

On Thu, 2010-03-11 at 13:41 -0800, Ralph Campbell wrote:
> On Thu, 2010-03-11 at 13:38 -0800, Roland Dreier wrote:
> > good debugging, applied thanks.
> > 
> > I do worry (as Moni mentioned) that this doesn't explain why you would
> > get send failures in this case, but the patch itself is well-explained
> > and looks "obviously correct" so I think we should apply it.
> 
> Well, after more testing it seems there may still be a problem.
> I haven't isolated it yet though. I could definitely use help
> reviewing the code changes.
> 
> _______________________________________________
> ewg mailing list
> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
