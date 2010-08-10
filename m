From: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: yet again the atomic operations
Date: Tue, 10 Aug 2010 13:50:52 +0200
Message-ID: <AANLkTikU1xdKfXK7C-sw1C+pv5L1hAdc0EL4Ed_ngi3=@mail.gmail.com>
References: <AANLkTikQX+CKvs_pjkH_Ap358jfjp4dYKYyKG95+eZmt@mail.gmail.com>
	<1281033688.7414.30.camel@chromite.mv.qlogic.com>
	<AANLkTimVTjHOubAaJ5oRHju6C7k7FZMqqq0Mvb4SBztB@mail.gmail.com>
	<adaocdf2137.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaocdf2137.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> You can work around this by creating a loopback connection (ie an RC
> connection from the local HCA to itself) and post atomic operations to
> that QP instead of accessing the memory directly with the CPU.
>
Right but that's really slow, specially if you're implementing some
sort of synchronization scheme that happens really often.
Isn't it possible to do something such as interrupting the CPU and
have it do the operation? For an atomic operation (small data) maybe
the overhead is not that large?!

Cheers,
Rui
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
