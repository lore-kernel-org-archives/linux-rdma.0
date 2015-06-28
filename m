From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC] RDMA/core: add rdma_get_dma_mr()
Date: Sun, 28 Jun 2015 19:01:08 +0300
Message-ID: <55901A44.8020103@mellanox.com>
References: <20150625212917.14869.66238.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625212917.14869.66238.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 26/06/2015 00:29, Steve Wise wrote:
> The semantics for MR access rights are not consistent across RDMA
> protocols.  So rather than have applications try and glean what they need,
> have them pass in the intended roles for the MR to be allocated and let
> the RDMA core select the appropriate access rights given the roles and
> device capabilities.

I wanted to point out that with this scheme the ULP may sometimes get an
MR with a wider set of permissions that it asked for, and I'm not sure
that's always safe. Perhaps the ULP wants to guarantee that the MR
doesn't allow certain kinds of accesses and doesn't expect the verbs
layer to change that.

This patch looks fine since it is just a helper function, but if you
replace the MR creation with these flags, you might confuse users to
think that they can control e.g. write sink and read sink separately.

Haggai

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
