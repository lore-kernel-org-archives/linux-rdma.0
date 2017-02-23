From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH] IB/iser: fix spelling mistake: "unexepected" ->
 "unexpected"
Date: Thu, 23 Feb 2017 19:18:48 +0200
Message-ID: <a2c269cb-4b3c-22b1-64c9-253d35ff3d8b@mellanox.com>
References: <20170223112253.13020-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170223112253.13020-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Roi Dayan <roid@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Looks fine:

Reviewed-by: Max Gurtovoy <maxg@mellanox.com>


On 2/23/2017 1:22 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> trivial fix to spelling mistake in iser_err error message
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/ulp/iser/iser_initiator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
> index 81ae2e3..12ed62c 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -612,7 +612,7 @@ iser_check_remote_inv(struct iser_conn *iser_conn,
>  			 iser_conn, rkey);
>
>  		if (unlikely(!iser_conn->snd_w_inv)) {
> -			iser_err("conn %p: unexepected remote invalidation, "
> +			iser_err("conn %p: unexpected remote invalidation, "
>  				 "terminating connection\n", iser_conn);
>  			return -EPROTO;
>  		}
>
