From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: OpenSuSE 11.1 and OFED-1.5-rc1
Date: Thu, 29 Oct 2009 13:37:34 +0100
Message-ID: <e2e108260910290537s5edc38bxc0ebbaff5f52e79f@mail.gmail.com>
References: <alpine.LNX.2.00.0910291208420.18599@servww6.ww.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.0910291208420.18599-JJMl9ZGQP53d/LzWI6KjTsSSVFg4/55HhC4ANOJQIlc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gheorghe Ardelean <ardelean-3fy81iOio07EklRYOP+eR4QuADTiUCJX@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2009 at 12:10 PM, Gheorghe Ardelean
<ardelean-3fy81iOio07EklRYOP+eR4QuADTiUCJX@public.gmane.org> wrote:
> I must say first that I am new to Infiniband so maybe I am just making some stupid mistakes. I have installed OFED-1.5-rc1 on OpenSUSE 11.1 (we need gcc4.3). The installer expects libstdc++4.2 but it is libstdc++4.3
> on the system, so after changing this in the installer everything goes smooth.
> All the pakages are build and no errors displayed.
>
> After reboot I see that some modules could not be loaded, namely:
>
> ib_ipath: disagrees about version of symbol ib_umem_release
> ib_ipath: Unknown symbol ib_umem_release
> [ ... ]

A long-standing problem of the OFED installer is that it does not
uninstall the distro-provided InfiniBand kernel modules on every Linux
distro. The above issue should be fixed by running the following
commands:

rm -rf /lib/modules/$(uname -r)/kernel/drivers/infiniband
rm -rf /lib/modules/$(uname -r)/kernel/drivers/net/mlx4
reboot

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
