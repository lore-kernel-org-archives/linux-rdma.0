From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 16/20] IB/mad: Add Intel Omni-Path Architecture defines
Date: Thu, 15 Jan 2015 23:30:30 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC02AB4@CRSMSX101.amr.corp.intel.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
 <1421082672-22588-17-git-send-email-ira.weiny@intel.com>
 <54B7CA4E.5050809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B7CA4E.5050809-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 1/12/2015 12:11 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > OPA_MIN_CLASS_VERSION -- OPA Class versions are > 0x80
> > OPA_SMP_CLASS_VERSION -- Defined at 0x80 OPA_MGMT_BASE_VERSION --
> > Defined at 0x80
> >
> > Increase max management version to accommodate OPA
> 
> Allocation of MAD base and class version numbers is owned by the IBTA.
> It doesn't seem appropriate to arbitrarily claim code points without proper
> approval.

OPA is its own architecture space.  While this space uses some of the same values as IB we are not claiming any IBTA values.  This is similar to how IB GIDs and IPv6 addresses look the same but are in separate addressing domains.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
