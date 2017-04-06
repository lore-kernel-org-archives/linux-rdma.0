From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Wed, 5 Apr 2017 21:50:59 -0400
Message-ID: <456a1a5f-26a4-13a6-744c-02679e0fc90b@intel.com>
References: <20170404191732.31895-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404191732.31895-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/04/2017 03:17 PM, Leon Romanovsky wrote:
> Hi Doug,
>
> This patchset mostly comes from Erez with one exception in the first patch.
>
> That patch origins from two different commits, first from Niranjana who added
> RDMA netdev interface and second from Erez who added IPoIB support.
>
> During the preparation to submission, I squashed their commits into one
> and refactored code to allow submission as a standalone topic without creating
> dependecies between different submissions. This caused to change in author line.
> I hope that it doesn't really matter and it won't stop you from merging it.

I think that it does indeed matter. The patch was authored by Niranjana 
it should reflect as such. Why not take Niranjana's patch(s), the fact 
that you folded them in seems to mean you at least agree with the patch.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
