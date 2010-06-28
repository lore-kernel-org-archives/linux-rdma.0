From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: mlx4 pci device table
Date: Mon, 28 Jun 2010 22:55:50 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB4439BA237127@MTLMAIL.mtl.com>
References: <Pine.LNX.4.64.1006221025130.11239@zuben.voltaire.com>
	<adafx0ds5jj.fsf@roland-alpha.cisco.com> <4C289F87.8050803@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C289F87.8050803-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/28/2010 4:11 PM, Or Gerlitz wrote:

> Roland Dreier wrote:
>> I think the current upstream location is correct.  This matches the practice of eg iw_cxgb3 as well as cxgb3i, bnx2i >> etc.  This does have the disadvantage that mlx4_en and mlx4_ib are not auto-loaded by PCI hotplug, but so it goes.

> okay. Still, its too bad that ofed ships patches that do things the 
> other way around vs upstream. Yevgeny, if you have reasoning in place to 
> do things the other way, why not submit upstream?
>
Or
This patch was submitted to upstream but was not accepted.
however without it PXE boot cannot work since only mlx4_core is loaded and not the Eth driver

Any other suggestion how to solve it will be accepted.

Tziporet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
