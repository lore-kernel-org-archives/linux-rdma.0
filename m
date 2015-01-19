From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 16/20] IB/mad: Add Intel Omni-Path Architecture defines
Date: Mon, 19 Jan 2015 22:50:38 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC05C0A@CRSMSX101.amr.corp.intel.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
 <1421082672-22588-17-git-send-email-ira.weiny@intel.com>
 <54B7CA4E.5050809@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC02AB4@CRSMSX101.amr.corp.intel.com>
 <54B9268B.7080600@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC03441@CRSMSX101.amr.corp.intel.com>
 <54BD3DCA.2050208@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A8237399E4F4BA@ORSMSX109.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC05436@CRSMSX101.amr.corp.intel.com>
 <20150119215311.GH13469@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150119215311.GH13469-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Mon, Jan 19, 2015 at 07:57:22PM +0000, Weiny, Ira wrote:
> 
> > Perhaps you can give us an example of where the current code would
> > work without modifications if the IBTA were to define any new base or
> > smp class version?
> 
> I think the point here is that every check for OPA_MIN_CLASS_VERSION must
> also be combined with a check if the device in question is OPA or not.

This contradicts what you say below....

> 
> I don't see a problem with sharing the kernel structs or MAD processing, as
> long as all OPA specific behavior is conditionalized on the device in question
> being OPA - it should never be conditionalized on the class version of the MAD.
> 
> > commit a70a5af286b2985a0a95e9733d1e3166845a8be8
> > Author: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Date:   Tue Sep 23 20:04:49 2014 -0400
> >
> >     IB/mad: Add registration check for Intel Omni-Path Architecture
> > MADs
> 
> For instance:
> 
> +		if (mad_reg_req->mgmt_class_version >=
> OPA_MIN_CLASS_VERSION
> +		    && !port_priv->qp_info[qpn].supports_jumbo_mads) {
> 
> Is wrong because it means that no IB software can register for those MADs
> anymore, which is cross polluting the two architectures in the kernel.
> 
> Presumably since supports_jumbo_mads is always true for OPA the above test
> is not required at all and this patch should be dropped.
> 
> But I expect if we keep looking at uses of OPA_MIN_CLASS_VERSION we will
> see other cases where they need to be conditionalized?

That is the only use of OPA_MIN_CLASS_VERSION.  I agree with your second assessment and I'll remove the patch from the next series.

Hal was this your assessment as well?

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
