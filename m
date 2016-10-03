From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ibacm: move Documentation to Documentation/
Date: Mon, 3 Oct 2016 14:44:27 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB092274@ORSMSX109.amr.corp.intel.com>
References: <1474677279-30407-1-git-send-email-hch@lst.de>
 <20161003143412.GA18210@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161003143412.GA18210-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Who is merging patches that are submitted to the mailing list?  AFAIK, I don't have write access to the repo.

> ping?
> 
> On Fri, Sep 23, 2016 at 05:34:39PM -0700, Christoph Hellwig wrote:
> > And drop various bits that aren't relevant for our unified tree
> > (Windows support, build instructions, etc).
> >
> > Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > ---
> >  Documentation/ibacm.md | 109 ++++++++++++++++++++++++++++++++++++++
> >  ibacm/acm_notes.txt    | 141 ---------------------------------------
> ----------
> >  2 files changed, 109 insertions(+), 141 deletions(-)
> >  create mode 100644 Documentation/ibacm.md
> >  delete mode 100644 ibacm/acm_notes.txt
> >
> > diff --git a/Documentation/ibacm.md b/Documentation/ibacm.md
> > new file mode 100644
> > index 0000000..8ed293d
> > --- /dev/null
> > +++ b/Documentation/ibacm.md
> > @@ -0,0 +1,109 @@
> > +# The Assistant for InfiniBand Communication Management (IB ACM)
> > +
> > +The IB ACM library implements and provides a framework for name,
> address, and
> > +route resolution services over InfiniBand.  The IB ACM provides
> information
> > +needed to establish a connection, but does not implement the CM
> protocol.
> > +
> > +IB ACM services are used by librdmacm to implement the
> rdma_resolve_addr,
> > +rdma_resolve_route, and rdma_getaddrinfo routines.
> > +
> > +The IB ACM is focused on being scalable and efficient.  The current
> > +implementation limits network traffic, SA interactions, and
> centralized
> > +services.  ACM supports multiple resolution protocols in order to
> handle
> > +different fabric topologies.
> > +
> > +This release is limited in its handling of dynamic changes.
> > +
> > +The IB ACM package is comprised of two components: the ibacm service
> > +and a test/configuration utility - ib_acme.
> > +
> > +# Details
> > +
> > +### ib_acme
> > +
> > +The ib_acme program serves a dual role.  It acts as a utility to
> test
> > +ibacm operation and help verify if the ibacm service and selected
> > +protocol is usable for a given cluster configuration.
> Additionally,
> > +it automatically generates ibacm configuration files to assist with
> > +or eliminate manual setup.
> > +
> > +
> > +### acm configuration files
> > +
> > +The ibacm service relies on two configuration files.
> > +
> > +The acm_addr.cfg file contains name and address mappings for each IB
> > +<device, port, pkey> endpoint.  Although the names in the
> acm_addr.cfg
> > +file can be anything, ib_acme maps the host name and IP addresses to
> > +the IB endpoints.
> > +
> > +The acm_opts.cfg file provides a set of configurable options for the
> > +ibacm service, such as timeout, number of retries, logging level,
> etc.
> > +ib_acme generates the acm_opts.cfg file using static information.  A
> > +future enhancement would adjust options based on the current system
> > +and cluster size.
> > +
> > +### ibacm
> > +
> > +The ibacm service is responsible for resolving names and addresses
> to
> > +InfiniBand path information and caching such data. It is implemented
> as a
> > +daemon that execute with administrative privileges.
> > +
> > +The ibacm implements a client interface over TCP sockets, which is
> > +abstracted by the librdmacm library.  One or more back-end protocols
> are
> > +used by the ibacm service to satisfy user requests.  Although the
> > +ibacm supports standard SA path record queries on the back-end, it
> > +provides an experimental multicast resolution protocol in hope of
> > +achieving greater scalability.  The latter is not usable on all
> fabric
> > +topologies, specifically ones that may not have reversible paths.
> > +Users should use the ib_acme utility to verify that multicast
> protocol
> > +is usable before running other applications.
> > +
> > +Conceptually, the ibacm service implements an ARP like protocol and
> either
> > +uses IB multicast records to construct path record data or queries
> the
> > +SA directly, depending on the selected route protocol.  By default,
> the
> > +ibacm services uses and caches SA path record queries.
> > +
> > +Specifically, all IB endpoints join a number of multicast groups.
> > +Multicast groups differ based on rates, mtu, sl, etc., and are
> prioritized.
> > +All participating endpoints must be able to communicate on the
> lowest
> > +priority multicast group.  The ibacm assigns one or more
> names/addresses
> > +to each IB endpoint using the acm_addr.cfg file.  Clients provide
> source
> > +and destination names or addresses as input to the service, and
> receive
> > +as output path record data.
> > +
> > +The service maps a client's source name/address to a local IB
> endpoint.
> > +If a client does not provide a source address, then the ibacm
> service
> > +will select one based on the destination and local routing tables.
> If the
> > +destination name/address is not cached locally, it sends a multicast
> > +request out on the lowest priority multicast group on the local
> endpoint.
> > +The request carries a list of multicast groups that the sender can
> use.
> > +The recipient of the request selects the highest priority multicast
> group
> > +that it can use as well and returns that information directly to the
> sender.
> > +The request data is cached by all endpoints that receive the
> multicast
> > +request message.  The source endpoint also caches the response and
> uses
> > +the multicast group that was selected to construct or obtain path
> record
> > +data, which is returned to the client.
> > +
> > +The current implementation of the IB ACM has several additional
> restrictions:
> > +- The ibacm is limited in its handling of dynamic changes;
> > +  the ibacm should be stopped and restarted if a cluster is
> reconfigured.
> > +- Support for IPv6 has not been verified.
> > +- The number of addresses that can be assigned to a single endpoint
> is
> > +  limited to 4.
> > +- The number of multicast groups that an endpoint can support is
> limited to 2.
> > +
> > +The ibacm contains several internal caches.  These include  caches
> for
> > +GID  and  LID  destination  addresses.   These caches can be
> optionally
> > +preloaded.  ibacm supports the OpenSM dump_pr plugin "full"
> PathRecord
> > +format which is used to preload these caches.  The file format is
> specified
> > +in the ibacm_opts.cfg file via the route_preload setting which
> should
> > +be set to opensm_full_v1 for this file format.  Default format is
> > +none which does not preload these caches.  See dump_pr.notes.txt in
> dump_pr
> > +for more information on the opensm_full_v1 file format and how to
> configure
> > +OpenSM to generate this file.
> > +
> > +Additionally, the name, IPv4, and IPv6 caches can be be preloaded by
> using
> > +the addr_preload option.  The default is none which does not preload
> these
> > +caches.  To preload these caches, set this option to acm_hosts and
> > +configure the addr_data_file appropriately.
> > diff --git a/ibacm/acm_notes.txt b/ibacm/acm_notes.txt
> > deleted file mode 100644
> > index c975555..0000000
> > --- a/ibacm/acm_notes.txt
> > +++ /dev/null
> > @@ -1,141 +0,0 @@
> > -Assistant for InfiniBand Communication Management (IB ACM)
> > -
> > -Note: The IB ACM should be considered experimental.
> > -
> > -
> > -Overview
> > ---------
> > -The IB ACM package implements and provides a framework for
> experimental name,
> > -address, and route resolution services over InfiniBand.  It is
> intended to
> > -address connection setup scalability issues running MPI applications
> on
> > -large clusters.  The IB ACM provides information needed to establish
> a
> > -connection, but does not implement the CM protocol.
> > -
> > -The librdmacm can invoke IB ACM services when built using the --
> with-ib_acm
> > -option.  The IB ACM services tie in under the rdma_resolve_addr,
> > -rdma_resolve_route, and rdma_getaddrinfo routines.  For maximum
> benefit,
> > -the rdma_getaddrinfo routine should be used, however existing
> applications
> > -should still see significant connection scaling benefits using the
> calls
> > -available in librdmacm 1.0.11 and previous releases.
> > -
> > -The IB ACM is focused on being scalable and efficient.  The current
> > -implementation limits network traffic, SA interactions, and
> centralized
> > -services.  ACM supports multiple resolution protocols in order to
> handle
> > -different fabric topologies.
> > -
> > -This release is limited in its handling of dynamic changes.
> > -
> > -The IB ACM package is comprised of two components: the ibacm service
> > -and a test/configuration utility - ib_acme.  Both are userspace
> components
> > -and are available for Linux and Windows.  Additional details are
> given below.
> > -
> > -
> > -Quick Start Guide
> > ------------------
> > -1. Prerequisites: libibverbs and libibumad must be installed.
> > -   The IB stack should be running with IPoIB configured.
> > -   These steps assume that the user has administrative privileges.
> > -2. Install the IB ACM package
> > -   This installs ibacm, and ib_acme.
> > -3. Run ib_acme -A -O
> > -   This will generate IB ACM address and options configuration
> files.
> > -   (acm_addr.cfg and acm_opts.cfg)
> > -4. Run ibacm -D
> > -   This will run ibacm as service/daemon.
> > -   Because ibacm uses the libibumad interfaces, it should be run
> with
> > -   administrative privileges.
> > -5. Optionally, run ib_acme -s <source_ip> -d <dest_ip> -v
> > -   This will verify that the ibacm service is running.
> > -5. Install librdmacm.
> > -   The librdmacm will automatically use the ibacm service.
> > -   On failures, the librdmacm will fall back to normal resolution.
> > -
> > -
> > -Details
> > --------
> > -ib_acme:
> > -The ib_acme program serves a dual role.  It acts as a utility to
> test
> > -ibacm operation and help verify if the ibacm service and selected
> > -protocol is usable for a given cluster configuration.
> Additionally,
> > -it automatically generates ibacm configuration files to assist with
> > -or eliminate manual setup.
> > -
> > -
> > -acm configuration files:
> > -The ibacm service relies on two configuration files.
> > -
> > -The acm_addr.cfg file contains name and address mappings for each IB
> > -<device, port, pkey> endpoint.  Although the names in the
> acm_addr.cfg
> > -file can be anything, ib_acme maps the host name and IP addresses to
> > -the IB endpoints.
> > -
> > -The acm_opts.cfg file provides a set of configurable options for the
> > -ibacm service, such as timeout, number of retries, logging level,
> etc.
> > -ib_acme generates the acm_opts.cfg file using static information.  A
> > -future enhancement would adjust options based on the current system
> > -and cluster size.
> > -
> > -
> > -ibacm:
> > -The ibacm service is responsible for resolving names and addresses
> to
> > -InfiniBand path information and caching such data. It is implemented
> as a
> > -daemon that execute with administrative privileges.
> > -
> > -The ibacm implements a client interface over TCP sockets, which is
> > -abstracted by the librdmacm library.  One or more back-end protocols
> are
> > -used by the ibacm service to satisfy user requests.  Although the
> > -ibacm supports standard SA path record queries on the back-end, it
> > -provides an experimental multicast resolution protocol in hope of
> > -achieving greater scalability.  The latter is not usable on all
> fabric
> > -topologies, specifically ones that may not have reversible paths.
> > -Users should use the ib_acme utility to verify that multicast
> protocol
> > -is usable before running other applications.
> > -
> > -Conceptually, the ibacm service implements an ARP like protocol and
> either
> > -uses IB multicast records to construct path record data or queries
> the
> > -SA directly, depending on the selected route protocol.  By default,
> the
> > -ibacm services uses and caches SA path record queries.
> > -
> > -Specifically, all IB endpoints join a number of multicast groups.
> > -Multicast groups differ based on rates, mtu, sl, etc., and are
> prioritized.
> > -All participating endpoints must be able to communicate on the
> lowest
> > -priority multicast group.  The ibacm assigns one or more
> names/addresses
> > -to each IB endpoint using the acm_addr.cfg file.  Clients provide
> source
> > -and destination names or addresses as input to the service, and
> receive
> > -as output path record data.
> > -
> > -The service maps a client's source name/address to a local IB
> endpoint.
> > -If a client does not provide a source address, then the ibacm
> service
> > -will select one based on the destination and local routing tables.
> If the
> > -destination name/address is not cached locally, it sends a multicast
> > -request out on the lowest priority multicast group on the local
> endpoint.
> > -The request carries a list of multicast groups that the sender can
> use.
> > -The recipient of the request selects the highest priority multicast
> group
> > -that it can use as well and returns that information directly to the
> sender.
> > -The request data is cached by all endpoints that receive the
> multicast
> > -request message.  The source endpoint also caches the response and
> uses
> > -the multicast group that was selected to construct or obtain path
> record
> > -data, which is returned to the client.
> > -
> > -The current implementation of the IB ACM has several additional
> restrictions:
> > -- The ibacm is limited in its handling of dynamic changes;
> > -  the ibacm should be stopped and restarted if a cluster is
> reconfigured.
> > -- Support for IPv6 has not been verified.
> > -- The number of addresses that can be assigned to a single endpoint
> is
> > -  limited to 4.
> > -- The number of multicast groups that an endpoint can support is
> limited to 2.
> > -
> > -The ibacm contains several internal caches.  These include  caches
> for
> > -GID  and  LID  destination  addresses.   These caches can be
> optionally
> > -preloaded.  ibacm supports the OpenSM dump_pr plugin "full"
> PathRecord
> > -format which is used to preload these caches.  The file format is
> specified
> > -in the ibacm_opts.cfg file via the route_preload setting which
> should
> > -be set to opensm_full_v1 for this file format.  Default format is
> > -none which does not preload these caches.  See dump_pr.notes.txt in
> dump_pr
> > -for more information on the opensm_full_v1 file format and how to
> configure
> > -OpenSM to generate this file.
> > -
> > -Additionally, the name, IPv4, and IPv6 caches can be be preloaded by
> using
> > -the addr_preload option.  The default is none which does not preload
> these
> > -caches.  To preload these caches, set this option to acm_hosts and
> > -configure the addr_data_file appropriately.
> > --
> > 2.1.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
