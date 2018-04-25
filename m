From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH] rds: ib: Fix missing call to rds_ib_dev_put in
 rds_ib_setup_qp
Date: Wed, 25 Apr 2018 09:53:17 -0700
Message-ID: <4ea2c988-fd68-3bc0-2f6b-f12648f6d4e9@oracle.com>
References: <1524655321-8379-1-git-send-email-dag.moxnes@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1524655321-8379-1-git-send-email-dag.moxnes@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Dag Moxnes <dag.moxnes@oracle.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 4/25/2018 4:22 AM, Dag Moxnes wrote:
> The function rds_ib_setup_qp is calling rds_ib_get_client_data and
> should correspondingly call rds_ib_dev_put. This call was lost in
> the non-error path with the introduction of error handling done in
> commit 3b12f73a5c29 ("rds: ib: add error handle")
> 
> Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
> ---
Thanks Dag for following it up.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
