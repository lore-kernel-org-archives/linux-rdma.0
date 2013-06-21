From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 08/15 ibacm] man: Change DOS formatting to unix formatting
Date: Fri, 21 Jun 2013 07:01:58 -0400
Message-ID: <51C432A6.9090003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 man/ib_acme.1 |  162 ++++++++++++++++++++++++++++----------------------------
 man/ibacm.7   |   62 +++++++++++-----------
 2 files changed, 112 insertions(+), 112 deletions(-)

diff --git a/man/ib_acme.1 b/man/ib_acme.1
index c4915cb..d5ac269 100644
--- a/man/ib_acme.1
+++ b/man/ib_acme.1
@@ -1,81 +1,81 @@
-.TH "ib_acme" 7 "2010-12-06" "ib_acme" "ib_acme" ib_acme
-.SH NAME
-ib_acme \- test and configuration utility for the IB ACM
-.SH SYNOPSIS
-.sp
-.nf
-\fIib_acme\fR [-f addr_format] [-s src_addr] -d dest_addr [-v]
-.fi
-.nf
-\fIib_acme\fR [-G] [-O]
-.fi
-.SH "DESCRIPTION"
-ib_acme provides assistance configuring and testing the ibacm service.
-The first usage of the service will test that the ibacm is running
-and operating correctly.  The second usage model will automatically
-create address and configuration files for the ibacm service.
-.SH "OPTIONS"
-.TP
-\-f addr_format
-Specifies the format of the src_addr and dest_addr parameters.  Valid
-address formats are: 'i' ip address, 'n' host name, 'l' lid, 'g' gid,
-and 'u' unspecified.  If the -f option is omitted,
-an unspecified address format is assumed.  ib_acme will use getaddrinfo or
-other mechanisms to determine which format the address uses.
-.TP
-\-s src_addr
-Specifies the local source address of the path to resolve.  The source
-address can be an IP address, system network name, or LID, as indicated by
-the addr_format option.
-.TP
-\-d dest_addr
-Specifies the destination address of the path to resolve.  The destination
-address can be an IP address, system network name, or LID, as indicated by
-the addr_format option.
-.TP
-\-v
-Indicates that the resolved path information should be verified with the
-active IB SA.  Use of the -v option provides a sanity check that
-resolved path information is usable given the current cluster configuration.
-.TP
-\-c
-Instructs the ACM service to only returned information that currently resides
-in its local cache.
-.TP
-\-A
-With this option, the ib_acme utility automatically generates the address
-configuration file ibacm_addr.cfg.  The generated file is
-constructed using the system host name and any IP addresses that are
-assigned to IPoIB device instances.
-.TP
-\-O
-With this option, the ib_acme utility automatically generates the option
-configuration file ibacm_opts.cfg.  The generated file is currently generated
-using static information.
-.TP
-\-V
-Enables verbose output.  When combined with -A or -O options, ib_acme will
-display additional details, such as generated address information saved
-to the ibacm_addr.cfg file.
-.SH "NOTES"
-The ib_acme utility performs two main functions.  With the -A and -O options,
-it automatically generates address or options configuration files.  The
-generated files are text based and may be edited.  These options are intended
-to provide a simple way to configure address and option information on all
-nodes on a cluster.
-.P
-The other function of the ib_acme utility is to test the ibacm service,
-including helping to verify that the service is usable given the current
-cluster configuration.  The ib_acme utility can resolve IP addresses,
-network names, or IB LIDs into a path record.  It can then compare that
-path record against one obtained by the SA.  When used to test the
-ibacm service, the ib_acme utility has the side effect of loading the
-ibacm caches.
-.P
-Multiple, numerical destinations can be specified by adding brackets [] to
-the end of a base destination name or address.  Users may specify a list of
-numerical ranges inside the brackets using the following example as a
-guide: node[1-3,5,7-8].  This will result in testing node1, node2, node3,
-node5, node7, and node8.   
-.SH "SEE ALSO"
-ibacm(7) ibacm(1)
+.TH "ib_acme" 7 "2010-12-06" "ib_acme" "ib_acme" ib_acme
+.SH NAME
+ib_acme \- test and configuration utility for the IB ACM
+.SH SYNOPSIS
+.sp
+.nf
+\fIib_acme\fR [-f addr_format] [-s src_addr] -d dest_addr [-v]
+.fi
+.nf
+\fIib_acme\fR [-G] [-O]
+.fi
+.SH "DESCRIPTION"
+ib_acme provides assistance configuring and testing the ibacm service.
+The first usage of the service will test that the ibacm is running
+and operating correctly.  The second usage model will automatically
+create address and configuration files for the ibacm service.
+.SH "OPTIONS"
+.TP
+\-f addr_format
+Specifies the format of the src_addr and dest_addr parameters.  Valid
+address formats are: 'i' ip address, 'n' host name, 'l' lid, 'g' gid,
+and 'u' unspecified.  If the -f option is omitted,
+an unspecified address format is assumed.  ib_acme will use getaddrinfo or
+other mechanisms to determine which format the address uses.
+.TP
+\-s src_addr
+Specifies the local source address of the path to resolve.  The source
+address can be an IP address, system network name, or LID, as indicated by
+the addr_format option.
+.TP
+\-d dest_addr
+Specifies the destination address of the path to resolve.  The destination
+address can be an IP address, system network name, or LID, as indicated by
+the addr_format option.
+.TP
+\-v
+Indicates that the resolved path information should be verified with the
+active IB SA.  Use of the -v option provides a sanity check that
+resolved path information is usable given the current cluster configuration.
+.TP
+\-c
+Instructs the ACM service to only returned information that currently resides
+in its local cache.
+.TP
+\-A
+With this option, the ib_acme utility automatically generates the address
+configuration file ibacm_addr.cfg.  The generated file is
+constructed using the system host name and any IP addresses that are
+assigned to IPoIB device instances.
+.TP
+\-O
+With this option, the ib_acme utility automatically generates the option
+configuration file ibacm_opts.cfg.  The generated file is currently generated
+using static information.
+.TP
+\-V
+Enables verbose output.  When combined with -A or -O options, ib_acme will
+display additional details, such as generated address information saved
+to the ibacm_addr.cfg file.
+.SH "NOTES"
+The ib_acme utility performs two main functions.  With the -A and -O options,
+it automatically generates address or options configuration files.  The
+generated files are text based and may be edited.  These options are intended
+to provide a simple way to configure address and option information on all
+nodes on a cluster.
+.P
+The other function of the ib_acme utility is to test the ibacm service,
+including helping to verify that the service is usable given the current
+cluster configuration.  The ib_acme utility can resolve IP addresses,
+network names, or IB LIDs into a path record.  It can then compare that
+path record against one obtained by the SA.  When used to test the
+ibacm service, the ib_acme utility has the side effect of loading the
+ibacm caches.
+.P
+Multiple, numerical destinations can be specified by adding brackets [] to
+the end of a base destination name or address.  Users may specify a list of
+numerical ranges inside the brackets using the following example as a
+guide: node[1-3,5,7-8].  This will result in testing node1, node2, node3,
+node5, node7, and node8.   
+.SH "SEE ALSO"
+ibacm(7) ibacm(1)
diff --git a/man/ibacm.7 b/man/ibacm.7
index c0c63fc..06acf5b 100644
--- a/man/ibacm.7
+++ b/man/ibacm.7
@@ -1,31 +1,31 @@
-.TH "IBACM" 7 "2012-03-01" "IBACM" "IB ACM User Guide" IBACM
-.SH NAME
-ibacm \- InfiniBand communication management assistant
-.SH SYNOPSIS
-.B "#include <infiniband/ib_acm.h>"
-.SH "DESCRIPTION"
-Used to resolve remote endpoint information before establishing communications
-over InfiniBand.
-.SH "NOTES"
-Th IB ACM provides scalable address and route resolution services over
-InfiniBand.  It resolves system network names and IP addresses to InfiniBand
-path record data using efficient mechanisms, including caching of data.
-.P
-The IB ACM provides information needed to establish a connection, but does
-not implement the communication management protocol.  It provides services
-similar to rdma_getaddrinfo, rdma_resolve_addr, and rdma_resolve_route using
-IB multicast.
-The IB ACM does not require IPoIB or use standard naming services, such as
-DNS, and limits network communication, especially with the IB SA.
-The ib_acme utility assists in verifying what options of the ibacm service
-may be usable for the current fabric topology.
-.P
-Client interactions with the ibacm service are done over sockets through
-a standard TCP connection.  The librdmacm abstracts this interaction.
-.SH "RETURN CODES"
-.IP "== 0"
-success
-.IP "!= 0"
-error
-.SH "SEE ALSO"
-ib_acme(1), ibacm(1)
+.TH "IBACM" 7 "2012-03-01" "IBACM" "IB ACM User Guide" IBACM
+.SH NAME
+ibacm \- InfiniBand communication management assistant
+.SH SYNOPSIS
+.B "#include <infiniband/ib_acm.h>"
+.SH "DESCRIPTION"
+Used to resolve remote endpoint information before establishing communications
+over InfiniBand.
+.SH "NOTES"
+Th IB ACM provides scalable address and route resolution services over
+InfiniBand.  It resolves system network names and IP addresses to InfiniBand
+path record data using efficient mechanisms, including caching of data.
+.P
+The IB ACM provides information needed to establish a connection, but does
+not implement the communication management protocol.  It provides services
+similar to rdma_getaddrinfo, rdma_resolve_addr, and rdma_resolve_route using
+IB multicast.
+The IB ACM does not require IPoIB or use standard naming services, such as
+DNS, and limits network communication, especially with the IB SA.
+The ib_acme utility assists in verifying what options of the ibacm service
+may be usable for the current fabric topology.
+.P
+Client interactions with the ibacm service are done over sockets through
+a standard TCP connection.  The librdmacm abstracts this interaction.
+.SH "RETURN CODES"
+.IP "== 0"
+success
+.IP "!= 0"
+error
+.SH "SEE ALSO"
+ib_acme(1), ibacm(1)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
