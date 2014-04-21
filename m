From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Tue, 22 Apr 2014 00:10:55 +0300
Message-ID: <CAJZOPZ+FwPc3OSVyvk0i4=gX-x0zf_+M8zL1_t9HWmEKi5397Q@mail.gmail.com>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org>
	<CAJZOPZJfdaZ7QzgffzY9Ps-1aUCU+q_dSrj4XfekyfxNa-k+hg@mail.gmail.com>
	<alpine.DEB.2.10.1404211605390.29907@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1404211605390.29907-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 22, 2014 at 12:06 AM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, 21 Apr 2014, Or Gerlitz wrote:
>
>> > Currently, there's no way for user-space applications to specify
>> > the IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK QP creation flags
>> > defined by commit 47ee1b9 "IB/core: Add support for multicast loopback blocking".
>> > As a result, applications who send and recieve on the same QP over
>> > the same multicast group get all their packets bouncded back to them,
>> > which is bad..
>>
>> Hi Christoph, I do see your P&F (Pain and Frustration), however, this
>> patch was only meant to be bandaid (*) for the fact that whole ~six
>> years elapsed since a basically proper patch that does the task was
>> posted http://lists.openfabrics.org/pipermail/general/2008-July/053021.html
>> and we still don't have uverbs support for QP creation flags!!
>>
>> Roland, how you prefer to move on here? we can come up with quick
>> patch that just uses the reserved field of struct ib_uverbs_create_qp
>> and would allow to support upto 8 creation flags, this would not
>> require new uverbs command, OK?
>
> Urgh. So we have all these flags and we cannot use them?

Christoph, the support (kernel IB core API and HW drivers e.g mlx4 and
now also mlx5) is there for **kernel** consumers (e.g IPoIB). and
missing for **user-space** consumers whose calls are tunneled through
uverbs. The uverbs piece is the missing one.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
