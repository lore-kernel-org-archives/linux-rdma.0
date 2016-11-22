From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/multicast: Check ib_find_pkey() return value
Date: Tue, 22 Nov 2016 14:13:37 -0800
Message-ID: <42e2fac5-15af-56a3-bd44-e5d12b7a7bc2@sandisk.com>
References: <94eb11fc-b558-b994-c933-da784caefc53@sandisk.com>
 <950a0611-4aad-9b85-8d18-3dff54db2820@sandisk.com>
 <20161122071145.GD23083@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161122071145.GD23083-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/21/2016 11:11 PM, Leon Romanovsky wrote:
> Don't you need to update process_group_error() function? It has code
> flows with ib_find_pkey() without checking return value, which can be
> anything too.

Hello Leon,

I'll leave that to someone who is familiar with the multicast code.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
