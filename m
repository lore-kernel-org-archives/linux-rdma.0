From: "lihaidong" <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Subject: Mellanox implementation for atomic operations
Date: Mon, 10 May 2010 14:42:27 +0800
Message-ID: <201005101442273436938@inspur.com>
References: <201005101435267348378@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, shipr <shipr-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
   I have a question about atomic operations.
   According to IB specification o10-48, all atomic operation request made to the same HCA, referencing the same physical memory are serialized with respect to each other.  I know this should be complied with if HCA supports atomic operations, right?
   According to  IB specification o10-49, all atomic operations requests that referencing the same physical memory are serialized with respect to each other. This means that atomic operations performed by processors should serialized with atomic operations performed by HCAs, too, if they were referencing the same physical memory.
  I want to know whether Mellanox implementation for atomic operations comply with o10-49 or not.
  if not ,to what extent it comply with the rule? 
  I also was intrested in how this rule is complied with by others vendors?

2010-05-10 
lihaidong 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
