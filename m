From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
Date: Wed, 1 Jul 2015 10:35:17 +0300
Message-ID: <55939835.6090606@mellanox.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int>
 <20150629213618.4188.50574.stgit@build.ogc.int>
 <55925B70.1070409@mellanox.com>
 <001e01d0b341$1eefe9f0$5ccfbdd0$@opengridcomputing.com>
 <20150630164247.GB30149@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150630164247.GB30149-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/30/2015 7:42 PM, Jason Gunthorpe wrote:
>> NFSRDMA currently checks the transport type to decide how to set the
>> >access flags for memory registration.  With the new services
>> >exported in this series, we can change/simplify NFSRDMA to not have
>> >to know the transport type.
> It would be excellent if this series actually went through and got rid
> of all the now deprecated users. This would confirm we have the right
> API here and prune off the old stuff. This is fairly trivial to do, I think?
>
> The goal is to make things simpler, maintaining two kernel APIs is not
> simpler:)

Agree.

Steve, you should 1st go and port NFSoRDMA to your proposal (patch) for 
IB core changes, so we can see the change in action for a code which is 
working today on multiple transports, iser should be 2nd.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
