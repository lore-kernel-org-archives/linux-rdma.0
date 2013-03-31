From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH libibverbs v5 4/7] libibverbs: Add support for XRC QPs
Date: Sun, 31 Mar 2013 11:39:30 +0300
Message-ID: <5157F642.9090004@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 1364332466-22786-5-git-send-email-sean.hefty () intel ! com
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

Just wonder, the Infiniband Annex for XRC uses the terms "XRC INI QP" 
and "XRC TGT QP" and the kernel include file "include/rdma/ib_verbs.h" 
also defines "IB_QPT_XRC_INI" and "IB_QPT_XRC_TGT" so why to use in 
"include/infiniband/verbs.h" other names i.e. "IBV_QPT_XRC_SEND" and 
"IBV_QPT_XRC_RECV"?
I agree that send and receive are more intuitive but I think that 
consistency is more important.

Best regards,

S.P.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
