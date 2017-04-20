From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 0/6] Enhanced mode for IPoIB driver
Date: Thu, 20 Apr 2017 14:52:03 -0400
Message-ID: <1492714323.3041.8.camel@redhat.com>
References: <20170410082230.10662-1-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170410082230.10662-1-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-04-10 at 11:22 +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> This is third version of IPoIB driver, the main change between
> previous
> version is change in author line for the first patch.
> 
> This patchset mostly comes from Erez with one exception in the first
> patch.
> 
> That patch origins from two different commits, first from Niranjana
> who added
> RDMA netdev interface and second from Erez who added IPoIB support.
> 
> During the preparation to submission, I squashed their commits into
> one
> and refactored code to allow submission as a standalone topic without
> creating
> dependencies between different submissions.
> 
> Per-your request, I based this patch set on v4.11-rc3.

Since I put this and the VNIC patches into the same branch, the first
patch had to be redone.  It is not identical to your code here because
I didn't do an automatic merge, I hand transferred the changes from the
first patch that weren't already in the branch from the VNIC series
over.  Given that I hand did things, it might be wise to double check
that the patch is suitable for your needs.  In particular, I didn't
bother to move the private data to the end of the struct, so someone
might want to change that if it actually matters to performance.
 Otherwise, series applied to a custom branch based off of DaveM's net-
next that will allow for the fixup patch to be applied without breaking
things like 0day because it has both the IPoIB changes and the mlx5
changes for IPoIB in it.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
