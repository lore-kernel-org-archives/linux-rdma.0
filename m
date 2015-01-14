From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 15/20] IB/mad: Create jumbo_mad data structures
Date: Wed, 14 Jan 2015 18:39:07 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC005E7@CRSMSX101.amr.corp.intel.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
 <1421082672-22588-16-git-send-email-ira.weiny@intel.com>
 <54B60A75.4010103@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B60A75.4010103-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 1/12/2015 7:11 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > Define jumbo_mad and jumbo_rmpp_mad
> 
> For the sake of review and maintenance, please add few more words here on
> what are these creatures...

Proposed new text:

    Define jumbo_mad and jumbo_rmpp_mad.
    
    Jumbo MAD structures are 2K versions of ib_mad and ib_rmpp_mad structures.
    Currently only OPA base version MADs are of this type.

Sound reasonable?

Ira 

> >
> > Create an RMPP Base header to share between ib_rmpp_mad and
> > jumbo_rmpp_mad

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
