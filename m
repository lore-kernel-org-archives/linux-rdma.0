From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Bug: Discover more than 1 iSER gives -- isert: isert_handle_wc:
 wr... status {9,1} vend_err {8a,d7) -- & -- conn error (1011)
Date: Tue, 28 Jul 2015 11:38:00 +0300
Message-ID: <55B73F68.9090902@dev.mellanox.co.il>
References: <CA+X5Wn7GmZ9fYbm14YAr59rnCwD-eDoz+xVxsu3F0YK1o4dsew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn7GmZ9fYbm14YAr59rnCwD-eDoz+xVxsu3F0YK1o4dsew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/28/2015 5:25 AM, james harvey wrote:
> Two up to date arch systems.  Kernel 4.1.2 (Arch -2).
>
> 2 Mellanox MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE]
> (rev a0) running mlx4_core driver v2.2-1 (Feb, 2014.)  Both on most
> recent firmware for PSID MT_04A0110002, FW Version 2.9.1000.  Systems
> directly connected, no switches.  InfiniBand otherwise works great,
> through VERY extensive testing.
>
> Running OpenFabrics most recent releases of everything (release
> versions, not git versions.)
>
> Open-iscsi 2.0_873-6.
>
> targetcli-fb 2.1.fb41-1, python-rtslib-fb 2.1.fb57-1, and
> python-configshell-fb 1.1.fb18-1.
>
>
>
> I can't discover more than 1 iSER device working at a time.  Using
> IPoIB lets me discover as many as I want.

Hi James,

This is compatibility issue with open-iscsi user-space tools.
Since kernel 3.13 iser is capable of doing discovery over RDMA, but that
required a user-space tools adjustment that is missing in your
open-iscsi.

Are you using the open-iscsi package provided with your distro? (which 
is)? Given that you are using an upgraded kernel, in this case, you need
to upgrade your open-iscsi as well.

I think it would be best to just use the upstream version:
git-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org:mikechristie/open-iscsi.git

Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
