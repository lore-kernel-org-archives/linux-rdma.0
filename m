From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/rds: use IB_CQ_REPORT_MISSED_EVENTS to avoid missed CQ callbacks
Date: Tue, 30 Mar 2010 16:30:04 -0700
Message-ID: <adaeij1v14z.fsf@roland-alpha.cisco.com>
References: <1269987841.4192.228.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1269987841.4192.228.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Tue, 30 Mar 2010 15:24:01 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > OpenFabrics added a IB_CQ_REPORT_MISSED_EVENTS flag to detect this

OpenFabrics?  Funny, I thought I added that flag.

(This is not a serious objection ... I'm just being annoying.  Being
serious, I'm happy to see this used outside of IPoIB and this looks like
a good optimization)

 > This patch by itself should improve RDS performance over QLogic HCAs

Out of curiousity have you measured an improvement?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
