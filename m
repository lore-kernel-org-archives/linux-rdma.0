From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Possible process deadlock in RMPP flow
Date: Sun, 27 Sep 2009 10:01:25 +0200
Message-ID: <20090927080125.GB28876@mtls03>
References: <20090923150454.GA26150@mtls03> <7A32EEE20DF5432CADB60B8F8B1E0093@amr.corp.intel.com> <20090923172532.GA32223@mtls03> <4ABB13F3.1060702@Voltaire.com> <20090924073601.GA28876@mtls03> <53F5ED0C557B4667B22A27A0459B800B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53F5ED0C557B4667B22A27A0459B800B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 24, 2009 at 08:53:24AM -0700, Sean Hefty wrote:
> >Thanks Or. This one is already in OFED 1.4.2 but apparently this is a
> >different problem. Once I have information whether the patch Roland
> >posted fixed it I will update the list.
> 
> If ibnetdiscover doesn't use RMPP as Hal indicated, I don't think Roland's patch
> will help.

Right, it doesn't help. Still it appears that ibnetdiscover triggers
this problem and the lock seams to appear at ib_cancel_rmpp_recvs()
waiting for flush_workqueue() to return. Do you know which apps or
ULPs make use of RMPPs?
Any other ideas what this could be?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
