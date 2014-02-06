From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 15/17] RDMA/ocrdma: Support for Skyhawk statistics
Date: Thu, 6 Feb 2014 23:07:22 +0200
Message-ID: <CAJZOPZ+ajdDtehBJnwUGA5mgMM2aDn1JsY=0Pas3Se-WfZYs4A@mail.gmail.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
	<91cc4eb6-5895-486d-b6b9-8a97b79dfc71@CMEXHTCAS2.ad.emulex.com>
	<CAJZOPZK-w98t0=K4AUceKPCbwjd75BBjG325YgbQ-iV-ETosPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZK-w98t0=K4AUceKPCbwjd75BBjG325YgbQ-iV-ETosPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 On Tue, Feb 4, 2014 Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> Issue mailbox command to get the statistics counters from the skyhawk
> hardware

Reading from the HW the RC transport stats/errors is OK, but there's no
justification to display them using debugfs, since the IB core has the
infrastructure for you to plugin and get that to user space through the
existing sysfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
