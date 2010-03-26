From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH 5/22 v2] [for 2.6.36] rdma/cm: update port	reservation to support AF_IB
Date: Thu, 25 Mar 2010 20:56:23 -0700
Message-ID: <FD7DFBFAF86D4EA99F82836CBCA8AB33@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com> <012F7D9E5E97445E9100EF170212AEE7@amr.corp.intel.com> <7451BD1514874F3E987E55040776EECC@amr.corp.intel.com> <20100325202924.GO29129@obsidianresearch.com> <AC26D518E7AE4BE6BA3BDFC11480F8DB@amr.corp.intel.com> <20100325220435.GP29129@obsidianresearch.com> <C70579E21917462C89AAEAE3C225A58B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C70579E21917462C89AAEAE3C225A58B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>Is there any reason the port space has to be known when the cm_id is
>>created but before bind?
>
>No - but it is still required for transport neutrality.  rdma_create_id()
>simply stores the value.

To correct this slightly, a user can call listen after calling create_id without
calling bind.  The bind is done internally to listen.

The port space really should be indicated at creation time.  If we can agree on
that, then the kernel simply needs to decide how to handle AF_IB at bind time.

These patches handle it by setting the well known portion of the SID and acting
on the other bits based on them being set.  The mask is unused.  For the
existing port spaces, we can leave this, or require the user provide a SID/mask
that is consistent with the chosen port space.

For RDMA_PS_IB, I think the flow that you outlined in your other email makes
sense.  Let RDMA_PS_IB cover the entire SID range.  When the SID/mask fall into
an existing port space, it needs to reserve a port from within that port space
to avoid collisions.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
