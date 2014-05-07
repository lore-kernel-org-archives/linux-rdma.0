From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 4/5] ib/mad: add new ioctl to user space to support new
 registration options
Date: Wed, 7 May 2014 14:39:26 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04B82CCF@CRSMSX101.amr.corp.intel.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
 <1399340690-27677-5-git-send-email-ira.weiny@intel.com>
 <20140506030441.GD2307@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140506030441.GD2307-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Mon, May 05, 2014 at 09:44:49PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> 
> > +struct ib_user_mad_reg_req2 {
> > +	__u32	id;
> > +	__u32	qpn;
> > +	__u8	mgmt_class;
> > +	__u8	mgmt_class_version;
> > +	__u16   res;
> > +	__u32   flags;
> > +	__u64   method_mask[2];
> > +	__u8    oui[3]; /* network order */
> > +	__u8	rmpp_version;
> > +};
> 
> Please make the padding on 64 bit explicit so we don't have weird problems
> mixing 32 and 64 bit code.

Just to be clear you mean to add a __u32 reserved field to the end of this struct?

> 
> Similar comment as for userspace using a host order uint for the oui.

Ok would you prefer changing this to __u32 and specifying in host order?  Then adjust the padding, like this:

__u32 oui;
_u8 rmpp_version;
_u8 res[3];

To complete the changes?

> 
> It would also be good to verify that a 32 bit binary can successfully execute
> the ioctl on a 64 bit kernel.

I'll try to do this once we agree to the above changes.

Thanks,
Ira

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
