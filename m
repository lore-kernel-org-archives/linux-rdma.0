From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 16/20] IB/mad: Add Intel Omni-Path Architecture defines
Date: Tue, 20 Jan 2015 18:59:45 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC0657B@CRSMSX101.amr.corp.intel.com>
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
 <20150120181557.GC31320@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150120181557.GC31320-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Mon, Jan 19, 2015 at 10:50:38PM +0000, Weiny, Ira wrote:
> > >
> > > On Mon, Jan 19, 2015 at 07:57:22PM +0000, Weiny, Ira wrote:
> > >
> > > > Perhaps you can give us an example of where the current code would
> > > > work without modifications if the IBTA were to define any new base
> > > > or smp class version?
> > >
> > > I think the point here is that every check for OPA_MIN_CLASS_VERSION
> > > must also be combined with a check if the device in question is OPA or not.
> >
> > This contradicts what you say below....
> 
> How so?
> 
> if (mad_reg_req->mgmt_class_version >= OPA_MIN_CLASS_VERSION
>     && !port_priv->qp_info[qpn].supports_jumbo_mads) {
> 

Sorry, I got a bit confused because this is not the latest version of the patch.

> Should be:
> 
> if (port_is_opa && mad_reg_req->mgmt_class_version >=
> OPA_MIN_CLASS_VERSION
>     && !port_priv->qp_info[qpn].supports_jumbo_mads) {
> 
> And since port_is_opa = true implies
> port_priv->qp_info[qpn].supports_jumbo_mads = true the above if can never
> evaluate to true and can just be removed.

Right there is no need to check for supports_jumbo_mads.  The latest version was:

+               if (mad_reg_req->mgmt_class_version >= OPA_MIN_CLASS_VERSION &&
+                   !(port_priv->device->attributes.device_cap_flags2 & IB_DEVICE_OPA_MAD_SUPPORT)) {



The "bug" in the patch is that any class version should be allowed on IB devices.  This check prevented class versions >= 0x80 for IB devices.

NOTE however that the current code already limits users to a class version < 8.  (due to the implementation.)

-#define MAX_MGMT_VERSION       8
+#define MAX_MGMT_VERSION       0x83
...
                if (mad_reg_req->mgmt_class_version >= MAX_MGMT_VERSION) { 
                        dev_notice(&device->dev, 
                                   "ib_register_mad_agent: invalid Class Version %u\n",
                                   mad_reg_req->mgmt_class_version);
                        goto error1;
                }

Therefore I did not see this as limiting the IB implementation we already have.

I will remove the patch as I agree with Jason and Hal it is technically more correct.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
