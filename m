From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Work completions generated after a queue pair has made the
 transition to an error state
Date: Wed, 13 Oct 2010 14:37:04 +0200
Message-ID: <AANLkTikTqs3NoUiOXcQn+ACxRnHNdbDmQvtafxtfK5H9@mail.gmail.com>
References: <AANLkTimcxsymqmzoki=quCH+a2sq_fPb4YOmf3gqrzqh@mail.gmail.com>
	<1286909435.27343.93.camel@chromite.mv.qlogic.com>
	<AANLkTi=72Y+coH1Ke4U-Xk7Eaqpw5pipWRqXEQr7dOau@mail.gmail.com>
	<20101012202221.GD1617@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101012202221.GD1617@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

libmlx4 does not report the opcode of the operation if it completed
with error. We will fix this and post a patch for review.

On Tue, Oct 12, 2010 at 10:22 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wr=
ote:
> On Tue, Oct 12, 2010 at 08:58:59PM +0200, Bart Van Assche wrote:
>> On Tue, Oct 12, 2010 at 8:50 PM, Ralph Campbell
>> <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Tue, 2010-10-12 at 11:38 -0700, Bart Van Assche wrote:
>> >> Hello,
>> >>
>> >> Has anyone already tried to process the work completions generate=
d by
>> >> a HCA after the state of a queue pair has been changed to IB_QPS_=
ERR ?
>> >> With the hardware/firmware/driver combination I have tested I hav=
e
>> >> observed the following:
>> >> * Multiple completions with the same wr_id and nonzero (error) st=
atus
>> >> were received by the application, while all work requests queued =
with
>> >> the flag IB_SEND_SIGNALED had a unique wr_id.
> I assume your QP is configured for selective signalling, right? This
> means that for succcessful processing of the work request there will
> not be =A0any completion. But for unsuccessful WR, the hardware shoul=
d
> generate a completion. For these casese it is worth having a
> meaningfull wrid.
>> >> * Completions with non-zero (error) status and a wr_id / opcode
>> >> combination were received that were never queued by the applicati=
on.
> In case of error the opcode of the completed operation is not provide=
d.
> I am not sure why.
>
>> >> Note: some work requests were queued with and some without the fl=
ag
>> >> IB_SEND_SIGNALED. I'm not sure however whether that has anything =
to do
>> >> with the observed behavior.
> If you have WRs for which you did not set IB_SEND_SIGNALED, they are
> not considered completed before a comletion entry is pushed to the CQ
> that correspnds to that send queue. I am not sure if it means that al=
l
> the WR in the send queue should be completed with error.
>> >>
>> >> This behavior is easy to reproduce. If I interpret the InfiniBand
>> >> Architecture Specification correctly, this behavior is non-compli=
ant.
>> >>
>> >> Has anyone been looking into this before ?
>> >
>> > I haven't seen it. It isn't supposed to happen.
>> >
>> > What hardware and software are you using and how do you
>> > reproduce it?
>>
>> Hello Ralph and Or,
>>
>> The way I reproduce that behavior is by modifying the state of a que=
ue
>> pair into IB_QPS_ERR while RDMA is ongoing. The application, which i=
s
>> multithreaded, performs RDMA by calling ib_post_recv() and
>> ib_post_send() (opcodes IB_WR_SEND, IB_WR_RDMA_READ and
>> IB_WR_RDMA_WRITE). This has been observed with the mlx4 driver, a
>> ConnectX HCA and firmware version 2.7.0.
>>
>> Bart.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
