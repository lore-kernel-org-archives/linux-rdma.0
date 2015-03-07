From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] iser-target: Handle errors from isert_put_datain and
 isert_get_dataout
Date: Sat, 07 Mar 2015 04:16:43 +0200
Message-ID: <54FA5F8B.1030003@dev.mellanox.co.il>
References: <462EF229174FDB4D92ACE4656EA561005DD2BD41@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <462EF229174FDB4D92ACE4656EA561005DD2BD41@CMEXMB1.ad.emulex.com>
Sender: target-devel-owner@vger.kernel.org
To: Chris Moore <Chris.Moore@Emulex.Com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel (target-devel@vger.kernel.org)" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 3/6/2015 7:56 PM, Chris Moore wrote:
> isert_put_datain() always returns 1 and isert_get_dataout() always returns 0, even if
> ib_post_send() fails.   They should return an error in this case so the caller can handle it.
> Also, in the case of an ib_post_send() failure, user isert_err instead of isert_warn.
>
> With these changes, these two functions handle errors from ib_post_send() in the
> same way as other functions within ib_isert.c
>

Hi Chris,

This is indeed needed, but I'm afraid this is not complete given the
rc is completely ignored by the callers (see 
lio_queue_data_in/lio_write_pending).

Did you really see any difference with this patch?

> Signed-off-by: Chris Moore <chris.moore@emulex.com>
>
> ---
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 075b19c..7394ba9 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -2860,8 +2860,10 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>   	}
>
>   	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
> -	if (rc)
> -		isert_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
> +	if (rc) {
> +		isert_err("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
> +		return rc;
> +	}
>
>   	if (!isert_prot_cmd(isert_conn, se_cmd))
>   		isert_dbg("Cmd: %p posted RDMA_WRITE + Response for iSER Data "
> @@ -2894,8 +2896,10 @@ isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
>   	}
>
>   	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
> -	if (rc)
> -		isert_warn("ib_post_send() failed for IB_WR_RDMA_READ\n");
> +	if (rc) {
> +		isert_err("ib_post_send() failed for IB_WR_RDMA_READ\n");
> +		return rc;
> +	}
>
>   	isert_dbg("Cmd: %p posted RDMA_READ memory for ISER Data WRITE\n",
>   		 isert_cmd);
> ---
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
