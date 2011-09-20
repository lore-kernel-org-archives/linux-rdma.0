From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: creating common ib_types.h for linux and windows
Date: Tue, 20 Sep 2011 14:23:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E6526F@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E65191@ORSMSX101.amr.corp.intel.com>
 <CAO+b5-p0O5N6ZZacYGNjz4+H=W3hX6O7kw5pO=XqXSdh3FEdhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-p0O5N6ZZacYGNjz4+H=W3hX6O7kw5pO=XqXSdh3FEdhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Alex Netes (alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Why to test for __WIN__ instead of _WIN32 (defined both when building
> 32-bit and 64-bit code -- see also
> http://msdn.microsoft.com/en-us/library/b0084kay%28v=vs.80%29.aspx) ?

I have no idea.  This is just what's currently in the code.  I can change this portion of the code if we want to use #ifdef's.

> When creating a common header file, this might be a good start:
> https://msinttypes.googlecode.com/svn/trunk/stdint.h

There are already shared types defined between linux and windows that opensm uses.  For the most part, there's no technical reason why windows can't use 99% of the linux ib_types.h as is.  My goal is to be able to take the file and drop it into the windows build tree without needing changes.

Btw, as background I tried to pull in the latest ibmad and ibdiags into windows.  The build broke because of new defines that had been added to ib_types.h.  Eventually we should be able to drop opensm directly into the windows build as well.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
