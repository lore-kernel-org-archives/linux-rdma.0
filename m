From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 6 Oct 2009 18:20:05 -0700
Message-ID: <3F7D26D4BA1C46F18F2F87BDD7EB7F36@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <20091006200739.GP5191@obsidianresearch.com> <B266C10D3C26431E8FF5012420132452@amr.corp.intel.com> <20091006231720.GR5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091006231720.GR5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I'm not suggesting that you implement RMDA CM IP semantics in
>userspace using the IB CM, I'm suggesting you expose the IB CM GID
>semantics through the RDMA CM API exactly as they are. Your IBACM
>would then become an enhanced path resolution module to the RDMA CM,
>much like getaddrinfo is to socket()/bind()/connect().

There are 3 interfaces of interest here.  The librdmacm API, the rdma_ucm user
to kernel interface, and the rdma_cm interface.  These patches are looking to
change the rdma_ucm interface.  I want to avoid changing the API or behavior of
the librdmacm in a way that requires changes to existing applications in order
to run on larger clusters. 

Adding support for AF_GID at the librdmacm level is fine, but it doesn't help
existing apps.  Adding support for AF_GID at the rdma_ucm and rdma_cm interfaces
may help, provided that the behavior of librdmacm calls: rdma_resolve_addr,
rdma_bind_addr, rdma_resolve_route, and rdma_connect are maintained.  If you
have a specific idea on a better way to change the rdma_ucm interface than
'set_option' calls, let me know.

I will look at the details of what would happen if the librdmacm converted an
AF_INET address into an AF_GID address and used that in the down call to the
rdma_ucm:rdma_resolve_addr.  I suspect that since the original AF_INET address
is not carried in the IB CM REQ, there will be issues matching the REQ with
listens on specific addresses.  This may not be a big deal in practice.  The
rdma_cm would still need the path record data.

>So the output from IBACM would specify on AF_GID address family and
>include opaque data blobs that are passed through the RDMA CM API that
>contain all the PR records, service ID, etc. If used on non-IB then
>IBACM could just return AF_IP/AF_IPV6 and related blobs. Thus the
>consumer of the API gets transparency and network protocol agility,
>and all the mess can be hid in the address resolution API.

This is just debating where the transport abstraction occurs, but IMO the IB ACM
should be IB centric.  Transport abstraction should occur somewhere above it.
This has been the role of the librdmacm.  Adding a new call similar to
getaddrinfo to the librdmacm should be possible, and could actually take
advantage of the IB ACM resolution that converts a host name directly into IB
path data.

This still leaves open the issue of how to communicate that data to the kernel
so that the rdma_cm can format the IB CM REQ correctly and send it on its merry
little way.

>Yes, I see that, but the ARP request is an absolutely critical part of
>the IP world, to eliminate it, but still pretend to be IP really is
>cheating too much, IMHO. :)

We aren't completely getting rid of ARP, we just support an alternate,
non-standard, proprietary address resolution mechanism instead.

>Another topic, but yes, ip route get just does a netlink
>queury. I can give you all the details if you want to try it.

Yes, please - see below

>However as I explained in the thread, I highly skeptical about all of
>this. That query needs to be done exactly once and the connection must
>be bound to that result from then on. Currently too many route lookups
>are done, and adding more to userspace does not seem to be the right
>direction - unless the userspace one replaces all the kernel lookups..

The librdmacm rdma_resolve_addr() call allows a user to specify a destination
address only.  A suitable source address will be selected, and the rdma_cm_id
will be bound to the corresponding RDMA device.  If the librdmacm can
efficiently determine the source address, it can call the IB ACM to resolve the
addresses and obtain the path data.  Otherwise, the call to librdmacm
rdma_resolve_addr() drops into the kernel and operates as it does today, which
can involve sending an ARP.

I haven't been overly concerned about this yet, because the application I'm most
concerned with always calls rdma_bind_addr().

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
