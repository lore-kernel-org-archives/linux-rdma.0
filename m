From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 1/1] mlx4_en: make mlx4_log_num_mgm_entry_size static
Date: Mon, 3 Jul 2017 12:58:03 +0300
Message-ID: <c41bcdc8-94fa-596f-639b-f147576c8583@cogentembedded.com>
References: <1499060119-7063-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1499060119-7063-1-git-send-email-yanjun.zhu@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Zhu Yanjun <yanjun.zhu@oracle.com>, tariqt@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, yuval.shaia@oracle.com, leon@kernel.org
List-Id: linux-rdma@vger.kernel.org

Hello!

On 7/3/2017 8:35 AM, Zhu Yanjun wrote:

> The variable mlx4_log_num_mgm_entry_size is only called in main.c.
    s/called/used/.

> CC: Joe Jin <joe.jin@oracle.com>
> CC: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
[...]

MBR, Sergei
