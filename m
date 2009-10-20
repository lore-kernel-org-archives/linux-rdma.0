From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 20 Oct 2009 13:48:34 -0700
Message-ID: <B7BCBF813BF447B28330C2DB8F1437D6@amr.corp.intel.com>
References: <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com> <4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com> <20091020183132.GE14520@obsidianresearch.com> <A47D2FC6B143436DB87704307B0E715D@amr.corp.intel.com> <20091020191821.GI14520@obsidianresearch.com> <8D09997BDBC5482C86EAD338F19C8030@amr.corp.intel.com> <20091020202902.GJ14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091020202902.GJ14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Private data:
>- AF_IB/PS_TCP - the kernel munges the private data to be compatible
>  with AF_INET/PS_TCP, but otherwise is the same.
>- AF_IB/PS_IB - the kernel doesn't touch the private data.

I was thinking AF_IB/* - kernel doesn't touch the private data, as it lacks the
necessary information.

>What about the service_mask feature of IB CM?

not sure - Is it needed in user space?

>How are the IP source and dest IPs going to be picked in for PS_TCP
>mode?
>
>I guess user space does that and passes it through to the kernel?

It could pass the private data when calling rdma_connect.

>I think it would be fine to EINVAL on AF_IB/PS_TCP listen().

I'm good with that, but want to give this some thought.

>Oh I see, well, a 'bind' api into the IB CM should take care of that?

I think so.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
