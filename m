From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] xprtrdma: take vendor driver refcount at client
Date: Tue, 28 Jul 2015 11:46:26 +0300
Message-ID: <55B74162.4070501@dev.mellanox.co.il>
References: <1438038086-20522-1-git-send-email-devesh.sharma@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438038086-20522-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/28/2015 2:01 AM, Devesh Sharma wrote:
> Thanks Chuck Lever for the valuable feedback and suggestions.
>
> This is a rework of the following patch sent almost a year back:
> http://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg20730.html
>
> In presence of active mount if someone tries to rmmod vendor-driver, the
> command remains stuck forever waiting for destruction of all rdma-cm-id.
> in worst case client can crash during shutdown with active mounts.

Ouch, taking a reference on the module preventing it from unloading is
not very well behaved (putting it nicely). That's also breaking the
layering of ULPs <-> core <-> provider scheme.

Why not just cleanup everything upon DEVICE_REMOVAL?

>
> The existing code assumes that ia->ri_id->device cannot change during
> the lifetime of a transport. Lifting that assumption is a long chain
> of work, and is in plan.
>
> The community decided that preventing the hang right now is more
> important than waiting for architectural changes.

Well, if you are putting a bandage here - the code should be documented
with a proper FIXME.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
