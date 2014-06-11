From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] ibacm provider infrastructure
Date: Wed, 11 Jun 2014 17:59:57 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399310295@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A couple of months ago, I posted the start of a patch series to re-architect ibacm around supporting multiple providers.

http://www.spinics.net/lists/linux-rdma/msg19363.html

This more easily allows ibacm to support other mechanisms for resolving address and path record data, with support for ibssa (Scalable SA) as one obvious candidate.

A complete set of patches that completes the re-architecture is now available in the ibacm 'prov' branch.

http://git.openfabrics.org/?p=~shefty/ibacm.git;a=shortlog;h=refs/heads/prov

In total, there are 40-50 patches, with most of the work actually done by Kaike Wan.  Because of the size and limited audience interested in this work, I don't plan on posting these to the mail list.  But anyone interested in reviewing the patches should feel free to comment on them.  Likely the most interesting result of the work is the provider interface to ibacm, which is defined in include/infiniband/acm_prov.h:

http://git.openfabrics.org/?p=~shefty/ibacm.git;a=blob;f=include/infiniband/acm_prov.h;h=dcfdf5fce7373a7d57bcbe3fe54d6fe5d81935e2;hb=refs/heads/prov

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
