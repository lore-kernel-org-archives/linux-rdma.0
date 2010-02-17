From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: is it possible to avoid syncing after an rdma write?
Date: Wed, 17 Feb 2010 12:40:46 +0200
Message-ID: <4B7BC7AE.1000702@voltaire.com>
References: <4B7B2A6C.80101@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B7B2A6C.80101-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Andy Grover wrote:
> RDS follows each RDMA write op with a Send op [...] we want to omit the Send 
Andy,

This way or another the side which isn't initiating the rdma write has 
to be notified that the local buffer && rkey (stag) they advertised can 
now invalidated from the  HCA/RNIC IOMMU, its mapping from the node 
IOMMU, returned to the pool it was allocated from, reclaimed by higher 
layers etc.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
