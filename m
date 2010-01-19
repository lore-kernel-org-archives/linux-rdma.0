From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: fix post_recv wq overflow check
Date: Tue, 19 Jan 2010 17:48:17 +0200
Message-ID: <4B55D441.5050000@voltaire.com>
References: <Pine.LNX.4.64.0912231727040.19295@zuben.voltaire.com>	<adapr5nt0rc.fsf@roland-alpha.cisco.com> <4B45913C.10405@Voltaire.com>	<adaocl6qrjc.fsf@roland-alpha.cisco.com> <4B45A2E5.2070301@voltaire.com> <adamy0kpo1m.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamy0kpo1m.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> I do think it is quite common to see this WQ overflow check trigger, even for kernel code
mmm, why is that common? typically there's a higher layer to which the 
IB ULP advertises some sort of maximal number of credits (e.g in the 
SCSI case, iser and srp specify the maximal number of commands in the 
scsi host template) or the ULP informs a higher layer that no more sends 
can be done (e.g IPoIB calling netif_stop_queue once it sense that the 
QP filled, etc).

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
