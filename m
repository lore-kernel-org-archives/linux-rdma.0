From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 16/20] IB/mad: Add Intel Omni-Path Architecture defines
Date: Mon, 19 Jan 2015 16:06:22 -0500
Message-ID: <54BD71CE.8000505@dev.mellanox.co.il>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com> <1421082672-22588-17-git-send-email-ira.weiny@intel.com> <54B7CA4E.5050809@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0CC02AB4@CRSMSX101.amr.corp.intel.com> <54B9268B.7080600@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0CC03441@CRSMSX101.amr.corp.intel.com> <54BD3DCA.2050208@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237399E4F4BA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E4F4BA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/19/2015 1:28 PM, Hefty, Sean wrote:
>> Currently, these patches are claiming values that are controlled by an
>> established standards organization. It is the equivalent of just
>> grabbing a currently unused Ethertype value for a new protocol and then
>> claiming that whenever the IEEE allocates it for something else you will
>> make changes to resolve the conflict.
> 
> It would be equivalent if OPA was Infiniband, but it is not.  It is a separate architecture, with an entirely separate name space.  

But the OPA MAD patches currently share the IBA name space.

-- Hal

> Conceptually, it is similar to the IB GRH and the IPv6 header.  They have a similar structure, but they are not the same.  The IBTA can define a new GRH field values, such as NxtHdr, without consulting or getting approval from the IETF.
> 
> Ira could introduce patches to define OPA management packets, but the general structure of those packet headers would be exactly the same as IB management packets.  There's no need to introduce duplicate definitions into the code base.  The existing structures can be reused.  However, OPA makes use of different values for the fields.
> 
> - Sean
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
