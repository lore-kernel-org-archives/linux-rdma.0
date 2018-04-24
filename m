From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH 1/1] Revert "rds: ib: add error handle"
Date: Mon, 23 Apr 2018 20:27:36 -0700
Message-ID: <4e17b3f0-94b4-6038-419d-68657027f331@oracle.com>
References: <1524533941-4072-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1524533941-4072-1-git-send-email-yanjun.zhu@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Zhu Yanjun <yanjun.zhu@oracle.com>, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: davem@davemloft.net, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 4/23/18 6:39 PM, Zhu Yanjun wrote:
> This reverts commit 3b12f73a5c2977153f28a224392fd4729b50d1dc.
> 
> After long time discussion and investigations, it seems that there
> is no mem leak. So this patch is reverted.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
Well your fix was not for any leaks but just proper labels for
graceful exits. I don't know which long time discussion
you are referring but there is no need to revert this change
unless you see any issue with your change.

Regards,
Santosh
