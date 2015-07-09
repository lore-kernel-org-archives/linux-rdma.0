From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 36/41] IB/hfi1: add low level page locking
Date: Thu, 9 Jul 2015 10:33:16 +0300
Message-ID: <559E23BC.1040500@mellanox.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
	<20150611231142.16479.41039.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMjM9kRrnCdJmKR2i9VySOLfsZMkU=ZnJE0rXs0tTPSbVw@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC2575DAA8@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2575DAA8-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/07/2015 01:08, Marciniszyn, Mike wrote:
>> anything wrong with the umem services provided by the IB core that
>> requires this implementation? what?
>>
> 
> The current level of the API is mismatched with the PSM SDMA.
> 
> The ib_umem api:
> - maps an SG list which isn't required by PSM since DMA mapping is done by the low level SDMA
Can I ask why do you prefer mapping page by page over using a single sg
list?

> - the mapping is bi-directional vs. from device
> - The pd's context is not there
> 
> Certainly we would consider a core change that provides just the page locking and we could fake a context.
> 
> Mike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
