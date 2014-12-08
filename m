From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: positive or negative error values from vendor library for immediate
 errors?
Date: Mon, 8 Dec 2014 10:47:10 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD51D6475F@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello list,

While reviewing some the vendor library source I found that Mellanox and Pathscale user-space provider library returns positive error number if any immediate error is encountered. 
However, other vendor user-space libraries return negative error numbers.

Is there any guideline on this topic. If not, what is the correct way to do this.
Taking reference of glibc implementation, I found that it expects negative integer as return value.

Any pointer/reference/guideline will be a great help.

-Regards
 Devesh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
