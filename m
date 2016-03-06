From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 7/8] IB/core: Advertise supported vector
 CALC capabilities
Date: Sun, 6 Mar 2016 12:37:37 +0200
Message-ID: <20160306103737.GA13396@leon.nu>
References: <1456215928-9305-1-git-send-email-leon@leon.nu>
 <1456215928-9305-8-git-send-email-leon@leon.nu>
 <20160223184400.GA27769@obsidianresearch.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160223184400.GA27769-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 23, 2016 at 11:44:00AM -0700, Jason Gunthorpe wrote:
> On Tue, Feb 23, 2016 at 10:25:27AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > This vector CALC feature allows different offloaded arithmetic
> > calculations of several vectors of equal length.
> > 
> > In order to properly use this feature, the user space applications
> > need to know the supported properties, like operations, size and
> > maximal number of vectors.
> > 
> > The properties exposed are:
> > * calc_matrix - If set, vector CALC matrix is supported.
> > * max_vector_count - Maximum number of vectors supported.
> > * max_chunk_size - Maximum chunk size supported.
> 
> This kind of stuff should be in a kdoc not lost in a commit message.
> 
> > * op_cap - Bit mask indicates which vector CALC operations are supported:
> > 	Bit 1: ADD operation
> > 	Bit 2: MAX operation
> > 	Bit 3: AND operation
> > 	Bit 4: OR operation
> > 	Bit 5: XOR operation
> > 	Bit 6: MIN operation
> > 	Bit 7: SWAP_ENDIANNESS operation
> 
> This should be constants in the uAPI header.
> 
> A commit message is not documentation.

Sorry for not actively participating in this discussion, I was
traveling with terrible internet access.

I'll be more than happy to send the version with your concerns fixed.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
