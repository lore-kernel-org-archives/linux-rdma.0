From: Mukesh Ojha <mojha@codeaurora.org>
Subject: Re: [PATCH] infiniband: cxgb4: fix a potential NULL pointer
 dereference
Date: Wed, 27 Mar 2019 17:45:46 +0530
Message-ID: <a936f45c-adde-3aab-f85b-257d8185f6d5@codeaurora.org>
References: <20190309051921.15212-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190309051921.15212-1-kjlu@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


On 3/9/2019 10:49 AM, Kangjie Lu wrote:
> get_skb may fail and return NULL. The fix returns "ENOMEM"
> when it fails to avoid NULL dereference.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Reviewed-by: Mukesh OJha <mojha@codeaurora.org>


> ---
>   drivers/infiniband/hw/cxgb4/cm.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 8221813219e5..502a54d57e2c 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -1919,6 +1919,9 @@ static int send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid)
>   	int win;
>   
>   	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> +
>   	req = __skb_put_zero(skb, sizeof(*req));
>   	req->op_compl = htonl(WR_OP_V(FW_OFLD_CONNECTION_WR));
>   	req->len16_pkd = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(sizeof(*req), 16)));
