From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/mad: add new ioctl to user space to support new
 registration options
Date: Wed, 7 May 2014 09:28:23 -0600
Message-ID: <20140507152823.GA20689@obsidianresearch.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
 <1399340690-27677-5-git-send-email-ira.weiny@intel.com>
 <20140506030441.GD2307@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E04B82CCF@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E04B82CCF-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 07, 2014 at 02:39:26PM +0000, Weiny, Ira wrote:
> > On Mon, May 05, 2014 at 09:44:49PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > 
> > > +struct ib_user_mad_reg_req2 {
> > > +	__u32	id;
> > > +	__u32	qpn;
> > > +	__u8	mgmt_class;
> > > +	__u8	mgmt_class_version;
> > > +	__u16   res;
> > > +	__u32   flags;
> > > +	__u64   method_mask[2];
> > > +	__u8    oui[3]; /* network order */
> > > +	__u8	rmpp_version;
> > > +};
> > 
> > Please make the padding on 64 bit explicit so we don't have weird problems
> > mixing 32 and 64 bit code.
> 
> Just to be clear you mean to add a __u32 reserved field to the end of this struct?

I think that is enough, yes. Yann has been using pahole to investigate
these issues.


> > Similar comment as for userspace using a host order uint for the oui.
> 
> Ok would you prefer changing this to __u32 and specifying in host order?  Then adjust the padding, like this:
> 
> __u32 oui;
> _u8 rmpp_version;
> _u8 res[3];
> 
> To complete the changes?

s/res/reserved/

Sure, that seems simpler for all involved. 

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
