From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 1/6] IB Netlink Infrastructure
Date: Thu, 13 Jan 2011 16:00:55 +0200
Message-ID: <1294927255.16365.415.camel@nirm-7>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com>
	 <1294068834-17778-2-git-send-email-nirm@voltaire.com>
	 <ada7he94tt1.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada7he94tt1.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-01-12 at 14:54 -0800, Roland Dreier wrote:
> > +#define pr_fmt(fmt) "%s:%s: " fmt, KBUILD_MODNAME, __func__
> 
> Is this used anywhere?
> 
>  - R.

pr_fmt is used as a custom format for pr_* calls. it replaces the
standard pr_fmt definition in linux/printk.h .
Nicer than printks.

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
