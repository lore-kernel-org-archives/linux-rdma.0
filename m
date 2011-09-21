From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: creating common ib_types.h for linux and windows
Date: Wed, 21 Sep 2011 14:15:31 +0000
Message-ID: <2DDE0F15AAFF91448E6F813C42EF4CBE16E67ABF@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E65191@ORSMSX101.amr.corp.intel.com>
 <CAO+b5-p0O5N6ZZacYGNjz4+H=W3hX6O7kw5pO=XqXSdh3FEdhA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6526F@ORSMSX101.amr.corp.intel.com>
 <20110921132945.GA3767@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110921132945.GA3767-iQai9MGU/dze+A/uUDamNg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>-----Original Message-----
>From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Alex Netes
>Sent: Wednesday, September 21, 2011 6:30 AM
>To: Hefty, Sean
>Cc: Bart Van Assche; linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org); Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org); ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>Subject: Re: creating common ib_types.h for linux and windows
>
>On 14:23 Tue 20 Sep     , Hefty, Sean wrote:
>> > Why to test for __WIN__ instead of _WIN32 (defined both when building
>> > 32-bit and 64-bit code -- see also
>> > http://msdn.microsoft.com/en-us/library/b0084kay%28v=vs.80%29.aspx) ?
>>
>> I have no idea.  This is just what's currently in the code.  I can change this portion of the code if we want to use #ifdef's.
>>
>
>Digging into the history, I found this patch that added __WIN__ defined for
>Windows: http://www.spinics.net/lists/linux-rdma/msg00451.html

Hello Alex,
  The intent was to unify the multiple ifdef tags for Windows; perhaps _WIN32 might have been a better choice.
__WIN__ clearly indicates 'all' windows variants, while _WIN32 at 1st glance tends to imply 32bit Windows for those who are not aware of the MS confusing usage of _WIN32 also defined  for _WIN64 systems.
If you feel a change is needed then OK.

Stan.

>
>> > When creating a common header file, this might be a good start:
>> > https://msinttypes.googlecode.com/svn/trunk/stdint.h
>>
>> There are already shared types defined between linux and windows that opensm uses.  For the most part, there's no technical reason why
>windows can't use 99% of the linux ib_types.h as is.  My goal is to be able to take the file and drop it into the windows build tree without
>needing changes.
>
>What is your end goal? To have one code base for OpenSM that would be able to
>be compiled on both Linux and Windows based on __WIN__ definition?
>
>>
>> Btw, as background I tried to pull in the latest ibmad and ibdiags into windows.  The build broke because of new defines that had been
>added to ib_types.h.  Eventually we should be able to drop opensm directly into the windows build as well.
>>
>> - Sean
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>--
>
>-- Alex
>--
>To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
