From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 0/3] RFC: common API for displaying status codes
Date: Mon, 17 Nov 2014 15:05:49 +0200
Message-ID: <5469F2AD.7020406@dev.mellanox.co.il>
References: <20141117022038.4079.66922.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141117022038.4079.66922.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/17/2014 4:29 AM, Chuck Lever wrote:
> Sagi and Or suggested developing a common API for displaying status
> and event codes that can be shared among consumers of ib_core. The
> first patch is a stab at that. The last two patches are examples of
> how the new APIs are used. Lightly tested.
>
> If acceptable, I'll submit 1/3 via the IB tree. 3/3 will go through
> Anna's tree after 1/3 is merged. Does 2/3 need to go through netdev?
>

Looks nice and handy to me.

You can add to the series:

Reveiwed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


Thanks Chuck!

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
