From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 0/4] Sending kernel pathrecord query to user cache
 server
Date: Wed, 10 Jun 2015 15:49:23 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CABCCC5@CRSMSX101.amr.corp.intel.com>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com>
 <55783D84.6040709@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABCC2E@CRSMSX101.amr.corp.intel.com>
 <55784C35.2020401@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABCC80@CRSMSX101.amr.corp.intel.com>
 <5578558B.1070503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5578558B.1070503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >>>>> A SA cache is undeniably critical for fabric scalability and performance.
> >>>>> In user space, the ibacm application provides a good example of
> >>>>> pathrecord cache for address and route resolution. With the recent
> >>>>> implementation of the provider architecture, ibacm offers more
> >>>> extensibility as a SA cache.
> >>>>> In kernel, ipoib implements its own small cache for pathrecords,
> >>>>> which is however not available for general use. Furthermore, the
> >>>>> implementation of a SA cache in user space offers better
> >>>>> flexibility, larger capacity, and more robustness for the system.
> >>>>>
> >>>>> In this patch series, a mechanism is implemented to allow ib_sa to
> >>>>> send pathrecord query to a user application (eg ibacm) through netlink.
> >>>>
> >>>> While this appears to address the current upstream use model for
> >>>> ACM with it's multicast overlay backend where PRs are static, it
> >>>> does not appear to address PR changes.
> >>>> Should aging/revalidation of PRs be supported ? If so, would this
> >>>> make PRs similar at "high" level to IP neighbor cache in kernel ?
> >>>
> >>> Even for the default provider acmp, PRs will time out and the length
> >>> of
> >> timeout is configurable. For other providers (eg ibssa), the PR
> >> change could be managed correctly and promptly, and this capability
> >> is beyond ibacm core itself.
> >>
> >> That deals with the update of PR in user space (ACM). Doesn't kernel
> >> need some way of knowing PR was updated ?
> >
> > Maybe. If a kernel client is interested in PR changes, it can register
> > for notification
> 
> Wouldn't the notification mechanism be via netlink ? What would the
> granularity be for the registrations and notifications ?

Not necessarily. AFAIK, SA notification is not currently supported in kernel. One could register notification through netlink, as long as the user space application (eg: ibacm) supports it. But this would be a new feature, as Sean pointed out in previous e-mail.

Kaike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
