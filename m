From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Notes on XRC
Date: Mon, 25 Mar 2013 11:32:01 +0200
Message-ID: <51501991.5020105@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I'm experimenting XRC with a real application and I want to share my 
thoughts.

A natural way to pass the SRQ's QPN is to use the "private_data" of the 
"rdma_conn_param", however this area is limited to 56 octets and since 
each QPN occupies 3 octets that leaves us with 18 SRQ. I suggest to 
increase the size of the private data, or to find a more convenient way 
to pass the SRQ's QPM, one that doesn't use extra ports or out-of-band 
communication (socket).

Another issue is of backwards compatibility of applications.  Assume an 
application uses a well known port, and want to allow both new XRC 
enabled clients and old RC clients. It seems that this is possible using 
the "rdma_create_ep" API with appropriate "rdma_addrinfo" one that 
"rdma_getaddrinfo" resolved with QP type "IBV_QPT_XRC_RECV" and one with 
"IBV_QPT_RC" one the same port (I hope this is allowed). A client on the 
other side will first try to connect to the XRC and if it fails will 
fall-back to RC.

However, a server usually uses "rdma_create_id" to associate an event 
handler with an id and then bind the id to an address, and accept 
connection requests asynchronously, but with these API, AFAIK there is 
no way to pass the required hints.

I assume I can use the "private_data" of the "rdma_conn_param" to 
distinguish between XRC enabled clients and servers and old ones, but it 
doesn't seems clean, as it is implicit and not explicit.

Best regards,

S.P.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
