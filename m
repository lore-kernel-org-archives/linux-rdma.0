From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp sg_tablesize
Date: Sat, 21 Aug 2010 13:14:14 +0200
Message-ID: <AANLkTimMoyEpfYPFSLLqS9ZCg3VyyOQcd4i2zzCQjHMN@mail.gmail.com>
References: <201008200949.54595.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201008200949.54595.bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Cc: general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernd Schubert <bschubert-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 20, 2010 at 9:49 AM, Bernd Schubert
<bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org> wrote:
>
> In ib_srp.c sg_tablesize is defined as 255. With that value we see lots of IO
> requests of size 1020. As I already wrote on linux-scsi, that is really sub-
> optimal for DDN storage, as lots of IO requests of size 1020 come up.
>
> Now the question is if we can safely increase it. Is there somewhere a
> definition what is the real hardware supported size? And shouldn't we increase
> sg_tablesize, but also set the .dma_boundary value?

(resending as plain text)

The request size of 1020 indicates that there are less than 60 data
buffer descriptors in the SRP_CMD request. So you are probably hitting
another limit than srp_sg_tablesize.

Did this occur with buffered (asynchronous) or unbuffered (direct) I/O
? And in the first case, which I/O scheduler did you use ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
