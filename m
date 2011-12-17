From: Alex Merritt <merritt.alex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SDP Kernel Module Compilation
Date: Sat, 17 Dec 2011 17:24:18 -0500
Message-ID: <CADK3taJf0NF_9cg9L=GpGupWHSD64N=gZNrvnYE+VcXappDtDw@mail.gmail.com>
References: <CADK3ta+r4+nZ+p=SvDCL5KacOv94fuoKKA2=df2Gm=H8f67Oig@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237325661465@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237325661465-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 16, 2011 at 17:39, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote=
:
>> I'm running a non-RPM system and have installed most of the librarie=
s
>> and the kernel/modules from git repositories directly. My goal is to
>> run applications via SDP. The SDP library is installed, but I cannot
>> seem to find the kernel module anywhere. In Roland's kernel git
>> sources, there is no sdp directory in drivers/infiniband/ulp. Am I
>> missing something? Does the OFED package have it because the module =
is
>> compiled outside of the kernel sources?
>
> SDP has never been submitted for upstream inclusion. =C2=A0You must o=
btain it from an OFED package.

Thanks for letting me know, Sean. What is your opinion is on the
amount of effort required to merge the SDP module into Roland's tree?
Is it correct to assume the OFED installation applies certain patches
within ofa_kernel to existing kernel sources on the system and builds
the modules off of that? I'm going to guess I'd need to manually apply
one or more of them depending what is missing/changed in the kernel
sources.

I have the latest OFED and am using 3.0.0 in Roland's tree.

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
