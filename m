From: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libmlx4: Add RAW_ETH to post_send
Date: Sun, 19 Dec 2010 17:01:56 +0200
Message-ID: <1292770916.2081.7.camel@alst60.voltaire.com>
References: <4D0DD0BD.5080801@voltaire.com>
	 <1292768150.2081.4.camel@alst60.voltaire.com>
	 <4D0E1C18.5090609@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D0E1C18.5090609-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2010-12-19 at 16:52 +0200, Vladimir Sokolovsky wrote:
> On 12/19/2010 04:15 PM, Alekseys Senin wrote:
> > Hello, Vladimir.
> >
> > Please, apply two patches - libmlx4 and libibverbs -  that I sent today.
> > They add additional enums to userspace  to the programs, that need to
> > use RAW_ETH QP type.
> >
> >
> 
> 
> Hi Aleksey,
> You should send these patches to Roland before applying them to OFED.
> Use the following git trees for libibverbs and libmlx4:
> 
> git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git
> git://git.kernel.org/pub/scm/libs/infiniband/libmlx4.git
> 
> Note: when you send patches to OFED you should CC "OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>" mailing list instead of "linux-rdma".
> 
> Regards,
> Vladimir
O, sorry.
It's my fault. It should be applied to OFED too and I'll resend them to
this list too.
Actually these patches were generated agains OFED tree and applying them
will create new files under 'fixes' directory. I'll generate another set
for Roland tree two.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
