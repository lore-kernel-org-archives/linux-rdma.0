From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Tue, 17 Feb 2015 21:25:26 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC29020@CRSMSX101.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-15-git-send-email-ira.weiny@intel.com>
 <54D52589.8020305@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC244A8@CRSMSX101.amr.corp.intel.com>
 <54DCB1E9.7010309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54DCB1E9.7010309-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >>>
> >>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index
> >>> 3ab4033..2614233 100644
> >>> --- a/include/rdma/ib_verbs.h
> >>> +++ b/include/rdma/ib_verbs.h
> >>> @@ -128,6 +128,10 @@ enum ib_device_cap_flags {
> >>>  	IB_DEVICE_ON_DEMAND_PAGING	= (1<<31),
> >>>  };
> >>>
> >>> +enum ib_device_cap_flags2 {
> >>> +	IB_DEVICE_OPA_MAD_SUPPORT	= 1
> >>> +};
> >>> +
> >>>  enum ib_signature_prot_cap {
> >>>  	IB_PROT_T10DIF_TYPE_1 = 1,
> >>>  	IB_PROT_T10DIF_TYPE_2 = 1 << 1,
> >>> @@ -210,6 +214,7 @@ struct ib_device_attr {
> >>>  	int			sig_prot_cap;
> >>>  	int			sig_guard_cap;
> >>>  	struct ib_odp_caps	odp_caps;
> >>> +	u64			device_cap_flags2;
> >>>  	u32			max_mad_size;
> >>>  };
> >>>
> >>
> >> Why is OPA support determined via a device capability flag ? What are
> >> the tradeoffs for doing it this way versus the other choices that
> >> have been used in the past for other RDMA technologies like RoCE, iWARP,
> usNIC, ... ?
> >
> > None of those technologies use the MAD stack for Subnet Management.
> Other MAD support is very limited (ie IB compatible PMA queries on the local
> port only).
> >
> > Do you have a suggestion for alternatives?
> 
> The desire to leverage the IB MAD infrastructure for OPA is understood but the
> current approach represents OPA as a device capability which does not seem
> appropriate because OPA is clearly a different type of RDMA technology than
> IB.
> 

While it is a different type of technology, standard verbs[*] remains 100% compatible.  Unlike other verbs technologies user space software does not need any knowledge that the underlying device is not IB.  For example, PR (and SA) queries, CM, rdmacm, and verbs calls themselves are all 100% IB compatible.

Therefore, to address your initial question regarding tradeoffs I believe this method is the least invasive to the code as well as removing any potential performance penalties to core verbs.

Ira

[*] We don't support some of the extensions particularly those which have been most recently introduced.  And we would like to make our own extensions in the form of higher MTU availability, but the patch is not yet ready to be submitted upstream.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
