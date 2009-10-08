From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Wed, 7 Oct 2009 23:46:24 -0700
Message-ID: <3BA5B96263EC4ACA8FF3C4D8DCF47C69@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com> <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <20091008005425.GW5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091008005425.GW5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Yep, not sure how you handle the listening side without port
>conflicts?? But that doesn't seem to be a huge problem. TBH - since
>ACM is kinda its own little world, it could just use a seperate
>service ID space from RDMA CM?

I'm not sure how to handle the port space yet.  The port space is specified when
the rdma_cm_id is created.  I don't think there's an immediate need to change
anything on the listen side, but if we add AF_IB, then adding RDMA_PS_IB may
make sense.  This could be the full 64-bit service ID.  (We can determine the
right name for AF_IB / AF_GID based on what's actually in the structure.)

>> The following information should be known after calling
>> rdma_resolve_addr: sgid, dgid, pkey, source port/sid, destination
>> port/sid.  The address structure for AF_IB should be defined to
>> capture this information.  (The port / service ID needs to be worked
>> out.)
>
>Yes, that seems great..

On second thought, I'm not sure about _needing_ the pkey.  My first draft of
this is:

struct sockaddr_ib {
	unsigned short int ib_family;
	__u16 reserved;
	union ib_gid gid;
	__be64 ib_service_id; 
};

Although I considered dividing the service id and putting the low order bytes
where reserved is, or only supporting the RDMA IP CM service ID format, possibly
using sockaddr_in6 directly.

>What API would you use to pass the PR data?

API at which level?

>What do you think of a 'rdma_get_addr_info' that could be where libacm
>hooks?

I have no objections to extending the librdmacm API.

>> Would this approach combined with the ability to set the route work for
>> everyone?
>
>'set the route' ?

Pass the path record to the kernel.  This piece is still missing to allow user
space to own the policy for obtaining path information.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
