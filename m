From: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: better understanding rdma-cm UNREACHABLE/ETIMEDOUT scheme
Date: Sun, 26 May 2013 17:46:26 +0300
Message-ID: <51A22042.5010205@mellanox.com>
References: <519B8DB3.3010500@mellanox.com> <1828884A29C6694DAF28B7E6B8A823736FD29AE3@ORSMSX109.amr.corp.intel.com> <519DF00C.9010304@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519DF00C.9010304-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dina Leventol <dinal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/23/2013 1:31 PM, Alex Rosenbaum wrote:
> On 5/21/2013 6:24 PM, Hefty, Sean wrote:
>> My first guess is that the server isn't responding to new requests. - 
>> Sean 
>
> This is where we're looking now.
> Now testing on 17 server with 8 clients per server.
>
> When disabling all RDMA traffic in the test we get 100% RDMA 
> connection established. So at least we know this is not some 
> fundamental issue with our setup.
>
> Modifying our code to increasing the priority of RDMA connection 
> handling to be higher then the RDMA traffic (CQ completions handling) 
> we still see many UNREACHABLE events. But only after quite a few 
> client got connected and started pushing traffic (1GB RDMA WRITEs from 
> server to client).
>
> We are now adding code (via the conn_attr private data) to compare 
> timestamp between the rdma_conenct, RDMA_CM_EV_CONNECT_REQ, 
> rdma_accept and on the client events of UNREACHABLE or CONNECTED.
> We'll have better understand once we see these results.
>
> thanks,
>
> Alex
We found the peace of code that got the server to hang for so long, 
enough to causes the rdma_connect() to fail on the client side with 
retries with RDMA_CM_EVENT_UNREACHABLE(-TIMEDOUT)
OK, case closed.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
