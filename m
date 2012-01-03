From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Send with immediate data completion
Date: Tue, 3 Jan 2012 11:08:55 -0500
Message-ID: <11EC89F0-2BFD-4727-BC45-AD30E0F10348@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi all,

I have a question about a completion for a send with immediate data. The IB spec (1.2.1) only mentions that the WC's immediate data be present at the receiver. It is silent on the value on the sender at completion. It does say that it is only valid if the WC's immediate data indicator is set.

When I test using a 2.6.38 kernel with the kernel.org libibverbs git tree, I see a send completion's wc_flags set with IBV_WC_WITH_IMM yet the imm_data is not what I passed in. Since the spec is silent on setting imm_data on the sender, I assume that I should not rely on looking at the imm_data on a send completion.

Given that, should IBV_WC_WITH_IMM ever be set on the sender?

Thanks,

Scott

-------------
Scott Atchley
HPC Systems Engineer
Center for Computational Sciences
Oak Ridge National Laboratory
atchleyes-1Heg1YXhbW8@public.gmane.org



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
