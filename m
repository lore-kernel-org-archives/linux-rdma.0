From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: creating common ib_types.h for linux and windows
Date: Tue, 20 Sep 2011 08:06:43 +0200
Message-ID: <CAO+b5-p0O5N6ZZacYGNjz4+H=W3hX6O7kw5pO=XqXSdh3FEdhA@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E65191@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E65191-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Alex Netes (alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 19, 2011 at 11:20 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
> It would be easier to maintain opensm on windows if it truly shared t=
he same code base. =A0For now, I'd just like to start with a common ib_=
types.h file. =A0(There are currently hundreds, if not thousands, of li=
nes that differ.) =A0ib_types.h uses #if defined(__WIN__) to separate l=
inux from windows code. =A0This isn't actually used, since separate fil=
es are maintained anyway.
>
> My question is whether we should continue to use #if defined(__WIN__)=
 or add a new ib_types_osd.h file. =A0Any preferences from the opensm m=
aintainer side?

Why to test for __WIN__ instead of _WIN32 (defined both when building
32-bit and 64-bit code -- see also
http://msdn.microsoft.com/en-us/library/b0084kay%28v=3Dvs.80%29.aspx) ?

When creating a common header file, this might be a good start:
https://msinttypes.googlecode.com/svn/trunk/stdint.h

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
