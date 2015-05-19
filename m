From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/1] ibacm: Add support for pathrecord query through
 netlink
Date: Tue, 19 May 2015 11:17:14 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAB23B5@CRSMSX101.amr.corp.intel.com>
References: <1431975674-23602-1-git-send-email-kaike.wan@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDCA60@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FDCA60-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> > +static inline int acm_nl_supported_sa_mad(struct ib_sa_mad *sa_mad) {
> > +	return (sa_mad->rmpp_version == 0 &&
> 
> I think you want something like:
> 
> !(rmpp_flags & RMPP_ACTIVE)
> 
> Instead of checking for version = 0.


Will be changed to:

!(sa_mad->rmpp_flags & UMAD_RMPP_FLAG_ACTIVE)

in next version
> 
> > +		sa_mad->method == UMAD_METHOD_GET &&
> > +		sa_mad->attr_id == htons(UMAD_SA_ATTR_PATH_REC)); }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
