From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH,RFC] nfsd: Make INET6 transport creation failure an informational
 message
Date: Fri, 02 Apr 2010 13:52:39 -0500
Message-ID: <4BB63CF7.7020905@opengridcomputing.com>
References: <4BB522CF.60503@opengridcomputing.com>	<4BB61F19.2000403@oracle.com> <adaljd57os6.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaljd57os6.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > > The write_ports code will fail both the INET4 and INET6 transport
>  > > creation if
>  > > the transport returns an error when PF_INET6 is specified. Some transports
>  > > that do not support INET6 return an error other than EAFNOSUPPORT.
>  > 
>  > That's the real bug.  Any reason the RDMA RPC transport can't return
>  > EAFNOSUPPORT in this case?
>
> I think Tom's changelog is misleading.
Yes, it should read "A transport may fail for some reason other than 
EAFNOSUPPORT."

>   The problem is that the RDMA
> transport actually does support IPv6, but it doesn't support the
> IPV6ONLY option yet.  So if NFS/RDMA binds to a port for IPv4, then the
> IPv6 bind fails because of the port collision.
>
>   

Should we fail INET4 if INET6 fails under any circumstances?

> Implementing the IPV6ONLY option for RDMA binding is probably not
> feasible for 2.6.34, so the best band-aid for now seems to be Tom's
> patch.
>
>  - R.
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
