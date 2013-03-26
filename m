From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Notes on XRC
Date: Tue, 26 Mar 2013 11:59:38 +0200
Message-ID: <5151718A.6090907@mellanox.com>
References: <51501991.5020105@mellanox.com> <1828884A29C6694DAF28B7E6B8A823736F367A8A@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F367A8A-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/25/2013 6:27 PM, Hefty, Sean wrote:
>> A natural way to pass the SRQ's QPN is to use the "private_data" of the
>> "rdma_conn_param", however this area is limited to 56 octets and since
>> each QPN occupies 3 octets that leaves us with 18 SRQ. I suggest to
>> increase the size of the private data, or to find a more convenient way
>> to pass the SRQ's QPM, one that doesn't use extra ports or out-of-band
>> communication (socket).
> This is an issue for the IBTA to deal with and requires increasing the size of a MAD.
I see, I guess this will an obstacle.
>   
>> Another issue is of backwards compatibility of applications.  Assume an
>> application uses a well known port, and want to allow both new XRC
>> enabled clients and old RC clients. It seems that this is possible using
>> the "rdma_create_ep" API with appropriate "rdma_addrinfo" one that
>> "rdma_getaddrinfo" resolved with QP type "IBV_QPT_XRC_RECV" and one with
>> "IBV_QPT_RC" one the same port (I hope this is allowed). A client on the
>> other side will first try to connect to the XRC and if it fails will
>> fall-back to RC.
> The intent behind rdma_getaddrinfo is to allow multiple QP types to be returned based on user input.
So it is O.K. to have both XRC and RC QPs with conjunction to
>   
>> However, a server usually uses "rdma_create_id" to associate an event
>> handler with an id and then bind the id to an address, and accept
>> connection requests asynchronously, but with these API, AFAIK there is
>> no way to pass the required hints.
> Correct - the older rdma cm APIs are not as flexible.  That's why new APIs ended up being added.
Can you tell me which new API will give me the ability to use both 
address hints and asynchronous connection requests handling.
>   
>> I assume I can use the "private_data" of the "rdma_conn_param" to
>> distinguish between XRC enabled clients and servers and old ones, but it
>> doesn't seems clean, as it is implicit and not explicit.
> I don't think I'm fully following your private data idea.
This is just a workaround I been considering in case using "hints" and 
asynchronous connection request can't work together. If I want to have 
servers and clients that need to be backward compatible with RC servers 
and clients. And assuming the old ones didn't used the private data in 
the connection request and in the accept. Than the presence of the 
private data will indicated that these are XRC enabled clients and servers.

S.P
> - Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
