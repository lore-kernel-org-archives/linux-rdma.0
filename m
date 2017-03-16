From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [rdma-core v3 8/9] libbnxt_re: Add support for atomic operations
Date: Thu, 16 Mar 2017 10:40:18 -0600
Message-ID: <20170316164018.GG23821@obsidianresearch.com>
References: <1489574253-20300-1-git-send-email-devesh.sharma@broadcom.com>
 <1489574253-20300-9-git-send-email-devesh.sharma@broadcom.com>
 <20170315191515.GH2079@mtr-leonro.local>
 <CANjDDBjGCCc8MLLQ3jhToWyc0Z+Qm3pYejz3BrMrRketDdZbEw@mail.gmail.com>
 <1489680444.2574.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489680444.2574.9.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 16, 2017 at 04:07:38PM +0000, Bart Van Assche wrote:
 
> Does that mean that you consider optimizing for 32-bit CPUs more important than
> optimizing for 64-bit CPUs? Does this also mean that you expect that the macros
> you introduced in your driver to be more efficient than the glibc endianness
> conversion macros? Sorry but this sounds like a weird explanation to me. I agree
> with Leon that it would be a significant improvement if 64-bit data types would
> be used instead of using numerous lower_32_bits() / upper_32_bits() calls.

I actually think this is all just wrong.

For instance looking at bnxt_re_atomic I see it is written to a
wqe/sqe buf, which come from here:

                sqe = (void *)(sq->va + (sq->tail * sq->stride));

Which suggests it is DMA'd from the NIC, and I suspect it is 64 bit
aligned.

The driver does a whole struct 64 bit by 64 bit byteswap on every sqe:

                bnxt_re_host_to_le64((uint64_t *)sqe, sq->stride);

Which means if we look at BE then this struct:

struct bnxt_re_atomic {
        __u32 rva_lo;
        __u32 rva_hi;
        __u32 swp_dt_lo;
        __u32 swp_dt_hi;
        __u32 cmp_dt_lo;
        __u32 cmp_dt_hi;
};

becomes

struct bnxt_re_atomic {
        __le32 rva_hi;
        __le32 rva_lo;
        __le32 swp_dt_hi;
        __le32 swp_dt_lo;
        __le32 cmp_dt_hi;
        __le32 cmp_dt_lo;
};

Which doesn't look like it will work right to me.

I think Bart is basically right, you need to elimiante all of the
calls to bnxt_re_host_to_le64 and related, directly use __leXX in your
DMA structures and byte swap when storing.

For instance, if instead you do:

struct bnxt_re_atomic {
        __le64 rva;
        __le64 swp_dt;
        __le64 cmp_dt;
};

Then things will just work out properly and you will end up with the
same memory image for DMA on BE or LE platforms.

Does the kernel driver have the same problem?

Also, please use the kernel ABI file directly (see how mw_pvrdma-abi.h
makes this happen) as much as possible, drop the copies out of
providers/bnxt_re/bnxt_re-abi.h

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
