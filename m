From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [RESEND rdma-core v4 4/8] libbnxt_re: Add support for posting and polling
Date: Mon, 24 Apr 2017 23:53:37 +0530
Message-ID: <CANjDDBi6tE6k4iKjF608XLtYBk1mAdAR=x1XiF=Tr6o_59yn4Q@mail.gmail.com>
References: <1492801032-17587-1-git-send-email-devesh.sharma@broadcom.com>
 <1492801032-17587-5-git-send-email-devesh.sharma@broadcom.com>
 <20170421192255.GA12079@obsidianresearch.com> <CANjDDBiG_0C1DTYKgwCPuUzs34yb1b-iBpxRpU=XXZnm-JcOfw@mail.gmail.com>
 <20170424163416.GA23048@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424163416.GA23048-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 24, 2017 at 10:04 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Apr 24, 2017 at 09:29:11PM +0530, Devesh Sharma wrote:
>> On Sat, Apr 22, 2017 at 12:52 AM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > On Fri, Apr 21, 2017 at 02:57:08PM -0400, Devesh Sharma wrote:
>> >
>> >> +static void bnxt_re_ring_db(struct bnxt_re_dpi *dpi,
>> >> +                         struct bnxt_re_db_hdr *hdr)
>> >> +{
>> >> +     __le64 *dbval;
>> >> +
>> >> +     pthread_spin_lock(&dpi->db_lock);
>> >> +     dbval = (__le64 *)&hdr->indx;
>> >> +     udma_to_device_barrier();
>> >> +     iowrite64(dpi->dbpage, dbval);
>> >> +     pthread_spin_unlock(&dpi->db_lock);
>> >> +}
>> >
>> > What are you expecting this db_lock to do?
>> >
>> > Is 'dbpage' UC or WC memory?
>>
>> Driver re-maps it as "UC-" where strong ordering is guaranteed. How
>> system would handle 64-bit writes will it issue two 32-bit consecutive
>> writes on the bus?
>
> 64 bit systems support 64 bit writes as a single TLP on the PCI-E, so
> the lock is not required.
>
> If the write is broken up into two 32 bit transfers (eg as on a 32 bit
> processor) then the device usually requires them to be presented in
> address increasing order, however the compiler does not guarentee that
> with a simple 64 bit store as above.
>
> Going forward we will merge the new shared mmio accessors:
>
> https://github.com/jgunthorpe/rdma-plumbing/blob/mmio/util/mmio.h
>
> Which provides sane common implementations for these operations.
>
> For this reason I don't think there is much point in your spending
> time to open code a solution in your driver. Now that I know the lock
> is not doing anything it can just be dropped when the mmio accessors
> are merged.

Okay, Thanks for the explanation, I will take care of Leon's comments
and send out a v5, leaving the lock as it is for now.
>
> Jasn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
