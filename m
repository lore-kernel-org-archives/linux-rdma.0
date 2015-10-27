From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/sa: replace GFP_KERNEL with GFP_ATOMIC
Date: Tue, 27 Oct 2015 14:12:36 -0400
Message-ID: <20151027181235.GA27038@phlsvsds.ph.intel.com>
References: <saurabh.truth@gmail.com> <1445960860-3396-1-git-send-email-saurabh.truth@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445960860-3396-1-git-send-email-saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 27, 2015 at 09:17:40PM +0530, Saurabh Sengar wrote:
> replace GFP_KERNEL with GFP_ATOMIC, as code while holding a spinlock
> should be atomic
> GFP_KERNEL may sleep and can cause deadlock, where as GFP_ATOMIC may
> fail but certainly avoids deadlock

Great catch.  Thanks!

However, gfp_t is passed to send_mad and we should pass that down and use it.

Compile tested only, suggestion below,
Ira


14:09:12 > git di
diff --git a/drivers/infiniband/core/sa_query.c
b/drivers/infiniband/core/sa_query.c
index 8c014b33d8e0..54d454042b28 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -512,7 +512,7 @@ static int ib_nl_get_path_rec_attrs_len(ib_sa_comp_mask comp_mask)
        return len;
 }
 
-static int ib_nl_send_msg(struct ib_sa_query *query)
+static int ib_nl_send_msg(struct ib_sa_query *query, gfp_t gfp_mask)
 {
        struct sk_buff *skb = NULL;
        struct nlmsghdr *nlh;
@@ -526,7 +526,7 @@ static int ib_nl_send_msg(struct ib_sa_query *query)
        if (len <= 0)
                return -EMSGSIZE;
 
-       skb = nlmsg_new(len, GFP_KERNEL);
+       skb = nlmsg_new(len, gfp_mask);
        if (!skb)
                return -ENOMEM;
 
@@ -544,7 +544,7 @@ static int ib_nl_send_msg(struct ib_sa_query *query)
        /* Repair the nlmsg header length */
        nlmsg_end(skb, nlh);
 
-       ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_LS, GFP_KERNEL);
+       ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_LS, gfp_mask);
        if (!ret)
                ret = len;
        else
@@ -553,7 +553,7 @@ static int ib_nl_send_msg(struct ib_sa_query *query)
        return ret;
 }
 
-static int ib_nl_make_request(struct ib_sa_query *query)
+static int ib_nl_make_request(struct ib_sa_query *query, gfp_t gfp_mask)
 {
        unsigned long flags;
        unsigned long delay;
@@ -563,7 +563,7 @@ static int ib_nl_make_request(struct ib_sa_query *query)
        query->seq = (u32)atomic_inc_return(&ib_nl_sa_request_seq);
 
        spin_lock_irqsave(&ib_nl_request_lock, flags);
-       ret = ib_nl_send_msg(query);
+       ret = ib_nl_send_msg(query, gfp_mask);
        if (ret <= 0) {
                ret = -EIO;
                goto request_out;
@@ -1105,7 +1105,7 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 
        if (query->flags & IB_SA_ENABLE_LOCAL_SERVICE) {
                if (!ibnl_chk_listeners(RDMA_NL_GROUP_LS)) {
-                       if (!ib_nl_make_request(query))
+                       if (!ib_nl_make_request(query, gfp_mask))
                                return id;
                }
                ib_sa_disable_local_svc(query);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
