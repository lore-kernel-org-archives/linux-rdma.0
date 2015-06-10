From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Wed, 10 Jun 2015 20:32:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE6A9D@ORSMSX109.amr.corp.intel.com>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com>
 <1433861837-26177-2-git-send-email-kaike.wan@intel.com>
 <55787827.7030003@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABCD80@CRSMSX101.amr.corp.intel.com>
 <55789609.4020906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55789609.4020906-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >>> +/* Local Service Reversible attribute */ struct
> >>> +rdma_nla_ls_reversible {
> >>> +	__u32		reversible;
> >>> +};
> >>
> >> Isn't __u8 sufficient for reversible ?
> > Certainly enough. However, reversible is __u32 in struct
> ib_user_path_rec and int in struct ib_sa_path_rec.
> 
> OK; I hadn't double checked there. So it's "inherited" from those
> reversible definitions.

I don't think we need to adhere to the sizes defined in other structures.  I agree with Hal's original comment.  A __u8 here seems sufficient, unless we want to introduce some bit fields.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
