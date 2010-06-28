From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx4 pci device table
Date: Mon, 28 Jun 2010 16:11:35 +0300
Message-ID: <4C289F87.8050803@voltaire.com>
References: <Pine.LNX.4.64.1006221025130.11239@zuben.voltaire.com> <adafx0ds5jj.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adafx0ds5jj.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> I think the current upstream location is correct.  This matches the practice of eg iw_cxgb3 as well as cxgb3i, bnx2i etc.  This does have the disadvantage that mlx4_en and mlx4_ib are not auto-loaded by PCI hotplug, but so it goes.
okay. Still, its too bad that ofed ships patches that do things the 
other way around vs upstream. Yevgeny, if you have reasoning in place to 
do things the other way, why not submit upstream?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
