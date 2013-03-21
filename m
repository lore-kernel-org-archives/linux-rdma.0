From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all
 ports of HCA are connected]
Date: Thu, 21 Mar 2013 22:46:06 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510EBB4B49@CRSMSX102.amr.corp.intel.com>
References: <2807E5FD2F6FDA4886F6618EAC48510EBB4214@CRSMSX102.amr.corp.intel.com>
 <514A3169.7000501@oracle.com> <20130320222422.GA30100@obsidianresearch.com>
 <514A3BDF.2090105@oracle.com> <20130320231923.GA32300@obsidianresearch.com>
 <514A5C07.3080308@oracle.com> <20130321052122.GB20882@obsidianresearch.com>
 <514B6F74.9020707@oracle.com> <20130321212703.GA8431@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4AF5@CRSMSX102.amr.corp.intel.com>
 <20130321220751.GG8431@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130321220751.GG8431-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> 
> On Thu, Mar 21, 2013 at 09:58:09PM +0000, Weiny, Ira wrote:
> 
> > > Once you introduce an 'old' style return, you are going to start
> > > using it and then we are stuck with this inconsistency forever. Pick
> > > a direction and go there, consistently :)
> > >
> > > 'new' POSIX is *much* safer to use, you don't have the risk of
> > > library code stomping errno, particularly during error unwind.
> >
> > I really don't see how the new POSIX model prevents libraries from
> stomping errno?
> 
> Most errors are returned as +ERRNO via 'int' so errno is not involved, this is
> the common case.
> 
> The uncommon case degrades into the 'old' errno case, which people
> theoretically know how to program for. At the very least it works often
> enough for application writers.
> 
> People working on library code have to be aware of proper errno use, and
> the cavets. This is true of all the IB libraries.

Ok, not counting simple *2str, dump functions and other "simple" calls, and removing the deprecated calls.

There are

19 calls which return a pointer
17 calls which return int

Of those returning int

Ib_path_query_via returns the dlid on success
mad_register_server_via returns the agent id on success
mad_register_client_via returns the agent id on success
mad_register_port_client returns the agent id on success
mad_rpc_class_agent returns the agent on success
mad_build_pkt returns the length of the packet built on success
mad_print_field returns the length of the string printed on success

That leaves 10 calls which return int and could be "fixed" by returning +ERRNO.

Converting to the new POSIX errno fixes only 27% of the library calls and degrades the rest of them to use the old POSIX's errno handling which  is broken...  :-(  And breaks those users who currently expect those calls to return -1 (or at least <0) on error.  I'm not saying this is bad but it is not a complete solution and shows just how messed up this library is.

> 
> > I have a different idea.  I think the library should define a new call.
> >
> > int mad_get_error(const struct ibmad_port *srcport);
> >
> > This returns an errno compatible value which corresponds to the last
> > mad_* call.  Ibmad_port is opaque and we can add an error field
> 
> .. and now you have created a new, special, unfamiliar paradigm that doesn't
> avoid the main problems with errno, just reduces the scope, and breaks
> thread safety..
> 
> openssl did something very much like this, and I once went through a painful
> process to make sure that every call to openssl used the openssl error check
> idiom, and every C library call used the proper errno idiom, and so forth.
> Adding more error check idioms for application writers to follow isn't going to
> make their job easier or create more correct code.

I agree.  But the only correct solution here is to throw out libibmad and start over.  I am not going to do that work.

Therefore, none of these solutions is good.  At least with my proposed solution the semantics would be the same for every call.  I am sorry that each library is different and application users may have to follow different idioms.  However having 2 or 3 in the same library is even worse!!!

<sigh> Brandon, if you want to convert the said 10 calls to return +ERRNO on failure I'll accept such a patch.  I really don't have time to implement my solution anyway.

Be aware that I am removing the DEPRECATED calls as we speak.  At least that will clean up some of this library.

Ira

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
