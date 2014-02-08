From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 15/17] RDMA/ocrdma: Support for Skyhawk
 statistics
Date: Sat, 8 Feb 2014 04:26:37 +0000
Message-ID: <424c56ee-b168-48e2-a298-f30a326ee8d0@CMEXHTCAS1.ad.emulex.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
	<91cc4eb6-5895-486d-b6b9-8a97b79dfc71@CMEXHTCAS2.ad.emulex.com>
	<CAJZOPZK-w98t0=K4AUceKPCbwjd75BBjG325YgbQ-iV-ETosPg@mail.gmail.com>
 <CAJZOPZ+ajdDtehBJnwUGA5mgMM2aDn1JsY=0Pas3Se-WfZYs4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+ajdDtehBJnwUGA5mgMM2aDn1JsY=0Pas3Se-WfZYs4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or,

We are having some 200 Odds vendor specific stats to be displayed. With sysfs infrastructure for IB devices we found that each stat will correspond to one file in sysfs tree therefore it will constitute a large number of files in ocrdma tree per port, situation will worsen if SRIOV and Multichannel comes into picture, On the other hand, with debugfs it is possible to have one file displaying multiple stats thus, drastically reducing the number of sysfs file entries.

We had a discussion with Roland on this, and he gave us a go-ahead on this as well.
However, if you still think we should honor IB-diag infra, we are open to populate IB-compliant stats into that framework as well along with debugfs entries.

-Regards
 Devesh 

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
Sent: Friday, February 07, 2014 2:37 AM
To: Devesh Sharma
Cc: linux-rdma; Roland Dreier; Selvin Xavier
Subject: Re: [PATCH for-next 15/17] RDMA/ocrdma: Support for Skyhawk statistics

 On Tue, Feb 4, 2014 Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> Issue mailbox command 
> to get the statistics counters from the skyhawk hardware

Reading from the HW the RC transport stats/errors is OK, but there's no justification to display them using debugfs, since the IB core has the infrastructure for you to plugin and get that to user space through the existing sysfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
