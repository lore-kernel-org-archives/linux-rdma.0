From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 02/22] IB/core: change pkey table lookups
 to support full and partial membership for the same pkey
Date: Thu, 13 Sep 2012 19:00:01 +0300
Message-ID: <50520301.7040803@mellanox.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-3-git-send-email-jackm@dev.mellanox.co.il> <504F6C4F.6050207@redhat.com> <50520193.2010304@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50520193.2010304-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 13/09/2012 18:53, Or Gerlitz wrote:
> The physical PKey table can contain both full and partial memberships 
> of the same Pkey.
> This is needed to serve 2 VFs that are granted access to the same 
> PKey, albeit with different membership types. 

Example use case -- RDMA or IPoIB network storage (file/block) server 
running on a VM
and clients  running on other VMs. Some of the client VMs may be located 
on the
same hypervisor node as the server, and we want the clients to use limited
partition such that they can't talk to each other on the storage partition.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
