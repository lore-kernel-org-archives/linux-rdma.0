From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: creating common ib_types.h for linux and windows
Date: Sun, 25 Sep 2011 13:39:29 +0300
Message-ID: <20110925103929.GB2372@calypso.mtl.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E65191@ORSMSX101.amr.corp.intel.com>
 <CAO+b5-p0O5N6ZZacYGNjz4+H=W3hX6O7kw5pO=XqXSdh3FEdhA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6526F@ORSMSX101.amr.corp.intel.com>
 <20110921132945.GA3767@calypso.mtl.com>
 <1828884A29C6694DAF28B7E6B8A8237316E66732@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E66732-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:49 Wed 21 Sep     , Hefty, Sean wrote:
> > What is your end goal? To have one code base for OpenSM that would be able to
> > be compiled on both Linux and Windows based on __WIN__ definition?
> 
> My end goal is to decrease the maintenance cost porting opensm to Windows.  Ideally, I'd like to have a common code base for opensm, similar to what we have for ibmad and ib-diags.  Whether we achieve that using #ifdef's, OS specific header files, some other means (such as a windows specific patches to complete the conversion), or a combination of these, I don't really care.

I guess in case of ib_types.h that includes lots of #ifdef's, it would be
better to use a separate file. But for other files such as osm_base.h, it
would be much overhead to separate Windows related stuff to a different file.

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
