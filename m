From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/37] librdmacm: add support for AF_IB
Date: Wed, 7 Apr 2010 11:13:11 -0700
Message-ID: <557A544AD7D0493095E79198578620D3@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patch series adds several enhancements to the librdmacm
intended to simplify using RDMA devices and address scalability issues.
Major changes include:

* Adding support for AF_IB.

* The addition of a new API: rdma_getaddrinfo.  This call provides
  functionality similar to getaddrinfo for RDMA devices.  In addition
  to resolving names to addresses, it can also resolve route and
  connection data.  rdma_getaddrinfo can return addresses using
  AF_INET, AF_INET6, and AF_IB.

* Add support for IB ACM.  IB ACM defines a socket based protocol to
  an IB address and route resolution service.  One implementation of that
  service is provided separately, but anyone can implement the service
  provided that they adhere to the IB ACM communication protocol.
  Use of IB ACM is not required.

* Support synchronous operation for library calls.  Users can control
  whether an rdma_cm_id operates asynchronously or synchronously based on
  the rdma_event_channel parameter.  Use of synchronous operations
  reduces the amount of application code required to use the librdmacm.

* Allow the library to abstract RDMA resource creation for simpler RDMA
  applications.  The library can now allocate PDs, CQs, and QPs for the
  user, if not provided.

* Provide a set of helper verbs calls for posting work requests and
  checking for completions.  These are simple wrappers around libibverbs
  calls.

This patch series is also available through my git tree at:

	git://git.openfabrics.org/~shefty/librdmacm.git af_ib

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
