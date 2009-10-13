From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] rdma/cm: support option to allow manually setting
 IB path
Date: Tue, 13 Oct 2009 15:06:08 +0200
Message-ID: <4AD47B40.8070800@voltaire.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A08104C1CF70400F8BEF492AD49C8491-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> Before spending any more time on this patch series, is there any disagreement to
> accepting this patch (as is or slightly modified) upstream?
Hi Sean,

This patch just sets a route to the kernel and have the kernel issue a 
route resolved event in return, sounds good to me, I don't see any 
problem with merging it upstream.

However, we still have a discussion to continue on the slightly bigger 
picture which is related to how address resolution is "set" to the 
kernel, what port spaces would be supported, etc, and this discussion is 
somehow gets closer to the ACM design... lets continue with that on the 
"rdma/cm: allow user to specify IP to DGID mapping" thread

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
