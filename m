From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Work completions generated after a queue pair has made the
 transition to an error state
Date: Wed, 13 Oct 2010 16:23:03 +0200
Message-ID: <20101013142303.GF1617@mtldesk30>
References: <AANLkTimcxsymqmzoki=quCH+a2sq_fPb4YOmf3gqrzqh@mail.gmail.com>
 <1286909435.27343.93.camel@chromite.mv.qlogic.com>
 <AANLkTi=72Y+coH1Ke4U-Xk7Eaqpw5pipWRqXEQr7dOau@mail.gmail.com>
 <20101012202221.GD1617@mtldesk30>
 <4CB5B94E.4080802@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CB5B94E.4080802-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 13, 2010 at 03:51:10PM +0200, Or Gerlitz wrote:
> Eli Cohen wrote:
> >Completions with non-zero (error) status and a wr_id / opcode
> >combination were received that were never queued by the
> >application.
> >In case of error the opcode of the completed operation is not provided. I am not sure why.
> Eli, there's nothing in the IB spec that mandates the WC.opcode of a
> non successful work request to be valid, the only WC fields that
> must be valid are the work-request ID (cookie) and the status code,
> I believe that hardware vendors would also make sure to have the
> vendor id valid...

Maybe I am misinterpreting the spec. Looking at volume 1.2.1 of the
spec, 11.4.2.1, it says:

"If the status of the operation that generates the Work Completion is
anything other than success, the contents of the Work Completion are
undefined except as noted below. The contents of a Work Completion
are:"

Then it lists the reported fileds with wrid first and the opcodes
following.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
