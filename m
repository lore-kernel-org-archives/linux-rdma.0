From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: ib_post_send in drivers
Date: Fri, 20 Nov 2009 10:16:42 -0600
Message-ID: <4B06C0EA.2070501@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

It seems ib_post_send() is implemented slightly differently in the 
various hardware drivers (as in kernel 2.6.31). Here are the differences 
I've noticed regarding the bad_wr parameter.

amso1100/c2_qp.c : c2_post_send()
 * bails out and does not set bad_wr if the 1st check is bad.

cxgb3/iwch_qp.c : post_one_send()
 * test for bad_send_wr but it should always be set

cxgb3/iwch_qp.c : iwch_post_send()
 * bails out and does not set bad_wr if the 1st 2 checks are bad

ehca/ehca_reqs.c : ehca_post_send()
 * bails out and does not set bad_wr if the 1st check is bad.
 * test for bad_send_wr but it should always be set
 * always return success if at least one post succeeded.

ehca/ehca_reqs.c : post_one_send()
 * test for bad_send_wr but it should always be set

nes/nes_verbs.c : nes_post_send()
 * bails out and does not set bad_wr if the 1st check is bad.

I think assume most are bugs (especially the ehca driver). I can post a 
patch to fix these if confirmed.

Regards,
 Frank

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
