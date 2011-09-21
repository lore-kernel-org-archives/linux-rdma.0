From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: creating common ib_types.h for linux and windows
Date: Wed, 21 Sep 2011 15:49:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E66732@ORSMSX101.amr.corp.intel.com>
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
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> What is your end goal? To have one code base for OpenSM that would be able to
> be compiled on both Linux and Windows based on __WIN__ definition?

My end goal is to decrease the maintenance cost porting opensm to Windows.  Ideally, I'd like to have a common code base for opensm, similar to what we have for ibmad and ib-diags.  Whether we achieve that using #ifdef's, OS specific header files, some other means (such as a windows specific patches to complete the conversion), or a combination of these, I don't really care.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
