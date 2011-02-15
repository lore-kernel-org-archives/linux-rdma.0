From: Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] perftest/write_bw_postlist
Date: Tue, 15 Feb 2011 11:27:22 +0200
Message-ID: <4D5A46FA.2010009@dev.mellanox.co.il>
References: <4D4B1FFD.9070906@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D4B1FFD.9070906-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Applied . Thanks again Frank

On 2/3/2011 11:37 PM, frank zago wrote:
> Hello,
>
> in write_bw_postlist.c, my_dest (and possibly rem_dest) must be initialized, else the remote node may not be able to parse the connection string and the test will fail to start.
> The others test are doing that initialization.
>
> Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
