From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Tue, 27 Oct 2009 15:01:56 +0200
Message-ID: <4AE6EF44.5040004@voltaire.com>
References: <1256164230.12075.31.camel@wilder.ibm.com>	<9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com>	<20091021233639.GS14520@obsidianresearch.com>	<BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com>	<20091022002846.GU14520@obsidianresearch.com>	<4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com>	<20091022011939.GW14520@obsidianresearch.com>	<60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com>	<20091022062531.GB26003@obsidianresearch.com>	<4AE43BED.3090405@voltaire.com> <20091025200332.GN26003@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091025200332.GN26003-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> I was saying that point in the rdmacm where the rdma_cm_id is bound to a local RDMA device should have only been rdma_resolve_addr and rdma_accept. Overloading rdma_bind_addr to both bind to an IP and bind to an RDMA device was a bad API choice.
As you wrote, for the most case, binding comes into play only for users 
calling rdma_resolve_address or rdma_accept, for users the need explicit 
binding the rdma-cm provides rdma_bind and it binds to both IP and 
Device, if you can do better, send a patch, binding can't be removed 
from the API since it has users and it makes sense  from users to 
require it.
> Sean is right, there may be special cases that require an early binding, but a seperate API - like IP's SO_BINDTODEVICE - would has been better - and users are forewarned that calling it restricts the environments their app will support
its just naming, will $ sed s/rdma_bind/rdma_set_opt(RDMA_BINDTODEVICE)/g
make you happier? why?

> As it stands we have several impossible situations. Sean, Dave, and I were disucssing the trades offs of what this means relative to IP route resolution 
Don't tell me that Dave's patches are blocked b/c you discovered the 
rdma_bind design and now you don't like it, as I wrote you, Dave sent 
patch to fix the IPv6 support, during the discussion on his patches you 
come and bring up more and more issues you consider as problems (but I 
don't) and block the patch set, I don't think this is appropriate. Let 
the patches go and send your patches to fix the problems you see. Why 
anyone touching some code piece has to fix problems you see in that piece?!


> - but it affects bonding too. If you rdma_bind_addr to the IP of a bonding device, the stack must pick one of the local RDMA ports immediately. If you then call rdma_listen there is a problem: incoming connections may target either RDMA device, but you are only bound to one of them. An app cannot say 'I want to listen on this IP, any RDMA device' with the current API, as you can in IP, and that is a shame
An app can say, I want to listen on that IP and the RDMA device which is 
associated with this IP now. When bonding does fail-over it generated a 
netevent, the rdma-cm catches this event and generates address change 
event, apps can redo their bind/listen at this point. For the time 
being, we never got a user report on a problem, people are doing listen 
on all IPs probably which works perfect with bonding. Currently the HA 
mode of bonding will respond on ARP only on one of the devices and as 
such connection requests will not target any rdma device but rather only 
the active one. If this is such a shame, send fix, spraying mud on the 
maintainer and/or someone sending another patch is a shame, isn't it?


> Traditionally with ethernet the L2 bonding is really only used for link aggregation, L1 failure, and a simple multi-switch HA scheme. It is not deployed if you have multiple ethernet domains. Some people prefer to have dual, independent ethernet fabrics, and in that case you rely on routing features to get the multipath, and HA features of bonding.
okay, thanks for the crash course.

> Go back on the list and look up the posts from Leo who first discovered this, what he was trying to do is kinda the L3 bonding approach.
if Loe has a problem and you want to help him, bring it on the list, 
debate, send patches, jumping into someone's else patch isn't the 
constructive way to go.

> David has been doing a good job and I am glad he is working on the IPv6 support. My comments are only intended to clarify how this is all supposed to work and why the IP flow is actually still relevant to RDMA connections.
As I see it, your comments block the the patches sent by Dave, Sean?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
