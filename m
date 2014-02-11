From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 15/17] RDMA/ocrdma: Support for Skyhawk statistics
Date: Tue, 11 Feb 2014 09:57:21 +0200
Message-ID: <52F9D7E1.8050700@mellanox.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>	<91cc4eb6-5895-486d-b6b9-8a97b79dfc71@CMEXHTCAS2.ad.emulex.com>	<CAJZOPZK-w98t0=K4AUceKPCbwjd75BBjG325YgbQ-iV-ETosPg@mail.gmail.com> <CAJZOPZ+ajdDtehBJnwUGA5mgMM2aDn1JsY=0Pas3Se-WfZYs4A@mail.gmail.com> <424c56ee-b168-48e2-a298-f30a326ee8d0@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <424c56ee-b168-48e2-a298-f30a326ee8d0-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/02/2014 06:26, Devesh Sharma wrote:
> We are having some 200 Odds vendor specific stats to be displayed. With sysfs infrastructure for IB devices [..] We had a discussion with Roland on this, and he gave us a go-ahead on this as well.

Roland, what's wrong with  either plugging into the framework for IB 
statistics set by commit 7f624d023b5fb "RDMA/core: Add iWARP protocol 
statistics attributes in sysfs" for the IBTA defined statistics and have 
the vendor propeitary stats to be reported through the rdma netlink 
code, or having it all go through netlink (better to my taste).

Or.

> we found that each stat will correspond to one file in sysfs tree therefore it will constitute a large number of files in ocrdma tree per port, situation will worsen if SRIOV and Multichannel comes into picture, On the other hand, with debugfs it is possible to have one file displaying multiple stats thus, drastically reducing the number of sysfs file entries.
>
> We had a discussion with Roland on this, and he gave us a go-ahead on this as well.
> However, if you still think we should honor IB-diag infra, we are open to populate IB-compliant stats into that framework as well along with debugfs entries.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
