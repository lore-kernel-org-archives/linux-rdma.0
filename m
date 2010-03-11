From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] [PATCH] ipoib: Fix lockup of the tx queue
Date: Thu, 11 Mar 2010 13:52:23 -0800
Message-ID: <ada3a06cyqw.fsf@roland-alpha.cisco.com>
References: <20100303122752.GA29784@mtldesk030.lab.mtl.com>
	<adaiq92czdt.fsf@roland-alpha.cisco.com>
	<1268343670.2255.44.camel@chromite.mv.qlogic.com>
	<1268343937.2255.46.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268343937.2255.46.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 11 Mar 2010 13:45:37 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Sorry, I was referring to my patch not Eli's.

Heh, I never would have said anything about your patch was "obvious".
I skimmed yours once but I do want to read it more carefully.

Did you ever say what test case you are using to provoke the problem you're fixing?
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
