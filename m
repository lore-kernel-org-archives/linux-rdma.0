From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 06/12] xprtrdma: Always provide a write list when
 sending NFS READ
Date: Sun, 12 Jul 2015 17:42:11 +0300
Message-ID: <55A27CC3.9080601@dev.mellanox.co.il>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
 <20150709204237.26247.297.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709204237.26247.297.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 11:42 PM, Chuck Lever wrote:
> The client has been setting up a reply chunk for NFS READs that are
> smaller than the inline threshold. This is not efficient: both the
> server and client CPUs have to copy the reply's data payload into
> and out of the memory region that is then transferred via RDMA.
>
> Using the write list, the data payload is moved by the device and no
> extra data copying is necessary.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Reviewed-By: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
