From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 15/19] IB/mad: Create jumbo_mad data structures
Date: Sat, 4 Apr 2015 00:14:51 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FBD77A@ORSMSX109.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-16-git-send-email-ira.weiny@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FBD6C8@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBD6C8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> > index 00a5e51..80e7cf4 100644
> > --- a/include/rdma/ib_mad.h
> > +++ b/include/rdma/ib_mad.h
> > @@ -136,6 +136,11 @@ enum {
> >  	IB_MGMT_DEVICE_HDR = 64,
> >  	IB_MGMT_DEVICE_DATA = 192,
> >  	IB_MGMT_MAD_SIZE = IB_MGMT_MAD_HDR + IB_MGMT_MAD_DATA,
> > +	JUMBO_MGMT_MAD_HDR = IB_MGMT_MAD_HDR,
> > +	JUMBO_MGMT_MAD_DATA = 2024,
> > +	JUMBO_MGMT_RMPP_HDR = IB_MGMT_RMPP_HDR,

Examining a later patch in this series highlighted that JUMBO_MGMT_MAD_HDR and JUMBO_MGMT_RMPP_HDR are the same size as the corresponding IB_MGMT_* defines.  This seems unnecessary.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
