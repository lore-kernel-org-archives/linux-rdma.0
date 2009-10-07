From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 6 Oct 2009 23:26:39 -0600
Message-ID: <20091007052639.GB18578@obsidianresearch.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <20091006200739.GP5191@obsidianresearch.com> <B266C10D3C26431E8FF5012420132452@amr.corp.intel.com> <20091006231720.GR5191@obsidianresearch.com> <3F7D26D4BA1C46F18F2F87BDD7EB7F36@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F7D26D4BA1C46F18F2F87BDD7EB7F36-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 06, 2009 at 06:20:05PM -0700, Sean Hefty wrote:

> There are 3 interfaces of interest here.  The librdmacm API, the rdma_ucm user
> to kernel interface, and the rdma_cm interface.  These patches are looking to
> change the rdma_ucm interface.  I want to avoid changing the API or behavior of
> the librdmacm in a way that requires changes to existing applications in order
> to run on larger clusters. 

So, I'm just talking about the user space API, the others can be
changed as necessary to align with it. 

This is open source, so choosing a technically better solution over a
endlessly backwards compatible solution is done all the time and is
normal, expected, etc. Cost of progress - that is the underlying
rational of Documentation/stable_api_nonsense.txt, and it applies just
as well to niche little user space libraries like these :)

> >So the output from IBACM would specify on AF_GID address family and
> >include opaque data blobs that are passed through the RDMA CM API that
> >contain all the PR records, service ID, etc. If used on non-IB then
> >IBACM could just return AF_IP/AF_IPV6 and related blobs. Thus the
> >consumer of the API gets transparency and network protocol agility,
> >and all the mess can be hid in the address resolution API.
> 
> This is just debating where the transport abstraction occurs, but IMO the IB ACM
> should be IB centric.  Transport abstraction should occur somewhere
> above it.

Actually, I'm arguing that RDMA CM should have been a transport
mux/switch like socket() rather than just an IP addressing abstraction.

If it is a mux then an app coded to RDMA CM could speak native IB GID
addressing on the same API and the scaling problems related to arp and
the implict kernel PR query of the IP abstraction can be neatly
eliminated, by eliminating the abstraction. It is the abstraction to
IP addresses that is the root inefficiency - we need a transport
protocol agnostic API for CM that lets the native transport addressing
be used - not an abstraction layer (abstractions are always the bane
of efficiency)..

If you want to have a naming layer in user space that converts
*whatever* to GIDs then fine, great, but lets call it that and not
co-mingle it with the IP address abstraction layer.

Adding IB CM semantics to the RDMA CM API does not seem to be too
hard:
 rdma_create_id uses an new RDMA_PS_IB to signal IB CM behavior
 rmda_resolve_addr and all other functions use a sockaddr that is an
   IB GID, pkey, service ID etc. rdma_resolve_addr at least grows a
   new parameter which is a 'hw address'. This is mandatory for
   RDMA_PS_IB and is up to 5 PR records. (1 for CM path,
   forward/reverse for primary, and forward/reverse for alternative)

 rdma_get_addr_info return a struct with the rdma_port_space, sockaddr
 src, sockaddr dest and 'hw address' values that the app blindly plugs
 into the calls. libacm type function is implemented entirely in the
 rdma_get_addr_info.

The trade off is that apps that want to scale use IB GID addressing,
IB GID CM, and IB service ID at the rdma_cm layer, and libacm provides
a name mapping from hostname or IP to GID, if its being used. No IP
addreses, no IP listen matching, no port space TCP issues. Just
straight IB services IDs.

Pretty much the symmetry is simple.. The Kernel always takes care of
IP hardware addressing, userspace always takes care of IB
hardware addressing. Nature of the two protocols.

> This still leaves open the issue of how to communicate that data to the kernel
> so that the rdma_cm can format the IB CM REQ correctly and send it on its merry
> little way.

The rdma_ucm interface would have to be extended to be able to do 100%
of the functionality of the ib cm interface using the rdma_cm_id
abstraction. This is very useful in of itself and much better than
adding an obscure option to override the ARP query. For instance,
other MPIs could immediately provide their users an option to use GID
addresess directly and cut out the ARP overhead instantly with
little code change.

> >Another topic, but yes, ip route get just does a netlink
> >queury. I can give you all the details if you want to try it.
> 
> Yes, please - see below

I'll look in my codes, remind me if I forget, I can't do it just now
..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
