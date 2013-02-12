From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: interest in single core rdma library
Date: Tue, 12 Feb 2013 22:30:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237368B9A190@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237368B99DB4@ORSMSX101.amr.corp.intel.com>
 <20130212202953.GH1471@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130212202953.GH1471-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > The intent would be to construct a single library containing the
> > core functionality -- data transfers, connection establishment, and
> > subnet management -- required by most applications.  It could target
> > combining libibverbs, librdmacm, and libibumad APIs.
> 
> If you are just going to combine all the existing APIs together, then
> I'd say no..

Thanks for the input.

I wasn't wanting to change the APIs (or require app changes to be more precise).  Adding or extending APIs is a possibility, but in the short term I'm more interested in reducing maintenance costs, while making things simpler for users.

I want to avoid dependency issues similar to defining struct ibv_path_record.  That structure was added to ibverbs, but because the rdmacm and ibverbs are separate packages with no coordination between releases, it was also added to the rdmacm.  Arguably, that definition should have been in ibumad, where it doesn't appear at all.

I haven't given this much thought - barely more than sending a query to the mail list.  At the end of the day, I'm really wanting to reduce the amount of work.  :)

> But there is so much code out there relying on the existing APIs??
> Plus things like DAPL and CCI trying to be a generic API for rdma.

I don't ever see these APIs covering IB management interfaces.

> You might want to look at my python-rdma's 'rdma module', which is a
> combined API for verbs and umad:
> 
> https://github.com/jgunthorpe/python-rdma
> 
> Where the unification mostly comprises using the same language/API for
> talking about paths, end ports, devices and errors.

I'll take a look, at least for future reference.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
