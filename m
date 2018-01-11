From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory
 registration
Date: Thu, 11 Jan 2018 14:22:07 +0200
Message-ID: <20180111122206.GB2800@yuvallap>
References: <1515088046-26605-1-git-send-email-alexma@mellanox.com>
 <1515088046-26605-2-git-send-email-alexma@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515088046-26605-2-git-send-email-alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +The following code example demonstrates non-contiguous memory registration,
> +by combining two contiguous regions, along with the WR-based completion semantic:
> +.PP
> +.nf
> +mr1 = ibv_reg_mr(pd, addr1, len1, 0);
> +if (!mr1) {
> +        fprintf(stderr, "Failed to create MR #1\en");
> +        return 1;
> +}
> +
> +mr2 = ibv_reg_mr(pd, addr2, len2, 0);
> +if (!mr2) {
> +        fprintf(stderr, "Failed to create MR #2\en");
> +        return 1;
> +}

So, to register non-contiguous 512 random buffers i would have to create
512 MRs?

> +
> +mr3 = ibv_reg_mr(pd, NULL, 0, IBV_ACCESS_ZERO_BASED);
> +if (!mr3) {
> +        fprintf(stderr, "Failed to create result MR\en");
> +        return 1;
> +}
> +
> +struct ibv_sge composite[] =
> +{
> +        {
> +                .addr = addr1,
> +                .length = len1,
> +                .lkey = mr1->lkey
> +        },
> +        {
> +                .addr = addr2,
> +                .length = len2,
> +                .lkey = mr2->lkey
> +        }
> +};
> +
> +ret = ibv_mr_set_layout_sg(mr3, 0, 2, composite);
> +if (ret) {
> +        fprintf(stderr, "Non-contiguous registration failed\en");
> +        return 1;
> +}
> +
> +struct ibv_sge non_contig =
> +{
> +        .addr = 0,
> +        .length = len1 + len2,
> +        .lkey = mr3->lkey
> +};
> +
> +struct ibv_send_wr send_wr = {
> +        .opcode = IBV_WR_SEND,
> +        .num_sge = 1,
> +        .sg_list = non_contig,
> +        .flags = 0
> +};
> +
> +ret = ibv_post_send(qp, send_wr, &bad_wr);
> +if (ret) {
> +        fprintf(stderr, "Non-contiguous send failed\en");
> +        return 1;
> +}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
