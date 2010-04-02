From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 9/26] rdma/cm: set qkey for port space IB
Date: Fri, 2 Apr 2010 10:57:10 -0700
Message-ID: <5B0AA6F24F4E4217A68B2A1BE9FFF2CD@amr.corp.intel.com>
References: <0B94CA7CD279474EAAF856BCEC45BDED@amr.corp.intel.com> <20100401174007.GB15629@obsidianresearch.com> <79A94ECADC4342D0A4C057DC158F0303@amr.corp.intel.com> <20100401182332.GC15629@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100401182332.GC15629-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>> I think so.  I'm not sure of the best approach.  With these patches,
>> the qkey seems to be the one thing blocking the rdma_cm from
>> supporting any IB UD application.
>
>Right.. qkey is kinda a funny thing, and pkey too I suppose.
>
>I'm not sure, I don't really know the usage model for qkey..

After a little more thought, I'm leaning toward keeping the qkey out of
sockaddr_ib, and instead keeping it closer tied with the qpn.  There's a 32-bit
reserved field in struct rdma_ucm_conn_param that could carry it when resolving
UD QPs.  I will update the patches to handle this.

Multicast is a little more difficult.  The user lacks the ability to fully
specify the MCMemberRecord.  I can at least add the qkey to the new struct
rdma_ucm_join_mcast definition.  Plus, I guess we can always define
sockaddr_ib_mc with whatever additional information we may want to add.  Any
thoughts on this?

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
