From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Wed, 10 Apr 2013 02:44:15 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E015759CF@CRSMSX102.amr.corp.intel.com>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com>
 <1364994796-10642-2-git-send-email-jsquyres@cisco.com>
 <CAL1RGDUefwamQ2Gsm9QKC5+jxskxqE5orwNnbS_t060a+YXZDw@mail.gmail.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FE1631@xmb-rcd-x01.cisco.com>
 <515D728B.5010202@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A823736F36B8B5@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FC7B@CRSMSX102.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823736F36B9EA@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FCB1@CRSMSX102.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FFA8E0@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736F36CCCA@ORSMSX101.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FFDBA8@xmb-rcd-x01.cisco.com>
 <2807E5FD2F6FDA4886F6618EAC48510E01575317@CRSMSX102.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823736F36D455@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F36D455-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Hefty, Sean
> Sent: Tuesday, April 09, 2013 6:30 PM
> To: Weiny, Ira; Jeff Squyres (jsquyres)
> Cc: Hal Rosenstock; Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Upinder
> Malhi (umalhi)
> Subject: RE: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
> 
> > If the IBTA were to release new MTU enumerations which values would
> > you recommend then?
> 
> I don't think there's a great solution here.  We're mixing IBTA encoded values
> with non-IBTA values.  We could reserve the 6-bit encoded values for IB, and
> use direct values for others (or at least jump beyond the 6-bit range).  Or we
> can stop matching new IBTA MTU encodings (e.g. IB_MTU_1500 = 6).  Or we
> go back in time and make mtu an int.
> 

I thought reserving the 6 bit's for IB and allowing the enum values to match the MTU was a pretty good compromise.  Especially since PathRecord is defined in sa.h which is provided by libibverbs.  That allows for that IB MTU enum to be used there.

OTOH, now that we have moved toward decent defines in the libibumad  library we could define the MTU enum there.  But then we again go down the path of defining things multiple places and confusing the users...  :-(

As an aside I like the use of RDMA_MTU_* for these values.  Again to distinguish them from the IBTA values.  But I know that is poor form.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
