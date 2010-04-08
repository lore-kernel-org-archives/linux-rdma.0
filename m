From: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: IB_CQ_VECTOR_LEAST_ATTACHED in mainline?
Date: Thu, 08 Apr 2010 12:50:10 -0700
Message-ID: <4BBE3372.1090908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yevgeny,

When will this be targeted for mainline?

I'm working on using multiple vectors, and it would be great to see it
there, since I need to work against both OFED and mainline. Otherwise I
need to have my ulp do round robin assignment up to
caps.num_comp_vectors, I guess? VECTOR_LEAST_ATTACHED seems better.

Thanks -- Regards -- Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
