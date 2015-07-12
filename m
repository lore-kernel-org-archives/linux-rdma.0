From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 03/12] xprtrdma: Increase default credit limit
Date: Sun, 12 Jul 2015 17:31:23 +0300
Message-ID: <55A27A3B.8000302@dev.mellanox.co.il>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
 <20150709204208.26247.52073.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709204208.26247.52073.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 11:42 PM, Chuck Lever wrote:
> In preparation for similar increases on NFS/RDMA servers, bump the
> advertised credit limit for RPC/RDMA to 128. This allocates some
> extra resources, but the client will continue to allow only the
> number of RPCs in flight that the server requests via its advertised
> credit limit.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Looks good,

Reviewed-By: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
