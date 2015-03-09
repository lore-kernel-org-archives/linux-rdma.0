From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Mon, 09 Mar 2015 17:23:11 -0400
Message-ID: <54FE0F3F.6060806@dev.mellanox.co.il>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-15-git-send-email-ira.weiny@intel.com> <54D52589.8020305@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0CC244A8@CRSMSX101.amr.corp.intel.com> <54DCB1E9.7010309@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0CC29020@CRSMSX101.amr.corp.intel.com> <54EB7756.7070407@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0CC3D330@CRSMSX101.amr.corp.intel.com> <1424884438.4847.91.camel@redhat.com> <2807E5FD2F6FDA4886F6618EAC48510E0CC4F18C@CRSMSX101.amr.corp.intel.com> <20150306174729.GE22375@obsidianresearch.com> <2807E5FD2F6FDA4886F6618EAC48510E0CC53437@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CC53437-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/6/2015 5:47 PM, Weiny, Ira wrote:
>>
>> On Wed, Mar 04, 2015 at 07:21:48AM +0000, Weiny, Ira wrote:
>>
>>> I think this is going to break quite a bit.  I have prototyped setting
>>> OPA devices to "OPA Link Layer" and the perftest tools just fall over.
>>> Any changes to the Link layer or the transport types will require a
>>> transition period for ULPs.
>>
>> How do the perftest tools work with OPA in the first place? OPA seems to have
>> 32 bit lids. Do you mean it 'works' as long as the lid is < 16 bits? Same general
>> point about all of verbs, lots of 'uint16_t lid' in the interfaces?
> 
> The 32 bit LIDs in the SMP are designed for future expansion.  Currently OPA does not support > 16 bit LIDs.

It's not just verbs (structures and APIs) but also CM and any other
place where LID is used which are numerous.

Is a new verbs coming for this ? How will compatibility be dealt with ?

This is also another example why a more complete picture of OPA is needed.

-- Hal

> 
> Ira
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
