From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/7] Introduce Work Queue object and its
 verbs
Date: Wed, 14 Sep 2016 11:05:23 -0600
Message-ID: <20160914170523.GF16014@obsidianresearch.com>
References: <1473861388-22064-1-git-send-email-yishaih@mellanox.com>
 <1473861388-22064-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473861388-22064-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 14, 2016 at 04:56:22PM +0300, Yishai Hadas wrote:
>  		ibv_cmd_create_qp_ex2;
>  		ibv_cmd_open_qp;
>  		ibv_cmd_rereg_mr;
> +};
> +
> +IBVERBS_1.3 {
> +        global:
> +		ibv_cmd_create_wq;
> +		ibv_cmd_modify_wq;
> +		ibv_cmd_destroy_wq;
>
>  } IBVERBS_1.0;

No, this still isn't right. Please spend some time to learn about this
stuff...

diff --git a/libibverbs/src/libibverbs.map b/libibverbs/src/libibverbs.map
index 2278aba0bb3a..75440b05bc3e 100644
--- a/libibverbs/src/libibverbs.map
+++ b/libibverbs/src/libibverbs.map
@@ -121,3 +121,10 @@ IBVERBS_1.1 {
 		ibv_cmd_rereg_mr;
 
 } IBVERBS_1.0;
+
+IBVERBS_1.3 {
+	    global:
+		ibv_cmd_create_wq;
+		ibv_cmd_destroy_wq;
+		ibv_cmd_modify_wq;
+} IBVERBS_1.1;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
