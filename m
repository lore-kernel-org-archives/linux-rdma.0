From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Wed, 25 Feb 2015 00:29:09 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC3D330@CRSMSX101.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-15-git-send-email-ira.weiny@intel.com>
 <54D52589.8020305@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC244A8@CRSMSX101.amr.corp.intel.com>
 <54DCB1E9.7010309@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC29020@CRSMSX101.amr.corp.intel.com>
 <54EB7756.7070407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54EB7756.7070407-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >>>
> >>> Do you have a suggestion for alternatives?
> >>
> >> The desire to leverage the IB MAD infrastructure for OPA is
> >> understood but the current approach represents OPA as a device
> >> capability which does not seem appropriate because OPA is clearly a
> >> different type of RDMA technology than IB.
> >>
> >
> > While it is a different type of technology, standard verbs[*] remains 100%
> compatible.  Unlike other verbs technologies user space software does not need
> any knowledge that the underlying device is not IB.  For example, PR (and SA)
> queries, CM, rdmacm, and verbs calls themselves are all 100% IB compatible.
> 
> Even if OPA is 100% standard verbs compatible which it does not appear to be,
> that does not make OPA an extra capability of an IBA device.

I don't want to make it an extra capability of an IBA device.  I want to make it an extra capability of a "verbs" device.

> While it is a primary goal of the RDMA stack to have a common verbs API for
> various RDMA interconnects, each one is properly represented to allow it's
> unique characteristics to be exposed.

The difference here is that we have maintained IB Verbs compatibility where other RDMA technologies did not.  We have tested many Verbs applications (both kernel and user space) and they function _without_ _modification_.

Despite this compatibility we are still having this discussion.

I can think of no other way to signal the MAD capability to the MAD stack which will preserve the verbs compatibility in the same way.

> 
> > Therefore, to address your initial question regarding tradeoffs I believe this
> method is the least invasive to the code as well as removing any potential
> performance penalties to core verbs.
> >
> > Ira
> >
> > [*] We don't support some of the extensions particularly those which have
> been most recently introduced.  And we would like to make our own extensions
> in the form of higher MTU availability, but the patch is not yet ready to be
> submitted upstream.
> 
> There appear to be a number of things that are not exposed by the current
> patch set which will be needed in subsequent patches. It would be better to see
> the complete picture so it can be reviewed as a whole.

Is there something in particular you would like to see?  There are no other patches required in the core modules for verbs applications to function.  The MTU patch only improves verbs performance.

Ira 

> 
> -- Hal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
