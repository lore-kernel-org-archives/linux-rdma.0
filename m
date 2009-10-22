From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] librdmacm: initialize correct pthread condition in	rdma_join_multicast
Date: Thu, 22 Oct 2009 17:13:42 +0200
Message-ID: <4AE076A6.1030908@voltaire.com>
References: <04702C2CBECB44E5A2D3D3495EA0378B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <04702C2CBECB44E5A2D3D3495EA0378B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Nir Naaman <naaman-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> rdma_join_multicast re-initializes id_priv->cond rather than mc->cond. Fix this.  Bug reported by Nir Naaman
any idea what's the impact of this bug?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
