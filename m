From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 16/20] IB/mad: Add Intel Omni-Path Architecture defines
Date: Tue, 20 Jan 2015 11:15:57 -0700
Message-ID: <20150120181557.GC31320@obsidianresearch.com>
References: <1421082672-22588-17-git-send-email-ira.weiny@intel.com>
 <54B7CA4E.5050809@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC02AB4@CRSMSX101.amr.corp.intel.com>
 <54B9268B.7080600@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC03441@CRSMSX101.amr.corp.intel.com>
 <54BD3DCA.2050208@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A8237399E4F4BA@ORSMSX109.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC05436@CRSMSX101.amr.corp.intel.com>
 <20150119215311.GH13469@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC05C0A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CC05C0A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 19, 2015 at 10:50:38PM +0000, Weiny, Ira wrote:
> > 
> > On Mon, Jan 19, 2015 at 07:57:22PM +0000, Weiny, Ira wrote:
> > 
> > > Perhaps you can give us an example of where the current code would
> > > work without modifications if the IBTA were to define any new base or
> > > smp class version?
> > 
> > I think the point here is that every check for OPA_MIN_CLASS_VERSION must
> > also be combined with a check if the device in question is OPA or not.
> 
> This contradicts what you say below....

How so?

if (mad_reg_req->mgmt_class_version >= OPA_MIN_CLASS_VERSION
    && !port_priv->qp_info[qpn].supports_jumbo_mads) {

Should be:

if (port_is_opa && mad_reg_req->mgmt_class_version >= OPA_MIN_CLASS_VERSION
    && !port_priv->qp_info[qpn].supports_jumbo_mads) {

And since port_is_opa = true implies
port_priv->qp_info[qpn].supports_jumbo_mads = true the above if can
never evaluate to true and can just be removed.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
