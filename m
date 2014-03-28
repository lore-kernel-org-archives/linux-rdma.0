From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 16/16] ibacm: remove processing of IP's from
 ibacm_addr.cfg
Date: Fri, 28 Mar 2014 16:37:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D519C0@ORSMSX109.amr.corp.intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
 <1395985810-23822-17-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-17-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 16/16] ibacm: remove processing of IP's from ibacm_addr.cfg
> 
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Flag an error and do not process IP's which may appear in this file.

It probably makes sense to make this configurable, with the default to no longer process IP addresses in the file.  The option to enable could be read from the configuration file.  This provides an easy way for a user to re-enable this feature, in the off chance that it is in use.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
