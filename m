From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH 5/22 v2] [for 2.6.36] rdma/cm: update port	reservation to support AF_IB
Date: Thu, 25 Mar 2010 14:00:25 -0700
Message-ID: <AC26D518E7AE4BE6BA3BDFC11480F8DB@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com> <012F7D9E5E97445E9100EF170212AEE7@amr.corp.intel.com> <7451BD1514874F3E987E55040776EECC@amr.corp.intel.com> <20100325202924.GO29129@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100325202924.GO29129-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Could you elaborate a bit on how you are mixing the port space and the
>SID?

The SID is divided into multiple, disjoint regions.  (Annex 3 defines some of
the regions.)  The port space selects a specific region.

>IMHO, after thinking about it for a bit, I would prefer to see the
>port space be unused from a user-space perspective when used with
>AF_IB.

The rdma_cm_id is associated with a port space on creation, before it's known
what address family will be used.  The kernel code enforces that the SID is
formatted correctly for the port space that was selected.

>If a ps is needed in the kernel then it should pick the ps based on
>the SID prefix that user space provided.. I guess prior to adding the
>mask bits this wouldn't have made sense, but now that they are in it
>seems like the way to go.

I added sib_mask to sockaddr_ib, but it's unused at this point.  I think what
you're saying makes sense, but for RDMA_PS_IB, once it's defined.  RDMA_PS_IB
may need to behave as RDMA_PS_TCP or RDMA_PS_UDP based on the sib_mask and SID,
and ensure that any selected SID is reserved from the correct underlying SID
region.

Does this make sense?

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
