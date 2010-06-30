From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: librdmacm 1.0.12: message size constrain?
Date: Wed, 30 Jun 2010 12:29:00 +0200 (CEST)
Message-ID: <185859.1277893740389.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE5D5@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_286_3218297.1277893740388"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE5D5-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

------=_Part_286_3218297.1277893740388
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Jun 08, 2010 08:58 PM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Here is the first cut at release notes -- attached and inline -- for
> the OFED 1.5.2 release of the librdmacm.
> 
> - Sean
> 
> ---
> 
> librdmacm release notes
> -----------------------
> Several enhancements were added to librdmacm release 1.0.12 that
> are intended to simplify using RDMA devices and address scalability
> issues.
> These changes were in response to long standing requests to make
> connection establishment 'more like sockets'.  For full details,
> users should refer to the appropriate man pages. Major changes
> include:
> 
> 
> * Support synchronous operation for library calls.  Users can control
> whether an rdma_cm_id operates asynchronously or synchronously based
>   on
>   the rdma_event_channel parameter.  Use of synchronous operations
>   reduces the amount of application code required to use the librdmacm
>   by eliminating the need for event processing code.
> 
>   An rdma_cm_id will be marked for synchronous operation if the
>   rdma_event_channel parameter is NULL for rdma_create_id or
>   rdma_migrate_id.  Users can toggle between synchronous and
>   asynchronous operation through the rdma_migrate_id call.
> 
>   Calls that operate synchronously include rdma_resolve_addr,
>   rdma_resolve_route, rdma_connect, rdma_accept, and rdma_get_request.
>   Synchronous event data is returned to the user through the
>   rdma_cm_id.
> 
> 
> * The addition of a new API: rdma_getaddrinfo.  This call is modeled
>   after getaddrinfo, but for RDMA devices and connections.  It has the
>   following notable deviations from getaddrinfo:
> 
>   A source address is returned as part of the call to allow the
>   user to allocate necessary local HW resources for connections.
> 
>   Optional routing information may be returned to support
>   Infiniband fabrics.  IB routing information includes necessary
>   path record data.  rdma_getaddrinfo will obtain this information
>   if IB ACM support (see below) is enabled.  The use of IB ACM
>   is not required for rdma_getaddrinfo.
> 
>   rdma_getaddrinfo provides future extensions to support
>   more complex address and route resolution mechanisms, such as
>   multiple path support and failover.
> 
> 
> * Support for a new APIs: rdma_get_request, rdma_create_ep, and
>   rdma_destroy_ep.  rdma_get_request simplifies the passive side
>   implementation by adding synchronous support for accepting new
>   connections.  rdma_create_ep combines the functionality of
> rdma_create_id, rdma_create_qp, rdma_resolve_addr, and
>   rdma_resolve_route
> in a single API that uses the output of rdma_getaddrinfo as its input.
> 
>   
> * Support for optional parameters. To simplify support for casual RDMA
>   developers and researchers, the librdmacm can allocate protection
>   domains, completion queues, and queue pairs on a user's behalf.
>   This simplifies the amount of information that a developer
>   must learn in order to use RDMA, plus allows the user to take
>   advantage of higher-level completion processing abstractions.
> 
>   In addition to optional parameters, a user can also specify that the
>   librdmacm should automatically select usable values for RDMA read
>   operations.
> 
> 
> * Add support for IB ACM. IB ACM (InfiniBand Assistant for
> Communication
> Management) defines a socket based protocol to an IB address and route
>   resolution service.  One implementation of that service is provided
> separately by the ibacm package, but anyone can implement the service
> provided that they adhere to the IB ACM socket protocol. IB ACM is an
> experimental service targeted at increasing the scalability of
>   applications
>   running on a large cluster.
>   
> Use of IB ACM is not required and is controlled through the build
>   option
> '--with-ib_acm'. If the librdmacm fails to contact the IB ACM service,
>   it
> reverts to using kernel services to resolve address and routing data.
> 
> 
> * Add RDMA helper routines. The librdmacm provide a set of simpler
> verbs
> calls for posting work requests, registering memory, and checking for
>   completions.  These calls are wrappers around libibverbs routines.
> 
> 
> 
Hi Sean,

I use the librdmacm version 1.0.12
I write a test code from your example. It works fine if message buffer
size (BUF_SIZE) is smaller than 64 bytes.
Is there some constrain? 

I would like to use your new synchronous APIs -
rdma_reg_msgs,rdma_post_recv,rdma_post_send - with 1 byte < message size
< 4 Mbytes in my test.

Thank you very much for your help.
Regards,
Andrea


Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2 -I-35020 - Legnaro (PD)- ITALIA
Office: E-101
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org
Cell: +39 3488245552				

------=_Part_286_3218297.1277893740388
Content-Type: text/x-vcard
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="Andrea Gozzelino.vcf"

BEGIN:VCARD
VERSION:2.1
N:Gozzelino;Andrea;;
FN:Andrea Gozzelino
ORG:INFN - Laboratori Nazionali Legnaro;
NOTE:
TEL;WORK;VOICE:0039 0498068346
TEL;CELL;VOICE:
TEL;PAGER;VOICE:
TEL;WORK;FAX:
ADR;WORK:;;;legnaro;;;IT
LABEL;WORK;ENCODING=QUOTED-PRINTABLE:=0D=0Alegnaro,  =0D=0AD
URL;WORK:
EMAIL;PREF;INTERNET:Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org
MAILER:SuSE Linux Openexchange Server 4
END:VCARD 

------=_Part_286_3218297.1277893740388--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
