Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA0BD52;
	Tue, 21 Nov 2023 20:31:30 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vwuhn.J_1700627486;
Received: from 30.32.110.126(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vwuhn.J_1700627486)
          by smtp.aliyun-inc.com;
          Wed, 22 Nov 2023 12:31:28 +0800
Message-ID: <cbad4799-44a8-bea1-a631-e2ceff0288ec@linux.alibaba.com>
Date: Wed, 22 Nov 2023 12:31:24 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH net v4] net/smc: avoid data corruption caused by decline
To: "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
 wenjia@linux.ibm.com, jaka@linux.ibm.com, wintera@linux.ibm.com
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
 tonylu@linux.alibaba.com, pabeni@redhat.com, edumazet@google.com
References: <1700620625-70866-1-git-send-email-alibuda@linux.alibaba.com>
From: Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <1700620625-70866-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2023/11/22 10:37, D. Wythe wrote:

> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> We found a data corruption issue during testing of SMC-R on Redis
> applications.
> 
> The benchmark has a low probability of reporting a strange error as
> shown below.
> 
> "Error: Protocol error, got "\xe2" as reply type byte"
> 
> Finally, we found that the retrieved error data was as follows:
> 
> 0xE2 0xD4 0xC3 0xD9 0x04 0x00 0x2C 0x20 0xA6 0x56 0x00 0x16 0x3E 0x0C
> 0xCB 0x04 0x02 0x01 0x00 0x00 0x20 0x00 0x00 0x00 0x00 0x00 0x00 0x00
> 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0xE2
> 
> It is quite obvious that this is a SMC DECLINE message, which means that
> the applications received SMC protocol message.
> We found that this was caused by the following situations:
> 
> client                  server
>          ¦  clc proposal
>          ------------->
>          ¦  clc accept
>          <-------------
>          ¦  clc confirm
>          ------------->
> wait llc confirm
> 			send llc confirm
>          ¦failed llc confirm
>          ¦   x------
> (after 2s)timeout
>                          wait llc confirm rsp
> 
> wait decline
> 
> (after 1s) timeout
>                          (after 2s) timeout
>          ¦   decline
>          -------------->
>          ¦   decline
>          <--------------
> 
> As a result, a decline message was sent in the implementation, and this
> message was read from TCP by the already-fallback connection.
> 
> This patch double the client timeout as 2x of the server value,
> With this simple change, the Decline messages should never cross or
> collide (during Confirm link timeout).
> 
> This issue requires an immediate solution, since the protocol updates
> involve a more long-term solution.
> 
> Fixes: 0fb0b02bd6fd ("net/smc: adapt SMC client code to use the LLC flow")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---

LGTM, thanks.

Reviewed-by: Wen Gu <guwen@linux.alibaba.com>

>   net/smc/af_smc.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index abd2667..8615cc0 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -598,8 +598,12 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
>   	struct smc_llc_qentry *qentry;
>   	int rc;
>   
> -	/* receive CONFIRM LINK request from server over RoCE fabric */
> -	qentry = smc_llc_wait(link->lgr, NULL, SMC_LLC_WAIT_TIME,
> +	/* Receive CONFIRM LINK request from server over RoCE fabric.
> +	 * Increasing the client's timeout by twice as much as the server's
> +	 * timeout by default can temporarily avoid decline messages of
> +	 * both sides crossing or colliding
> +	 */
> +	qentry = smc_llc_wait(link->lgr, NULL, 2 * SMC_LLC_WAIT_TIME,
>   			      SMC_LLC_CONFIRM_LINK);
>   	if (!qentry) {
>   		struct smc_clc_msg_decline dclc;
