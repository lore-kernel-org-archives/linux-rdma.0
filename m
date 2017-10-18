From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] ibacm: Incorrect list used for subnet list
 causes a segfault
Date: Wed, 18 Oct 2017 11:37:25 -0400
Message-ID: <1508341045.46071.77.camel@redhat.com>
References: <20171016142303.12814.97296.stgit@phlsvslse11.ph.intel.com>
         <20171016142426.12814.13095.stgit@phlsvslse11.ph.intel.com>
         <92b10949-edc9-c363-f909-7674cde678c9@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <92b10949-edc9-c363-f909-7674cde678c9-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-17 at 17:00 +0200, Nicolas Morey-Chaisemartin wrote:
> 
> Le 16/10/2017 à 16:24, Michael J. Ruhl a écrit :
> > From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Setting the provider keyword in the ibacm_opts.cfg file to
> > something
> > other than 'default' will cause ibacm to segfault on startup:
> > 
> > ibacm[32739]: segfault at 302e40 ip 000000000040432d
> > sp 00007ffe4039e1c0 error 4 in ibacm[400000+c000]
> > 
> > To re-produce the segfault, change the provider keyword in
> > ibacm_opts.cfg from:
> > 
> > provider ibacmp default
> > 
> > to:
> > 
> > provider ibacmp 0xFE80000000000000
> > 
> > When adding subnets to a provider subnet list, the incorrect list
> > is
> > used.  The list used is the provider_list (list of all providers)
> > rather than the (specific) provider subnet list.
> > 
> > This corrupts the provider_list, and causes ibacm to crash with the
> > above segfault.
> > 
> > Use the correct list when adding subnet information to a provider.
> > 
> > Fixes: 26e05f8304a506 ("ibacm: use ccan/list.h")
> > Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> For this patch only (no setup for the first one)
> 
> Tested-by: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
