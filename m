From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ewg] [PATCH] ipoib: Fix lockup of the tx queue
Date: Thu, 11 Mar 2010 14:04:08 -0800
Message-ID: <1268345048.2255.51.camel@chromite.mv.qlogic.com>
References: <20100303122752.GA29784@mtldesk030.lab.mtl.com>
	 <adaiq92czdt.fsf@roland-alpha.cisco.com>
	 <1268343670.2255.44.camel@chromite.mv.qlogic.com>
	 <1268343937.2255.46.camel@chromite.mv.qlogic.com>
	 <ada3a06cyqw.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada3a06cyqw.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-03-11 at 13:52 -0800, Roland Dreier wrote:
> > Sorry, I was referring to my patch not Eli's.
> 
> Heh, I never would have said anything about your patch was "obvious".
> I skimmed yours once but I do want to read it more carefully.
> 
> Did you ever say what test case you are using to provoke the problem you're fixing?

I think I did but it is just UDP stress tests in general.
Throwing in some link failures and switching between connected
and datagram modes helps too. netperf, qperf, etc. should work.
Anything which causes the connected mode QP to fail should
exercise the fix too.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
