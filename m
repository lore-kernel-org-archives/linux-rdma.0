From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] Add mmio_memcpy_x64
Date: Tue, 18 Apr 2017 12:27:03 -0600
Message-ID: <20170418182703.GG7181@obsidianresearch.com>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1492123127-6266-6-git-send-email-jgunthorpe@obsidianresearch.com>
 <413a6c23-2bfe-60b6-f179-ddcb82bb19ab@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <413a6c23-2bfe-60b6-f179-ddcb82bb19ab-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 18, 2017 at 07:22:07PM +0300, Yishai Hadas wrote:
> >@@ -239,19 +239,14 @@ static void set_data_ptr_seg_atomic(struct mlx5_wqe_data_seg *dseg,
> > static void mlx5_bf_copy(unsigned long long *dst, unsigned long long *src,
> > 			 unsigned bytecnt, struct mlx5_qp *qp)
> > {
> >-	while (bytecnt > 0) {
> >-		*dst++ = *src++;
> >-		*dst++ = *src++;
> >-		*dst++ = *src++;
> >-		*dst++ = *src++;
> >-		*dst++ = *src++;
> >-		*dst++ = *src++;
> >-		*dst++ = *src++;
> >-		*dst++ = *src++;
> >-		bytecnt -= 8 * sizeof(unsigned long long);
> >+	do {
> >+		mmio_memcpy_x64(dst, src, 64);
> >+		bytecnt -= 64;
> >+		dst += 8;
> >+		src += 8;
> 
> It looks like the above +=8 is wrong in 32 bit systems, agree ?

Hurm. On 32 bit systems 'unsigned long long' will still be 64 bit, so
the above is OK.

The above original is buggy on 32 bit because it is not guarenteed to
generate stores strictly in increasing address order. I think the
author's intent was to have used 'uintptr_t *'.

I will change the arguments to be 'uint64_t *' for clarity.

> >+	/* Use the native word size for the copy */
> >+	if (sizeof(*dst_p) == 8) {
> 
> We expect this 'if' to be dropped at compile time to prevent performance
> penalty comparing the original code, correct ?

Yes.

The entire mmio_memcpy_x64 expands to a bunch of movs with no branches
as the transfer size is constant as well.

The overall mlx5_bf_copy looses one branch because of the
transformation to do/while

> >+		} while (bytecnt > 0);
> >+	} else if (sizeof(*dst_p) == 4) {
> >+		const __be32 *src_p = src;
> >+
> >+		do {
> >+			mmio_write32_be(dst_p++, *src_p++);
> >+			mmio_write32_be(dst_p++, *src_p++);
> >+			bytecnt -= 2 * sizeof(*dst_p);
> 
> Any reason not to write at least 64 bytes here before checking byte count
> and looping again ?

icache size? I debated doing that, but the consensus of the existing
implementations seems to be against it..

We could do a 32 byte unwind which is probably a similar icache
footprint?

What would you like?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
