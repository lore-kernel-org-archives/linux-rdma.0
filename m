From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Mon, 09 Mar 2015 17:22:30 -0400
Message-ID: <54FE0F16.5090905@dev.mellanox.co.il>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>  <1423092585-26692-15-git-send-email-ira.weiny@intel.com>  <54D52589.8020305@dev.mellanox.co.il>  <2807E5FD2F6FDA4886F6618EAC48510E0CC244A8@CRSMSX101.amr.corp.intel.com>  <54DCB1E9.7010309@dev.mellanox.co.il>  <2807E5FD2F6FDA4886F6618EAC48510E0CC29020@CRSMSX101.amr.corp.intel.com>  <54EB7756.7070407@dev.mellanox.co.il>  <2807E5FD2F6FDA4886F6618EAC48510E0CC3D330@CRSMSX101.amr.corp.intel.com> <1424884438.4847.91.camel@redhat.com> <2807E5FD2F6FDA4886F6618EAC48510E0CC4F18C@CRSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A8237399E6F06F@ORSMSX110.amr.corp.intel.com> <2807E5FD2F6FDA4886F6618EAC48510E0CC4F50B@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CC4F50B-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/4/2015 11:41 AM, Weiny, Ira wrote:
>>
>>> InfiniBand	InfiniBand	InfiniBand Verbs
>>> iWARP		InfiniBand	iWARP Verbs (subset of IBV, with
>>> 				specific connection establishment
>>> 				requirements that don't exist with IBV)
>>> RoCE		Ethernet	InfiniBand Verbs (but with different
>>> 				addressing because of the different
>>> 				link layer)
>>> OPA		OPA		InfiniBand Verbs
>>
>> Verbs is an interface definition to hardware that has been twisted to be a
>> software API and extended to expose vendor-specific implementation 'features'
>> as extensions.  It is not a transport.
>>
>> The device capability bits seems to have evolved to mean: vendor A
>> implemented some random 'feature' in their hardware and wants all
>> applications to now check for this 'feature' and change their code to use it.
>> Basically, what gets defined as a device cap is rather arbitrary.
>>
> 
> This was the point I was trying to make and the reason the OPA MAD support was implemented as a device capability.

The proposed device capability stands for a change that is way more
drastic than just a vendor extension. This is a device running a
completely different wire protocol which does not interoperate with the
IB device that is impersonating.

Also, it does not come under the same jurisdication as IB. It is
entirely possible that IBTA could make some change in the future where
OPA can no longer masquerade as IB.

OPA must also be identifiable by any verbs or management application. To
do that, it should be properly represented in node type, transport type,
and link layer as all the other RDMA technologies have been regardless
of the changes needed. All the other RDMA technologies have gone through
this process.

-- Hal

> Ira
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
