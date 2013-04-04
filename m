From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH opensm] Change LFT event to be per block/per switch
 rather than just per switch
Date: Thu, 4 Apr 2013 18:49:30 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0156FD08@CRSMSX102.amr.corp.intel.com>
References: <515D5FA5.1000809@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FCEF@CRSMSX102.amr.corp.intel.com>
 <515DCA92.9030800@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515DCA92.9030800-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> 
> On 4/4/2013 2:45 PM, Weiny, Ira wrote:
> > This changes the data sent by OSM_EVENT_ID_LFT_CHANGE.
> 
> That event was just added and was experimental rather than being some
> preexisting event already in some release.

Oh, sorry, I did not know it was not release yet...  my bad.

> 
> > I think this is a dangerous precedent.
> 
> It's not setting this precedent.

Sorry,
Ira

> 
> -- Hal
> 
> > Even though plugins must be coded to specific versions of OpenSM I don't
> think they will fail to compile with this change and users would get random
> behavior when they try to use the event_data passed.
> >
> > I think it might be more appropriate to define a new event id say
> OSM_EVENT_ID_LFT_BLOCK_CHANGE.
> >
> > Ira
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
