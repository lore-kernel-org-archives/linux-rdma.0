From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Building 3.1-rc9 in kernel infiniband support with OFED libraries
Date: Mon, 17 Oct 2011 10:11:19 -0700
Message-ID: <CABgxfbGTSh-KWH=Vq9SkJwG4o=L5kDc5SvSxspr919fCC9aLcg@mail.gmail.com>
References: <CAL1RGDUrkE4Ue_a=Aj77x-i0gN=c_Whn3ngVsQCaneqzEstK1g@mail.gmail.com>
	<c4c32eb7-babb-4cd0-8670-0ef4c1d425df@zmail05.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c4c32eb7-babb-4cd0-8670-0ef4c1d425df-rwXUz/BPrj9+R5eDjrG6zsCp5Q1pQRjfhaY/URYTgi6ny3qCrzbmXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2011 at 2:22 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> ----- Original Message -----
>> On Wed, Oct 12, 2011 at 9:32 AM, Wendy Cheng
>> <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > The OFED package itself does include XRC support. The issue here
>> > (my
>> > guess) is that its build script needs to understand the running
>> > system's kernel version to decide what should be pulled (from the
>> > source). Linux 3.1 could be too new for OFED build script to make =
a
>> > correct decision. Nevertheless, mix-matching OFED modules/librarie=
s
>> > is
>> > a *bad* idea.
>>
>> No. =A0The same userspace build should work with all kernel versions=
=2E
>
> Wendy's referring to something other than what you are thinking. =A0T=
he
> same libibverbs user space build should work on all kernels going bac=
k
> a long way, except when you are talking about OFED their libibverbs
> is hard coded to assume XRC support and fail if it isn't present, so
> an OFED libibverbs won't really work without also the OFED kernel
> module stack. =A0The script Wendy referred to is the script that chec=
ks
> the running kernel's version in order to determine which backport
> patches need applied to the ofa_kernel source tree in order to build
> the OFED kernel modules for your running kernel. =A0Without that
> ofa_kernel build, the OFED libibverbs will indeed fail to run on
> the running kernel. =A0And that script hasn't been updated to support
> version 3.x kernels last I checked, so she's right, the script itself
> doesn't recognize the running kernel version, so ofa_kernel modules
> don't get built, so OFED libibverbs won't work anyway. =A0So, she's
> absolutely right, unless you want to start ripping hard coded
> assumptions about the existence of XRC support out of things like
> OFED's libibverbs, then out of qperf and a number of their other
> various packages, then you have to pair the OFED kernel modules and
> user space packages, they can not be separated.
>

Yes, that (above) is exactly what I was referring to .....

The conversations in this thread remind me of the tire-swing cartoon
that has been passing around for years:
http://bibiananunes.com/user-requirements-the-tire-swing-cartoon )


-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
