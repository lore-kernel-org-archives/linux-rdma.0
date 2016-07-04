From: Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Oops with mlx5/NFSoRDMA client with 4.7-rc5ish
Date: Mon, 4 Jul 2016 13:29:55 +0200
Message-ID: <20160704112955.GC11467@suse.de>
References: <730f57aa-b1f6-c6da-4936-bebba1954ca7@redhat.com>
 <5efee0cc-1bec-9cab-c0c5-0e3a9a093894@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5efee0cc-1bec-9cab-c0c5-0e3a9a093894-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lever, Chuck" <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, omer-FrESSTt7Abv7r6psnUbsSmZHpeb/A1Y/@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 03, 2016 at 07:25:57PM +0300, Yishai Hadas wrote:
> On 6/30/2016 9:31 PM, Doug Ledford wrote:
> >This could easily be an mlx5 issue given that it starts with a DMAR
> >error, but I would also hope that NFSoRDMA can manage to survive the
> >DMAR error.  Nothing fancy in this case, it's a plain NFSv3 mount over
> >RDMA.  Client is mlx5, server in this case is using mlx4.  Activity was
> >doing a build of a user space package over NFS.
> >
> 
> Worked with NFSoRDMA with 4.7-rc4 over mlx5 in order to reproduce, got at
> some step below WARN that comes from iommu, however couldn't get the OOPs
> that you pointed on. Later on, re-tried to reproduce but couldn't hit it
> again.
> 
> [854421.609563] DMAR: ERROR: DMA PTE for vPFN 0xe81c7 already set (to
> 817c9d002 not 817c9b002)
> [854421.618925] ------------[ cut here ]------------
> [854421.624494] WARNING: CPU: 22 PID: 0 at drivers/iommu/intel-iommu.c:2248
> __domain_mapping+0x361/0x370

This looks like a bug in the IOMMU code. The Intel VT-d driver got
scalability improvements in this cycle which might have introduced this.
Can you guys please try to reproduce with v4.7-rc6? It has a fix which
might be related here.


Thanks,

	Joerg

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
