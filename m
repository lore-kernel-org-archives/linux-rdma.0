From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [RFC] RDMA CM + XRC, take two
Date: Wed, 11 May 2011 09:42:15 -0500
Message-ID: <4DCAA047.2040904@systemfabricworks.com>
References: <4DC86BB2.1020002@systemfabricworks.com> <1828884A29C6694DAF28B7E6B8A82373BBE2@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373BBE2-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Sean,

On 05/10/2011 06:17 PM, Hefty, Sean wrote:
>> This is an improved version of my previous patch to add XRC support to
>> RDMA CM.
> 
> I would still like to see support merged upstream and into mainline libibverbs before applying this to my tree.

Agreed. 

>  
>> This version now support the newer rdma CM interface. It needs some
>> polishing but it works.
> 
> It's hard to comment on the patch as an attachment.  In several places, if/else statements were added, but indentation was not added to the opposite part of the statement.  There was also a rather large amount of code added to rdma_create_qp() that needs to be split into a separate function.  (I dislike functions longer than a screen.)

Sorry for that attachment. I tried several time to post inline patches but was always getting a mangled patch.
I'll address you comments in a new patch.

>  
>> It modifies the rdma_client/server examples to use xrc instead of rc.
>>
>> The big hack is that the SRQ number needs to be transmitted to the remote
>> side. This patch hijacks the private data, so it's not acceptable. Ideally the SRQ
>> number should be transmitted either in the REQ or REP packet (depending
>> on which side the sender or the receiver) alongside the QP number. But that
>> would need a change in the specs. Any suggestions ?
> 
> What are the QPNs carried in the REQ and REP?

Those for the XRC QPs. Same as a for regular RC connection.

Frank.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
