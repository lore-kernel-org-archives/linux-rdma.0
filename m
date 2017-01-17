From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCHv2 1/2] IB/iser: Fix sg_tablesize calculation
Date: Tue, 17 Jan 2017 17:54:58 +0200
Message-ID: <5c65bdb9-7ad2-e333-fe9b-93624e1303a1@grimberg.me>
References: <1484664446-15535-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484664446-15535-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> For devices that can register page list that is bigger than
> USHRT_MAX, we actually take the wrong value for sg_tablesize.
> E.g: for CX4 max_fast_reg_page_list_len is 65536 (bigger than USHRT_MAX)
> so we set sg_tablesize to 0 by mistake. Therefore, each IO that is
> bigger than 4k splitted to "< 4k" chunks that cause performance degredation.
> Remove wrong sg_tablesize assignment, and use the value that was set during
> address resolution handler with the needed casting.
>
> Fixes: 911f4331bc87 ("IB/mlx5: Expose correct max_fast_reg_page_list_len")

That's not correct, the patch was a fix which exposed a bug in iser
that was broken anyway. Let's remove it.

Other than that, looks good,

Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
