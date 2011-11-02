From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: Re: [PATCH] DAPL v2.0: common: increase default IB ack timer
 from 16 to 20
Date: Wed, 2 Nov 2011 23:31:38 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E931E8@ORSMSX101.amr.corp.intel.com>
References: <54347E5A035A054EAE9D05927FB467F916E93128@ORSMSX101.amr.corp.intel.com>
	<1828884A29C6694DAF28B7E6B8A8237316E8CBCB@ORSMSX101.amr.corp.intel.com>
	<54347E5A035A054EAE9D05927FB467F916E931C5@ORSMSX101.amr.corp.intel.com>
	<1828884A29C6694DAF28B7E6B8A8237316E8CC00@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E8CC00@ORSMSX101.amr.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Hefty, Sean" <sean.hefty@intel.com>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

> > Yes, a user can modify path lifetime via rdma_create_ep() but there
> > is no way for the user to know how much that will be manipulated and
> > increased in the IB CM driver.
> 
> Sure there is.  It's an open source driver.  :)
> 
> The ib_cm calculates the "correct" timeout based on the packet lifetime
> provided by the SA and the CA ack timeout.  If user modifications to
> this value are necessary, then there is a bug in either the SA or HCA
> driver.

or there could be congestion on the fabric that the SA or HCA driver is unaware of. 
