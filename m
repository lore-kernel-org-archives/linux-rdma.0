From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Tue, 10 Aug 2010 16:05:42 -0500
Message-ID: <4C61BF26.9060003@systemfabricworks.com>
References: <4C5331DC.9080109@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com> <4C618334.7010106@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com> <20100810171405.GM11306@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100810171405.GM11306-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/10/2010 12:14 PM, Jason Gunthorpe wrote:
> On Tue, Aug 10, 2010 at 09:59:50AM -0700, Hefty, Sean wrote:
> 
>>> The general parameters would be the same as for RC. Should we create a new
>>> ai_flag ? or a new port space ?
>>
>> There's a ai_qp_type field available.  I think the RDMA TCP port
>> space would work.
> 
> Not sure the port space matters at all?
> 
> Is there anything additional CM information for XRC other than
> requesting an XRC QP type? (XRCSRQ or something?)
> 
>>> Is it really necessary to support rdma_getaddrinfo, rdma_create_ep and the
>>> new APIs ?
>>
>> I think so, yes.  At least XRC needs to be handled, even if some of
>> the calls just fail as unsupported.
> 
> I'd like to see a strong rational for leaving any of the new API
> unsupported for XRC - IMHO it should all be doable. The new API is
> supposed to be simplifying, we want people to use it..

It seems the new API has too many constraints for XRC. There are a couple things that don't fit:

- XRC needs a domain, which must be created before creating the QP, but after we know 
  the device to use. In addition it also needs a file descriptor. The application may 
  want to use a different fd depending on the device. Currently the domain can only 
  be created in the middle of rdma_create_ep().

- The server side of the connection also needs an SRQ. It's not obvious whether it's
  the application or rdma cm to create that SRQ. And that SRQ number must be
  given to the client side, presumably in the private data.

Frank.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
