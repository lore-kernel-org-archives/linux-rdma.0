From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
Date: Tue, 15 Dec 2009 10:34:58 +0200
Message-ID: <20091215083458.GC10744@mtls03>
References: <adaocm1csgb.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaocm1csgb.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 14, 2009 at 10:37:40AM -0800, Roland Dreier wrote:
> 
> Here are a few topics that are not ready in time for the 2.6.33 window
> and will need to wait for 2.6.34 at least:
> 
> 
>  - IBoE.  In principle I think this is starting to get there.  Still
>    want to see better ABI compatibility at least, and also make sure
>    the interface chosen works for both rdmacm and non-rdmacm
>    applications.
> 

Based on this, I am going to send a new patch set, a few days after
2.6.33-rc1 is out.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
