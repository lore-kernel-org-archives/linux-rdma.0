From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Wed, 11 Aug 2010 17:58:33 -0500
Message-ID: <4C632B19.9090109@systemfabricworks.com>
References: <4C5331DC.9080109@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com> <4C618334.7010106@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com> <20100810171405.GM11306@obsidianresearch.com> <4C61BF26.9060003@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601BE4@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601BE4-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/11/2010 05:22 PM, Hefty, Sean wrote:
>> - The server side of the connection also needs an SRQ. It's not 
>> obvious whether it's the application or rdma cm to create that SRQ.
>> And that SRQ number must be given to the client side, presumably in
>> the private data.
> 
> The desired mapping of XRC to the librdmacm isn't clear to me.  For 
> example, after 'connecting' is two-way communication possible 
> (setting up INI/TGT pairs on both nodes), or is a connection only 
> one-way (setup local INI to remote TGT)?  Also, as you point out, how
> are SRQ values exchanged?  Does private data carry one SRQ value, all
> SRQ values for remote processes, none?

XRC is one way. There is a send QP (which looks like a regular RC QP),
and a receive QP. Logically, the listen side would create an XRC receive QP,
and for each incoming connection would create/attach an SRQ to it. But the
initiator would have to know the SRQ number to be able to send data, and
the easiest way to pass that informations is in the CM REP private data.

I think one way to see is that you connect a QP on one side to an SRQs 
on the other side. In case of XRC, rdma_get_request() could create that SRQ
instead of a QP. 

Frank.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
