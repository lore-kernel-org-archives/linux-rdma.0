From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [Patch] iser: free ib connection resources in the proper place
Date: Tue, 28 Feb 2012 18:53:24 +0200
Message-ID: <4F4D0684.8090504@mellanox.com>
References: <35056e0cff3c2ea514095edf5445b9c7fd2fd631.1330198520.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35056e0cff3c2ea514095edf5445b9c7fd2fd631.1330198520.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/25/2012 9:36 PM, Doug Ledford wrote:
> We allocate the login dma buffers in iser_verbs.c as part of
> alloc_ib_conn_resources(), however we are freeing them in
> iser_initiator.c as part of iser_free_rx_descriptors().  This is
> needlessly confusing.  We have an alloc_rx_descriptors() and it doesn't
> alloc something that the free_rx_descriptors() frees, and we have an
> alloc_ib_conn_resources() that allocs something not freed by
> free_ib_conn_resources().  Clean that up.

seems okay, I will test and ack by Thursday

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
