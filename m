From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/6] Enhanced mode for IPoIB driver
Date: Mon, 24 Apr 2017 12:24:35 -0400
Message-ID: <1493051075.3041.44.camel@redhat.com>
References: <20170405140913.2551-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405140913.2551-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-04-05 at 17:09 +0300, Leon Romanovsky wrote:
> Hi Doug,
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
> dependecies between different submissions. This caused to change in
> author line.
> I hope that it doesn't really matter and it won't stop you from
> merging it.
> 
> Per-your request, I based this patch set on v4.11-rc3.
> 
> Changes from V0:
> ----------------------
> 1. ipoib_priv function returns struct ipoib_dev_priv * instead of
> void
> 2. Move all the refactoring of netdev_priv to be in single patch
> 3. Change the name of the Formation commit.
> 4. Remove unneeded blank lines
> 5. Set rn->hca on creation.
> 6. Return -EOPNOTSUPP instead of ENOTSUPP
> 7. Remove hunk with DMA from ib_device struct.
> 
> Thanks,
>         Leon
> 
> CC: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

I pulled the mlx5 changes for this from DaveM's net-next tree, then
applied the Intel VNIC patches, then applied these patches (which
results in conflicts between your first patch and Intel's patches).  I
hand fixed those conflicts, so I would double check that you are happy
with how I laid out the struct elements and what not.  Otherwise,
thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
