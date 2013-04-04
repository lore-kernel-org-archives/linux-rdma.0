From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH opensm] Change LFT event to be per block/per switch rather
 than just per switch
Date: Thu, 04 Apr 2013 14:46:42 -0400
Message-ID: <515DCA92.9030800@dev.mellanox.co.il>
References: <515D5FA5.1000809@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0156FCEF@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0156FCEF-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/4/2013 2:45 PM, Weiny, Ira wrote:
> This changes the data sent by OSM_EVENT_ID_LFT_CHANGE.  

That event was just added and was experimental rather than being some
preexisting event already in some release.

> I think this is a dangerous precedent.  

It's not setting this precedent.

-- Hal

> Even though plugins must be coded to specific versions of OpenSM I don't think they will fail to compile with this change and users would get random behavior when they try to use the event_data passed.
> 
> I think it might be more appropriate to define a new event id say OSM_EVENT_ID_LFT_BLOCK_CHANGE.
> 
> Ira
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
