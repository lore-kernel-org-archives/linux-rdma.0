From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ib/mad: remove Device Mgmt from RMPP class list
Date: Wed, 24 Jul 2013 22:29:45 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E021B0DB0@CRSMSX101.amr.corp.intel.com>
References: <20130724144426.5a63669ea6107c8a3e6c1867@intel.com>
 <51F04E2D.9060708@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E021B0B9D@CRSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A8237384567CA1@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237384567CA1-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

Please skip this patch.  Sean, see below.

> -----Original Message-----
> From: Hefty, Sean
> Sent: Wednesday, July 24, 2013 3:23 PM
> To: Weiny, Ira; Hal Rosenstock
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Subject: RE: [PATCH] ib/mad: remove Device Mgmt from RMPP class list
> 
> > > See Annex 8; DevMgt class version 2 rather than 1 is currently supported.
> >
> > Could older devices still return version 1?  If so the kernel should
> > allow DevMgt without RMPP, correct?
> 
> This check has been this way since 2.6.17.  I think it's reasonable to say that
> there aren't any devices using version 1 that are running with Linux.

Actually the "check" does not do anything unless you specify an rmpp_version as well.

		/* Make sure class supplied is consistent with RMPP */
		if (!ib_is_mad_class_rmpp(mad_reg_req->mgmt_class)) {
			if (rmpp_version)
				goto error1;
		}

I did not realize that some management classes optionally support RMPP.  So in this case the check is correct.

In some User Space RMPP patches I am working on I wanted to verify that an RMPP management class actually specified rmpp_version.  I see that I either need to skip this check or look at the class version as well.  :-(

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
