From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 5/5] read_config_file: ignore driver line without driver name
Date: Tue, 31 May 2011 11:37:45 -0700
Message-ID: <BANLkTim-b=u5ow6-k0oDS2D3Hp8r57GG_Q@mail.gmail.com>
References: <cover.1301562707.git.ydroneaud@opteya.com> <d6d3d428fcea4a4f78287204c00bd40bc7d7a7c5.1301562707.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d6d3d428fcea4a4f78287204c00bd40bc7d7a7c5.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 31, 2011 at 2:29 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> If there's no driver name, strsep() will set config to NULL and later
> process of driver name will segfault.

Thanks, applied this one.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
