From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Sat, 7 Aug 2010 09:56:13 +0200
Message-ID: <AANLkTimc3iS8=8ZQ9u8tOLP4-q_e+o0=AncZj-Mbre2g@mail.gmail.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<adamxtejbes.fsf@roland-alpha.cisco.com>
	<AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
	<adafwz4g98j.fsf@roland-alpha.cisco.com>
	<AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com>
	<20100727182046.GT7920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100727182046.GT7920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 27, 2010 at 8:20 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Jul 27, 2010 at 08:03:25PM +0200, Bart Van Assche wrote:
>
>> As far as I know it is not possible for a HCA to tell whether or not a
>> CPU has finished executing the interrupt it triggered. So it is not
>> possible for the HCA to implement the above requirement by delaying
>> the generation of a new interrupt -- implementing the above
>
> Linux does not allow interrupts to re-enter.. Read through
> kernel/irq/chip.c handle_edge_irq to get a sense of how that is done
> for MSI. Looked to me like all the CQ call backs flowed from the
> interrupt handler in mlx4?

The above implies that one must be careful when applying a common
Linux practice, that is to defer interrupt handling from IRQ context
to tasklet context. Since tasklets are executed with interrupts
enabled, invoking ib_req_notify_cq(cq, IB_CQ_NEXT_COMP) from tasklet
context may cause concurrent execution of an IB IRQ with an IB
tasklet. So if ib_poll_cq() is invoked from tasklet context, the
entire polling loop has to be protected against concurrent execution.
As far as I know such protection against concurrent execution is not
necessary inside tasklets that handle other types of hardware.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
