From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Thu, 22 Oct 2009 17:41:53 +0200
Message-ID: <4AE07D41.7040300@voltaire.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>		<F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>		<4ACAF913.3050909@voltaire.com>		<AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>		<15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>		<9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>		<0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com>	<15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com>	<859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com>	<4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9F76F7CD7B9048E8821A1B05CC5FAFE8-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> okay, I just wanted to make sure that the whole thing (ACM + modified librdmacm + modifed rdma-cm) is applicable AND inter-operable for AF_INET / PS_TCP applications
> I do not intend to have any changes that break anything
my question went beyond whether things are going to be broken (they 
aren't as you said), but rather will ACM is going to be 
***applicable***  for AF_INET/PS_TCP application. From your reply and 
the discussion that followed between you and Jason, I got the impression 
that the answer is "not really" b/c if for example the server side 
thinks it would be getting the IP address of the connecting side in the 
REQ private header, once this REQ was sent in the flow of AF_INET which 
was converted to AF_IB, this is not going to happen. Moreover, if the 
SID constructed by AF_INET / PS_TCP call to rdma_resolve_address which 
uses the librdmacm-ACM flow wouldn't match the SID constructed in the 
passive side which didn't use this flow (e.g user --> kernel or kernel 
--> user app), the REQ wouldn't be getting anywhere and be rejected by 
the CM on the passive side :(

>> Going with your proposed flow, I understand that an app call to rdma_resolve_addr will be broken down to rdma_bind_addr, ACM resolution of the destination GID and then rdma_set_ib_dest, so things should work perfect for AF_INET / PS_TCP apps, correct?
> This is my current plan for the kernel: export rdma_set_ib_paths to user space.  Submit a patch.  Get it accepted upstream.  Eat ice cream to celebrate.
again, rdma_set_ib_path for itself is quite innocent... as I wrote you 
couple of days ago, it can be merged anytime, the big thing is the bind 
/ address resolution modified flow which effects the connect/listen, 
etc.  So just for this patch, I would go on a small size ice-cream, 
where once the design for the bigger picture is in place, go for a pint...

> Define AF_IB and struct sockaddr_ib (contains a gid and service id).  Update rdma_bind_addr, rdma_resolve_addr, and rdma_connect to handle AF_IB. rdma_bind_addr fills in the sid according RDMA IP CM service annex. rdma_resolve_addr just needs to save the GIDs. rdma_connect will not modify the private data in the CM REQ for AF_IB.
I really tried to follow the thread between you and Jason with quite 
little success, and I am going to give it more tries... in parallel, 
could you help me understand what is the --drive/reasoning-- from your 
perspective to add AF_IB / PS_IB here?

I believe that the suggestion I brought of: converting rdma_resolve_addr 
with null src addr to route lookup and following that rdma_bind_addr, 
with a similar/same flow for rdma_resolve_addr with src address, next do 
the ACM dgid resolution, call the rdma_set_dgid call. Would allow to 
serve AF_INET / PS_TCP with ACM.

If from other reasons, people want the rdma-cm to support AF_IB and/or 
PS_IB, we can do that as well, but why force doing that behind the cover 
each time ACM is used?!

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
