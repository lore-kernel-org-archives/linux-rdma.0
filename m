From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 6 Oct 2009 15:53:21 -0700
Message-ID: <B266C10D3C26431E8FF5012420132452@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <20091006200739.GP5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091006200739.GP5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Actually, thinking about it some more, that would be very helpful. As
>I said before, I have worked on apps using IB CM. The only reason is
>to have complete control over the addressing. If I could use RDMA CM
>API in some kind of AF_GID addressing and service ID space, it would
>basically eliminate the need for IB CM entirely and make it alot less
>trouble to support things like iWarp, since it now just another AF/PF
>in the same API family.

In order to maintain application level compatibility, there are a few
requirements for the changes in this patch.  An event needs to be queued
indicating that the librdmacm rdma_resolve_addr() call is complete.  The IB CM
REQ message should carry the IP address, so that data should be set.  And the
state of the rdma_cm_id needs to change.

I did consider the possibility of having the sockaddr contain some IB related
address, with user space performing the mapping.  My thought was that the IP
address needed to be given to the kernel since the IB CM message carries the IP
address in the private data.  The GID could actually be extracted from the
rdma_set_ib_paths() call.

I'm not sure about defining a new address family for GIDs, given that a GID is
already supposed to be an IPv6 address.  Maybe the RDMA CM could check whether
an address mapped to IB GID or not.  If the source address of either an
rdma_bind_addr or rdma_resolve_addr call were an actual GID, it could assume the
same of the destination address.  Something would need to be done to determine
what would go into the IB CM REQ, but that may introduce incompatibilities. 

Note that between the two patches, this one is less important to scaling than
the other one.  It would be ideal to avoid sending ARP requests when they are
not needed. 

>You get the source address via the user (netlink) or kernel
>(ip_route_output_key) equivalent of 'ip route get x.x.x.x dev XXX'

Yes - ip route get gives what's needed.  Is there a simple way to obtain that
same data from within a program?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
