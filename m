From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] staging/rdma: Kconfig change STAGING_RDMA to be
 tristate.
Date: Fri, 25 Sep 2015 14:02:25 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC257D4545@fmsmsx120.amr.corp.intel.com>
References: <1443120225-22163-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443120225-22163-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH] staging/rdma: Kconfig change STAGING_RDMA to be
> tristate.
> 
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> STAGING_RDMA was failing to build when INFINIBAND was set to 'm' and
> STAGING_RDMA was set to 'y'.
> 
> Making this a tristate properly inherits the 'm' from the INFINIBAND setting.
> 

This patch has been shown to fix the issue noted in http://marc.info/?l=linux-rdma&m=144311398317945&w=2.

Tested-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
